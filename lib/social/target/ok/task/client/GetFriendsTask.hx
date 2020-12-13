package social.target.ok.task.client;

import js.lib.Error;
import loader.DataFormat;
import loader.ILoader;
import loader.Request;
import social.network.INetworkClient;
import social.target.ok.objects.BaseError;
import social.task.client.IGetFriendsTask;
import social.user.User;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация запроса списка друзей в Одноклассниках.  
 * Используется на клиентской стороне.
 */
@:dce
class GetFriendsTask implements IGetFriendsTask 
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
    public var user(default, null):UserID               = null;
    public var result(default, null):Array<UserID>      = null;
    public var error(default, null):Error               = null;
    public var repeats(default, null):Int               = 0;
    public var priority(default, null):Int              = 0;
    public var isComplete(default, null):Bool           = false;
    public var onComplete:IGetFriendsTask->Void         = null;
    public var userData:Dynamic                         = null;
    private var lr:ILoader = #if nodejs null; #else new loader.xhr.LoaderXHR(); #end
    private var r:Int = 0;

    public function start():Void {
        var net:OdnoklassnikiClient = untyped network;
        var params = [
            "fid=" + user,
            "application_key=" + net.applicationKey,
            "session_key=" + net.token,
            
        ];
        var req = new Request(network.apiURL + "friends/get");
        req.data = params.join("&");
        lr.dataFormat = DataFormat.JSON;
        lr.priority = priority;
        lr.balancer = network.balancer;
        lr.onComplete = onResponse;
        lr.load(req);
    }

    public function cancel():Void {
        if (isComplete)
            return;

        isComplete = true;

        if (lr != null) {
            lr.onComplete = null;
            lr.balancer = null;
            lr.close();
            lr = null;
        }
    }

    private function onResponse(lr:ILoader):Void {

        // Разбор ответа
        // Сетевая ошибка или некорректный формат ответ:
        if (lr.error != null) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.REQUEST_ERROR, [network.apiURL + "friends/get", Tools.err(lr.error)]));
            isComplete = true;
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Пустой ответ:
        if (lr.data == null) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_EMPTY, [network.apiURL + "friends/get"]));
            isComplete = true;
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Ошибки API:
        var errors:BaseError = lr.data;
        if (errors.error_code != null) {
            if (r++ < repeats && !network.apiFatalErrors.get(errors.error_code)) {
                start();
            }
            else {
                // Повторный запрос бесполезен:
                error = new Error(Tools.msg(ErrorMessages.RESPONSE_ERROR, [network.apiURL + "friends/get", errors.error_code, errors.error_msg]));
                isComplete = true;
                if (onComplete != null)
                    onComplete(this);
            }
            return;
        }

        // Ожидается массив:
        try {
            var res:Array<UserID> = new Array();
            var arr:Array<Dynamic> = lr.data;
            var len = arr.length;
            var i = 0;
            while (i < len) {
                res[i] = NativeJS.str(arr[i]);
                i ++;
            }
            result = res;
        }
        catch (err:Dynamic) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_WRONG, [network.apiURL + "friends/get", Tools.err(err)]));
            isComplete = true;
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Всё ок:
        isComplete = true;
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[GetFriendsTask]";
    }
}