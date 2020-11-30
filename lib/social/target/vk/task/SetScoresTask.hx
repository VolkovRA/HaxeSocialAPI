package social.target.vk.task;

import js.lib.Error;
import loader.DataFormat;
import loader.ILoader;
import loader.Method;
import loader.Request;
import social.target.vk.enums.ErrorCode;
import social.target.vk.objects.BaseError;
import social.network.INetwork;
import social.task.ISetScoresTask;
import social.user.User;
import social.utils.NativeJS;

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
     public function new(network:INetwork) {
        this.network = network;
        this.requestRepeatTry = network.requestRepeatTry;
    }

    public var network(default, null):INetwork;
    public var user:UserID;
    public var scores:Int;
    public var error:Error = null;
    public var onComplete:ISetScoresTask->Void = null;
    public var token:String = null;
    public var priority:Int = 0;
    public var requestRepeatTry:Int = 0;
    public var userData:Dynamic = null;

    private var repeats:Int = 0;
    #if nodejs
    private var lr:ILoader = new loader.nodejs.LoaderNodeJS();
    #else
    private var lr:ILoader = null;
    #end

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
            if (repeats++ < requestRepeatTry) {
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
            if (repeats++ < requestRepeatTry) {
                start();
                return;
            }
            error = new Error("Получен пустой ответ от VK на запрос: secure.addAppEvent");
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
            if (repeats++ < requestRepeatTry) {
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
            if (repeats++ < requestRepeatTry) {
                start();
                return;
            }
            error = new Error("Получен некорректный ответ от VK: secure.addAppEvent");
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
        return "[SetScoresTask VK]";
    }
}