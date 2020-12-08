package social.target.vk.task.client;

import haxe.DynamicAccess;
import js.Syntax;
import js.lib.Error;
import loader.ILoader;
import loader.Request;
import social.network.INetworkClient;
import social.task.client.IGetUsersTask;
import social.target.vk.enums.ErrorCode;
import social.target.vk.objects.BaseError;
import social.user.User;
import social.user.UserField;
import social.utils.NativeJS;

/**
 * Реализация запроса данных пользователей.
 * Может быть использован на клиенте и на сервере.
 */
@:dce
class GetUsersTask implements IGetUsersTask 
{
    /**
     * Создать задачу запроса данных пользователей.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetworkClient) {
        this.network = network;
        this.requestRepeatTry = network.requestRepeatTry;
    }

    public var network(default, null):INetworkClient;
    public var token:String = null;
    public var users:Array<User>;
    public var fields:UserFields = UserField.FIRST_NAME | UserField.LAST_NAME | UserField.AVATAR_100 | UserField.DELETED;
    public var error:Error = null;
    public var requestRepeatTry:Int = 0;
    public var priority:Int = 0;
    public var onComplete:IGetUsersTask->Void = null;
    public var onProgress:IGetUsersTask->DynamicAccess<User>->Void = null;
    public var userData:Dynamic = null;

    private var loaders:Array<ILoader>;

    public function start():Void {
        var parser:Parser = untyped network.parser;

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
        var maps:Array<DynamicAccess<User>> = [{}];
        var i = 0;
        var index = 0;
        var limit = network.capabilities.getUsersMax;
        while (i < len) {
            var user = users[i++];
            maps[index][user.id] = user;
            limit --;

            if (limit == 0) {
                limit = network.capabilities.getUsersMax;
                index ++;
                maps[index] = {};
            }
        }
        if (limit == network.capabilities.getUsersMax) // Пользователей ровно максимум, удаляем пустую мапу! (Частный случай)
            maps.resize(maps.length - 1);

        // Инициируем запросы:
        var fds = parser.getUserFields(fields);
        i = 0;
        len = maps.length;
        loaders = new Array();
        while (i < len) {
            var req = new Request(network.apiURL + "users.get");
            req.data =  "user_ids=" + getUsersIDS(maps[i]) + 
                        (fds==''?'':("&fields=" + fds)) +
                        "&v=" + network.apiVersion +
                        "&access_token=" + token;

            var info:LoaderInfo = { 
                complete:false, 
                repeats:0, 
                req:req,
                users:maps[i],
            };

            loaders[i] = #if nodejs null; #else new loader.jsonp.LoaderJSONP(); #end
            loaders[i].priority = priority;
            loaders[i].balancer = network.balancer;
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

        // Сетевая ошибка:
        if (lr.error != null) {
            if (info.repeats++ < requestRepeatTry) {
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
            if (info.repeats++ < requestRepeatTry) {
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

                network.parser.readUser(null, getFirstMapItem(info.users), fields);
                info.complete = true;
                checkComplete();
                return;
            }

            // Неисправимые ошибки: (Повторный запрос - бесполезен)
            if (    errors.error_code == ErrorCode.AUTHORISATION_FAILED ||
                    errors.error_code == ErrorCode.WRONG_VALUE
            ) {
                error = lr.error;
                info.complete = true;
                checkComplete();
                return;
            }

            // Возможно, повторный запрос исправит проблему: (VK Иногда может тупить)
            if (info.repeats++ < requestRepeatTry) {
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
                network.parser.readUser(item, user, fields);
            }

            // Тех, кого VK не вернул - удалены или не существуют:
            var id:UserID = null;
            Syntax.code('for ({0} in {1}) {', id, info.users); // for start
                if (!received[id]) network.parser.readUser(null, info.users[id], fields);
            Syntax.code('}'); // for end
        }
        catch (err:Dynamic) {
            if (info.repeats++ < requestRepeatTry) {
                lr.load(info.req);
                return;
            }

            var msg:String = "Error read get users vk response:\n";
            if (err.message == null) {
                error = new Error(msg + NativeJS.str(err));
            }
            else {
                err.message = msg + NativeJS.str(err.message);
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

    static private function getUsersIDS(map:DynamicAccess<User>):String {
        var str:String = '';
        Syntax.code('for (var key in {0}) {1} += key + ","', map, str); // for in
        return str==''?'':str.substring(0,str.length-1);
    }

    static private function getFirstMapItem(map:DynamicAccess<User>):User {
        Syntax.code("for (var key in {0}) return {0}[key];", map);
        return null;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[GetUsersTask]";
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
     * Количество попыток резапроса.
     */
    var repeats:Int;

    /**
     * Параметры запроса.
     */
    var req:Request;

    /**
     * Список загружаемых пользователей.
     */
    var users:DynamicAccess<User>;
}