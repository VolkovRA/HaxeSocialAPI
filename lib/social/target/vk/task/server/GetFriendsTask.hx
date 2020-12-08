package social.target.vk.task.server;

import js.lib.Error;
import loader.ILoader;
import loader.Request;
import loader.nodejs.LoaderNodeJS;
import social.network.INetworkServer;
import social.task.server.IGetFriendsTask;
import social.target.vk.enums.ErrorCode;
import social.target.vk.objects.BaseError;
import social.user.User;
import social.utils.NativeJS;

/**
 * Реализация запроса списка друзей.
 * Может быть использован на клиенте и на сервере.
 */
@:dce
class GetFriendsTask implements IGetFriendsTask 
{
    /**
     * Создать задачу запроса списка друзей.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetworkServer) {
        this.network = network;
        this.requestRepeatTry = network.requestRepeatTry;
    }

    public var network(default, null):INetworkServer;
    public var token:String = null;
    public var user:UserID = null;
    public var users:Array<UserID> = null;
    public var error:Error = null;
    public var requestRepeatTry:Int = 0;
    public var priority:Int = 0;
    public var onComplete:IGetFriendsTask->Void = null;
    public var userData:Dynamic = null;

    private var repeats:Int = 0;
    private var lr:ILoader = new LoaderNodeJS();

    public function start():Void {
        var req = new Request(network.apiURL + "friends.get");
        req.data =  "user_id=" + user + 
                    "&v=" + network.apiVersion +
                    "&access_token=" + token;

        lr.priority = priority;
        lr.balancer = network.balancer;
        lr.onComplete = onResponse;
        lr.load(req);
    }

    public function cancel():Void {
        lr.onComplete = null;
        lr.balancer = null;
        lr.close();
        lr = null;
    }

    private function onResponse(lr:ILoader):Void {

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

            error = new Error("Empty response of vk get friends");
            if (onComplete != null)
                onComplete(this);

            return;
        }

        // Ошибки VK:
        var errors:BaseError = lr.data.error;
        if (errors != null) {

            // Неисправимые ошибки: (Повторный запрос - бесполезен)
            if (    errors.error_code == ErrorCode.PRIVATE_USER ||
                    errors.error_code == ErrorCode.USER_DEACTIVATED ||
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
        
        // Ожидаем такой массив: Array<Int>
        var arr:Dynamic = null;
        try {
            arr = lr.data.response.items;

            // Необходимо привести массив в соответствие с контрактом:
            var len = arr.length;
            while (len-- > 0)
                arr[len] = NativeJS.str(arr[len]);
        }
        catch (err:Dynamic) {
            if (repeats++ < requestRepeatTry) {
                start();
                return;
            }

            var msg:String = "Error read get friends vk response:\n";
            if (err.message == null) {
                error = new Error(msg + NativeJS.str(err));
            }
            else {
                err.message = msg + NativeJS.str(err.message);
                error = err;
            } 

            if (onComplete != null)
                onComplete(this);

            return;
        }

        // Ошибка VK - пустой список друзей.
        // Очень редко, но иногда VK может возвращать пустой список друзей!
        // Для таких случаев мы переспросим VK не менее 5 раз, что бы наверняка
        // быть уверенными, что данный пользователь - ТОЧНО не имеет друзей.
        if (arr.length == 0 && repeats++ < Math.max(5, requestRepeatTry)) {
            start();
            return;
        }

        // Ответ успешно получен:
        users = arr;
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[GetFriendsTask]";
    }
}
