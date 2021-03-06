package social.target.vk.task;

import js.lib.Error;
import social.network.INetwork;
import social.task.IPostTask;
import social.target.vk.sdk.SDK;
import social.utils.NativeJS;

/**
 * Реализация поста на стену.
 */
@:dce
class PostTask implements IPostTask 
{
    /**
     * Создать задачу.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetwork) {
        this.network = network;
    }

    public var network(default, null):INetwork;
    public var result:Bool = false;
    public var message:String = null;
    public var image:String = null;
    public var url:String = null;
    public var postID:String = null;
    public var error:Error = null;
    public var onComplete:IPostTask->Void = null;
    public var userData:Dynamic = null;
    private var isCompleted:Bool = false;

    public function start():Void {

        // Пример фото: photo-100172_166443618
        // Дока: https://vk.com/dev/wall.post

        var arr = [];
        if (image != null && image != "")
            arr.push(image);
        if (url != null && url != "")
            arr.push(url);

        var params:Dynamic = { message: message };
        if (arr.length > 0)
            params.attachments = arr.join(",");

        SDK.api("wall.post", params, onResult);
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        isCompleted = true;
    }

    private function onResult(result:Dynamic):Void {
        if (isCompleted)
            return;

        isCompleted = true;

        // Пытаемься прочитать ответ:
        // data.response.post_id
        // data.error.error_code // 10007, Operation denied by user
        
        // Пустой ответ: (Хз что это значит)
        if (result == null) {
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Наличие ошибки в ответе:
        if (result.error != null) {
            if (result.error.error_code == 10007) {
                // Всё норм, это не ошибка, пользователь просто отменил пост:
                if (onComplete != null)
                    onComplete(this);
                return;
            }

            // Какая-то ошибка в VK:
            error = new Error("Ошибка ВКонтакте при попытке размещения нового поста: " + result.error_msg);
            if (onComplete != null)
                onComplete(this);
            return;
        }

        // Всё ок:
        this.result = true;

        // Считываем ID поста:
        if (result.response != null && result.response.post_id != null)
            postID = NativeJS.str(result.response.post_id);

        // Завершаем вызов:
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[PostTask VK]";
    }
}