package social.target.ok.task.client;

import js.lib.Error;
import social.network.INetworkClient;
import social.task.client.IPostTask;
import social.target.ok.sdk.SDK;
import social.popup.IPopup;
import social.utils.ErrorMessages;
import social.utils.Tools;

/**
 * Реализация поста на стену.
 */
@:dce
class PostTask implements IPostTask implements IPopup
{
    /**
     * Создать задачу.
     * @param network Интерфейс социальной сети.
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
    private var popupIndex:Int                          = -1;
    private var isCompleted:Bool                        = false;

    public function start():Void {
        network.popup.add(this);
    }

    private function show():Void {

        // Ссылка на фото должна быть URL.
        // Дока: https://apiok.ru/dev/sdk/js/ui.postMediatopic/

        var media = new Array<Dynamic>();
        media.push({
            "type": "text",
            "text": message,
        });
        media.push({
            "type": "app",
            "text": " ",
            "images": [{
                "url": image,
                //"title": "TITLE",
                "mark": "media",
            }],
        });
        if (link != null)
            media.push({
                "type": "link",
                "url": link,
            });

        var net:OdnoklassnikiClient = untyped network;
        net.onUIResult.on(onUIResult);
        SDK.UI.postMediatopic({
            media: media,
        });
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        isCompleted = true;
        network.popup.remove(this);
    }

    private function onUIResult(method:String, result:String, data:Dynamic) {
        var net:OdnoklassnikiClient = untyped network;
        if (method == "postMediatopic" && net.popup.current == this && !isCompleted) {

            // Читаем ответ:
            this.result = net.parser.getPostResult(result);
            if (net.parser.isResultDataError(data))
                this.error = new Error(Tools.msg(ErrorMessages.UI_ERROR, [Std.string(data)]));
            else
                this.resultPostID = net.parser.getPostResultPostID(data);

            // Завершаем задачу:
            isCompleted = true;
            net.onUIResult.off(onUIResult);
            net.popup.remove(this);

            if (onComplete != null)
                onComplete(this);
        }
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[PostTask]";
    }
}