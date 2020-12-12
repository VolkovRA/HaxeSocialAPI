package social.target.vk.task.server;

import js.lib.Error;
import loader.DataFormat;
import loader.ILoader;
import loader.Method;
import loader.Request;
import social.target.vk.enums.ErrorCode;
import social.target.vk.objects.BaseError;
import social.network.INetworkServer;
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
     * @param network Реализация соц. сети VK.
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
        lr.onComplete = null;
        lr.balancer = null;
        lr.close();
        lr = null;
    }

    private function onResponse(lr:ILoader):Void {
        
        // Разбор ответа.
        // Сетевая ошибка:
        if (lr.error != null) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = lr.error;
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
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_EMPTY, ["secure.addAppEvent"]));
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Ошибки VK:
        var errors:BaseError = lr.data.error;
        if (errors != null) {
            // Неисправимые ошибки: (Повторный запрос - бесполезен)
            if (    errors.error_code == ErrorCode.USER_DEACTIVATED ||
                    errors.error_code == ErrorCode.USER_REMOVED ||
                    errors.error_code == ErrorCode.WRONG_VALUE ||
                    errors.error_code == ErrorCode.AUTHORISATION_FAILED
            ) {
                error = new Error(errors.error_msg);
                if (onComplete != null)
                    onComplete(this);
                return;
            }

            // Возможно, повторный запрос исправит проблему: (VK Иногда может тупить)
            if (r++ < repeats) {
                start();
                return;
            }

            // Всё - хуйня приехали:
            error = new Error(errors.error_msg);
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Должен быть конкретный ответ:
        if (lr.data.response != 1) {
            if (r++ < repeats) {
                start();
                return;
            }
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_WRONG, ["secure.addAppEvent", Std.string(lr.data.response)]));
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Всё ок:
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[SetScoresTask]";
    }
}