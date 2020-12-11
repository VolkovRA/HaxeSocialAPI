package social.target.vk.task.server;

import js.lib.Error;
import loader.ILoader;
import loader.Request;
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
        this.repeats = network.repeats;
    }

    public var network(default, null):INetworkServer    = null;
    public var token(default, null):String              = null;
    public var user(default, null):UserID               = null;
    public var result(default, null):Array<UserID>      = null;
    public var error(default, null):Error               = null;
    public var repeats(default, null):Int               = 0;
    public var priority(default, null):Int              = 0;
    public var userData:Dynamic                         = null;
    public var onComplete:IGetFriendsTask->Void         = null;
    private var r:Int                                   = 0;
    private var lr:ILoader = new loader.nodejs.LoaderNodeJS();

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
            if (r++ < repeats) {
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
        if (arr.length == 0 && r++ < Math.max(5, repeats)) {
            start();
            return;
        }

        // Ответ успешно получен:
        result = arr;
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[GetFriendsTask]";
    }
}
