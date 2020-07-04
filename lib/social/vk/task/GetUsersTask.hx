package social.vk.task;

import haxe.DynamicAccess;
import loader.ILoader;
import loader.Request;
import loader.jsonp.LoaderJSONP;
import social.SocialUserFields;
import social.task.IGetUsersTask;
import social.vk.enums.ErrorCode;
import social.vk.objects.BaseError;
import js.Syntax;
import js.lib.Error;

class GetUsersTask implements IGetUsersTask 
{
    /**
     * Максимальное количество запрашиваемых пользователей за один запрос. (VK)
     */
    static public inline var MAX_USERS:Int = 1000;

    /**
     * Создать задачу запроса данных пользователей.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:VKontakte) {
        this.network = network;
    }

    public var network(default, null):ISocialNetwork;
    public var users:Array<SocialUser>;
    public var fields:SocialUserFields = SocialUserField.FIRST_NAME | SocialUserField.LAST_NAME | SocialUserField.AVATAR_100 | SocialUserField.DELETED;
    public var error:Error = null;
    public var requestRepeatTry:Int = 0;
    public var priority:Int = 0;
    public var onComplete:IGetUsersTask->Void = null;
    public var onProgress:IGetUsersTask->DynamicAccess<SocialUser>->Void = null;

    private var loaders:Array<ILoader>;

    public function start():Void {
        var vk:VKontakte = untyped network;
        var len = users.length;
        if (len == 0) {
            var f1 = onProgress;
            var f2 = onComplete;
            if (f1 != null)
                f1(this, {});
            if (f2 != null)
                f2(this);
            return;
        }

        // Подготовка данных, нарезка:
        var maps:Array<DynamicAccess<SocialUser>> = [{}];
        var i = 0;
        var index = 0;
        var limit = MAX_USERS;
        while (i < len) {
            var user = users[i++];
            maps[index][user.id] = user;
            limit --;

            if (limit == 0) {
                limit = MAX_USERS;
                index ++;
                maps[index] = {};
            }
        }
        if (limit == MAX_USERS) // Пользователей ровно MAX_USERS, удаляем пустую мапу! (Частный случай)
            maps.resize(maps.length - 1);

        // Инициируем запросы:
        var fds = vk.parser.getUserFields(fields);
        i = 0;
        len = maps.length;
        loaders = new Array();
        while (i < len) {
            var req = new Request(VKontakte.API_URL + "users.get");
            req.data =  "user_ids=" + getUsersIDS(maps[i]) + 
                        (fds==''?'':("&fields=" + fds)) +
                        "&v=" + VKontakte.API_VERSION +
                        "&access_token=" + vk.token;

            var info:LoaderInfo = { 
                complete:false, 
                count:1, 
                req:req,
                users:maps[i],
            };

            loaders[i] = new LoaderJSONP();
            loaders[i].priority = priority;
            loaders[i].balancer = vk.balancer;
            loaders[i].onComplete = onResponse;
            loaders[i].userData = info;
            loaders[i].load(req);
            i ++;
        }
    }

    public function cancel():Void {
        if (loaders == null)
            return;

        var arr = loaders;
        var i = arr.length;
        
        loaders = null;

        while (i-- > 0)
            arr[i].purge();
    }

    private function onResponse(lr:ILoader):Void {
        var info:LoaderInfo = lr.userData;
        var vk:VKontakte = untyped network;

        // Сетевая ошибка:
        if (lr.error != null) {
            if (info.count < requestRepeatTry) {
                info.count ++;
                lr.load(info.req);
                return;
            }

            error = lr.error;
            info.complete = true;
            checkComplete();
            return;
        }

        // Пустой ответ:
        if (lr.data == null) {
            if (info.count < requestRepeatTry) {
                info.count ++;
                lr.load(info.req);
                return;
            }

            error = new Error("Empty response of vk get users");
            info.complete = true;
            checkComplete();
            return;
        }

        // Ошибки VK:
        var errors:BaseError = lr.data.error;
        if (errors != null) {

            // 113 - Частный случай НЕ ошибки:
            if (errors.error_code == ErrorCode.WRONG_USER_ID) {

                // При запросе только 1 пользователя, если он не существует - возвращает эту ошибку.
                // При запросе нескольких пользователей возвращает просто пустой ответ без ошибки.
                // По сути, это не ошибка, просто пользователя не существует!

                vk.parser.readUser(null, getFirstMapItem(info.users), fields);
                info.complete = true;
                checkComplete();
                return;
            }

            // Неисправимые ошибки: (Повторный запрос - бесполезен)
            if (    errors.error_code == ErrorCode.AUTHORISATION_FAILED
            ) {
                error = lr.error;
                info.complete = true;
                checkComplete();
                return;
            }

            // Возможно, повторный запрос исправит проблему: (VK Иногда может тупить)
            if (info.count < requestRepeatTry) {
                info.count ++;
                lr.load(info.req);
                return;
            }

            // Всё - хуйня приехали:
            error = new Error(errors.error_msg);
            info.complete = true;
            checkComplete();
            return;
        }

        // Ожидаем массив с объектами:
        try {
            var arr:Array<Dynamic> = lr.data.response;
            var len = arr.length;
            var received = new DynamicAccess<Bool>();
            while (len-- > 0) {
                var item = arr[len];
                var user = info.users[item.id];
                received[user.id] = true;
                vk.parser.readUser(item, user, fields);
            }

            // Тех, кого VK не вернул - удалены или не существуют:
            var id:SID = null;
            Syntax.code('for ({0} in {1}) {', id, info.users); // for start
                if (!received[id]) vk.parser.readUser(null, info.users[id], fields);
            Syntax.code('}'); // for end
        }
        catch (err:Dynamic) {
            if (info.count < requestRepeatTry) {
                info.count ++;
                lr.load(info.req);
                return;
            }

            var msg:String = "Error read get users vk response:\n";
            if (err.message == null) {
                error = new Error(msg + Utils.str(err));
            }
            else {
                err.message = msg + Utils.str(err.message);
                error = err;
            } 

            info.complete = true;
            checkComplete();
            return;
        }

        // Ответ успешно разобран:
        info.complete = true;
        if (onProgress != null)
            onProgress(this, info.users);
        checkComplete();
    }

    private function checkComplete():Void {
        var len = loaders.length;
        while (len-- > 0) {
            var info:LoaderInfo = loaders[len].userData;
            if (!info.complete)
                return;
        }

        cancel();

        var f = onComplete;
        onComplete = null;
        if (f != null)
            f(this);
    }

    static private function getUsersIDS(map:DynamicAccess<SocialUser>):String {
        var str:String = '';
        Syntax.code('for (var key in {0}) {1} += key + ","', map, str); // for in
        return str==''?'':str.substring(0,str.length-1);
    }

    static private function getFirstMapItem(map:DynamicAccess<SocialUser>):SocialUser {
        Syntax.code("for (var key in {0}) return {0}[key];", map);
        return null;
    }

    @:keep
    public function toString():String {
        return "[GetUsersTask VK users=" + users.length + "]";
    }
}

/**
 * Параметры отдельного загрузчика.
 */
private typedef LoaderInfo =
{
    /**
     * Работа выполнена.
     */
    var complete:Bool;

    /**
     * Количество попыток запроса.
     */
    var count:Int;

    /**
     * Параметры запроса.
     */
    var req:Request;

    /**
     * Список загружаемых пользователей.
     */
    var users:DynamicAccess<SocialUser>;
}