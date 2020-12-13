package social.target.ok.task.client;

import haxe.DynamicAccess;
import js.Syntax;
import js.lib.Error;
import loader.DataFormat;
import loader.ILoader;
import loader.Request;
import social.network.INetworkClient;
import social.target.ok.objects.BaseError;
import social.task.client.IGetUsersTask;
import social.user.User;
import social.user.UserField;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация запроса данных пользователей.
 */
@:dce
class GetUsersTask implements IGetUsersTask 
{
    /**
     * Создать задачу.
     * @param network Реализация интерфейса социальной сети.
     */
    public function new(network:INetworkClient) {
        this.network = network;
        this.repeats = network.repeats;
    }

    public var network(default, null):INetworkClient    = null;
    public var token(default, null):String              = null;
    public var users(default, null):Array<User>         = null;
    public var fields(default, null):UserFields         = 0;
    public var error(default, null):Error               = null;
    public var repeats(default, null):Int               = 0;
    public var priority(default, null):Int              = 0;
    public var isComplete(default, null):Bool           = false;
    public var userData:Dynamic                         = null;
    public var onComplete:IGetUsersTask->Void           = null;
    public var onProgress:IGetUsersTask->DynamicAccess<User>->Void = null;
    private var loaders:Array<ILoader>                  = null;

    public function start():Void {
        var net:OdnoklassnikiClient = untyped network;
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
        i = 0;
        len = maps.length;
        loaders = new Array();
        while (i < len) {
            var req = new Request(network.apiURL + "users/getInfo");
            req.data =  "uids=" + NativeJS.mapKeys(maps[i], ",") + 
                        "&fields=" + net.parser.getUserFields(fields==0?Tools.getAllUserFields():fields) +
                        "&emptyPictures=true" +
                        "&application_key=" + net.applicationKey +
                        "&session_key=" + net.token;

            var info:LoaderInfo = { 
                complete:false, 
                r:0, 
                req:req,
                users:maps[i],
            };

            loaders[i] = #if nodejs null; #else new loader.xhr.LoaderXHR(); #end
            loaders[i].dataFormat = DataFormat.JSON;
            loaders[i].priority = priority;
            loaders[i].balancer = network.balancer;
            loaders[i].onComplete = onResponse;
            loaders[i].userData = info;
            loaders[i].load(req);
            i ++;
        }
    }

    public function cancel():Void {
        if (isComplete)
            return;

        isComplete = true;

        if (loaders != null) {
            var arr = loaders;
            var i = arr.length;
            loaders = null;
            while (i-- > 0)
                arr[i].purge();
        }
    }

    private function onResponse(lr:ILoader):Void {
        var info:LoaderInfo = lr.userData;
        var ff = fields==0?Tools.getAllUserFields():fields;

        // Разбор ответа
        // Сетевая ошибка или некорректный формат ответ:
        if (lr.error != null) {
            if (info.r++ < repeats) {
                lr.load(info.req);
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.REQUEST_ERROR, [network.apiURL + "users/getInfo", Tools.err(lr.error)]));
            info.complete = true;
            checkComplete();
            return;
        }

        // Пустой ответ:
        if (lr.data == null) {
            if (info.r++ < repeats) {
                lr.load(info.req);
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_EMPTY, [network.apiURL + "users/getInfo"]));
            info.complete = true;
            checkComplete();
            return;
        }

        // Ошибки API:
        var errors:BaseError = lr.data;
        if (errors.error_code != null) {
            if (info.r++ < repeats && !network.apiFatalErrors.get(errors.error_code)) {
                lr.load(info.req);
            }
            else {
                error = new Error(Tools.msg(ErrorMessages.RESPONSE_ERROR, [network.apiURL + "users/getInfo", errors.error_code, errors.error_msg]));
                info.complete = true;
                checkComplete();
            }
            return;
        }

        // Ожидаем массив с объектами:
        try {
            var arr:Array<Dynamic> = lr.data;
            var len = arr.length;
            var received = new DynamicAccess<Bool>();
            while (len-- > 0) {
                var item = arr[len];
                var user = info.users[item.uid];
                received[user.id] = true;
                network.parser.readUser(item, user, ff);
            }

            // Тех, кого OK не вернул - удалены или не существуют:
            var id:UserID = null;
            Syntax.code('for ({0} in {1}) {', id, info.users); // for start
                if (!received[id]) network.parser.readUser(null, info.users[id], ff);
            Syntax.code('}'); // for end
        }
        catch (err:Dynamic) {
            if (info.r++ < repeats) {
                lr.load(info.req);
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_WRONG, [network.apiURL + "users/getInfo", Tools.err(err)]));
            info.complete = true;
            checkComplete();
            return;
        }

        // Всё ок:
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
        if (onComplete != null)
            onComplete(this);
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
    var r:Int;

    /**
     * Параметры запроса.
     */
    var req:Request;

    /**
     * Список загружаемых пользователей.
     */
    var users:DynamicAccess<User>;
}