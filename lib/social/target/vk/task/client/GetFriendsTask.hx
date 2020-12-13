package social.target.vk.task.client;

import js.lib.Error;
import loader.ILoader;
import loader.Request;
import social.network.INetworkClient;
import social.task.client.IGetFriendsTask;
import social.target.vk.objects.BaseError;
import social.user.User;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация запроса списка друзей.
 * Может быть использован на клиенте и на сервере.
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
    public var userData:Dynamic                         = null;
    public var onComplete:IGetFriendsTask->Void         = null;
    private var r:Int = 0;
    private var lr:ILoader = #if nodejs null; #else new loader.jsonp.LoaderJSONP(); #end

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
            error = new Error(Tools.msg(ErrorMessages.REQUEST_ERROR, [network.apiURL + "friends.get", Tools.err(lr.error)]));
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
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_EMPTY, [network.apiURL + "friends.get"]));
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
                error = new Error(Tools.msg(ErrorMessages.RESPONSE_ERROR, [network.apiURL + "friends.get", errors.error_code, errors.error_msg]));
                isComplete = true;
                if (onComplete != null)
                    onComplete(this);
            }
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
            error = new Error(Tools.msg(ErrorMessages.RESPONSE_WRONG, [network.apiURL + "friends.get", Tools.err(err)]));
            isComplete = true;
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Ошибка в самом VK - прислал пустой список друзей!!
        // Очень редко, но иногда VK может возвращать пустой список друзей!
        // Для таких случаев мы переспросим VK не менее 5 раз, чтобы наверняка
        // быть уверенными, что данный пользователь - ТОЧНО не имеет друзей.
        if (arr.length == 0 && r++ < Math.max(5, repeats)) {
            start();
            return;
        }

        // Всё ок:
        result = arr;
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