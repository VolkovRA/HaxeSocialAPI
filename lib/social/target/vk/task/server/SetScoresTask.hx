package social.target.vk.task.server;

import js.lib.Error;
import loader.DataFormat;
import loader.ILoader;
import loader.Method;
import loader.Request;
import social.network.INetworkServer;
import social.target.vk.objects.BaseError;
import social.task.server.ISetScoresTask;
import social.user.User;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация установки очков игрока.
 */
@:dce
class SetScoresTask implements ISetScoresTask
{
    /**
     * Создать задачу.
     * @param network Реализация интерфейса социальной сети.
     */
     public function new(network:INetworkServer) {
        this.network = network;
        this.repeats = network.repeats;
    }

    public var network(default, null):INetworkServer    = null;
    public var user(default, null):UserID               = null;
    public var error(default, null):Error               = null;
    public var token(default, null):String              = null;
    public var scores(default, null):Int                = 0;
    public var priority(default, null):Int              = 0;
    public var repeats(default, null):Int               = 0;
    public var isComplete(default, null):Bool           = false;
    public var userData:Dynamic                         = null;
    public var onComplete:ISetScoresTask->Void          = null;
    private var r:Int                                   = 0;
    private var lr:ILoader = #if nodejs new loader.nodejs.LoaderNodeJS(); #else null; #end

    public function start():Void {
        var req = new Request(network.apiURL + "secure.addAppEvent");
        req.method = Method.POST;
        req.data =  "user_id=" + user + 
                    "&activity_id=2" +
                    "&value=" + NativeJS.str(scores) +
                    "&v=" + network.apiVersion +
                    "&access_token=" + token;
        lr.priority = priority;
        lr.balancer = network.balancer;
        lr.onComplete = onResponse;
        lr.dataFormat = DataFormat.JSON;
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
            error = new Error(Tools.msg(ErrorMessages.REQUEST_ERROR, [network.apiURL + "secure.addAppEvent", Tools.err(lr.error)]));
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
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_EMPTY, [network.apiURL + "secure.addAppEvent"]));
            isComplete = true;
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Ошибки API:
        var errors:BaseError = lr.data.error;
        if (errors != null) {
            if (r++ < repeats && !network.apiFatalErrors.get(errors.error_code)) {
                start();
            }
            else {
                error = new Error(Tools.msg(ErrorMessages.RESPONSE_ERROR, [network.apiURL + "secure.addAppEvent", errors.error_code, errors.error_msg]));
                isComplete = true;
                if (onComplete != null)
                    onComplete(this);
            }
            return;
        }

        // Разбор ответа:
        if (lr.data.response != 1) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_WRONG, [network.apiURL + "secure.addAppEvent", Std.string(lr.data.response)]));
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
        return "[SetScoresTask]";
    }
}