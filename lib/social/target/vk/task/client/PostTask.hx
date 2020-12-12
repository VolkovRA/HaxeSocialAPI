package social.target.vk.task.client;

import js.lib.Error;
import social.network.INetworkClient;
import social.popup.IPopup;
import social.task.client.IPostTask;
import social.target.vk.sdk.SDK;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация поста на стену.
 */
@:dce
class PostTask implements IPostTask implements IPopup
{
    /**
     * Создать задачу.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetworkClient) {
        this.network = network;
    }

    public var network(default, null):INetworkClient    = null;
    public var message(default, null):String            = null;
    public var image(default, null):String              = null;
    public var link(default, null):String               = null;
    public var result(default, null):PostResult         = PostResult.UNKNOWN;
    public var resultPostID(default, null):String       = null;
    public var error(default, null):Error               = null;
    public var userData:Dynamic                         = null;
    public var onComplete:IPostTask->Void               = null;
    private var isCompleted:Bool                        = false;
    private var popupIndex:Int                          = -1;

    public function start():Void {
        network.popup.add(this);
    }

    private function show():Void {

        // Пример фото: photo-100172_166443618
        // Дока: https://vk.com/dev/wall.post

        var arr = [];
        if (image != null && image != "")
            arr.push(image);
        if (link != null && link != "")
            arr.push(link);

        var params:Dynamic = { message: message };
        if (arr.length > 0)
            params.attachments = arr.join(",");

        SDK.api("wall.post", params, onResult);
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        isCompleted = true;
        network.popup.remove(this);
    }

    private function onResult(data:Dynamic):Void {
        if (isCompleted)
            return;

        isCompleted = true;
        network.popup.remove(this);

        // Пытаемься прочитать ответ:
        // data.response.post_id
        // data.error.error_code // 10007, Operation denied by user
        
        // Пустой ответ: (Хз что это значит)
        if (data == null) {
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Наличие ошибки в ответе:
        if (data.error != null) {
            if (data.error.error_code == 10007) {
                // Всё норм, это не ошибка, пользователь просто отменил пост:
                result = PostResult.CANCELED;
                if (onComplete != null)
                    onComplete(this);
                return;
            }

            // Какая-то ошибка в VK:
            error = new Error(Tools.msg(ErrorMessages.UI_ERROR, [data.error_msg]));
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Всё ок:
        result = PostResult.ACCEPTED;

        // Считываем ID поста:
        if (data.response != null && data.response.post_id != null)
            resultPostID = NativeJS.str(data.response.post_id);

        // Завершаем вызов:
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[PostTask]";
    }
}