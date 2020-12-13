package social.target.ok.task.client;

import js.lib.Error;
import social.network.INetworkClient;
import social.task.client.IInviteTask;
import social.target.ok.sdk.SDK;
import social.user.User;
import social.popup.IPopup;
import social.utils.ErrorMessages;
import social.utils.Tools;

/**
 * Реализация приглашения друзей.
 */
@:dce
class InviteTask implements IInviteTask implements IPopup
{
    /**
     * Создать задачу.
     * @param network Реализация интерфейса социальной сети.
     */
    public function new(network:INetworkClient) {
        this.network = network;
    }

    public var network(default, null):INetworkClient    = null;
    public var users(default, null):Array<UserID>       = null;
    public var message(default, null):String            = null;
    public var error(default, null):Error               = null;
    public var result(default, null):InviteResult       = InviteResult.UNKNOWN;
    public var resultUsers(default, null):Array<UserID> = null;
    public var isComplete(default, null):Bool           = false;
    public var userData:Dynamic                         = null;
    public var onComplete:IInviteTask->Void             = null;
    private var popupIndex:Int                          = -1;

    public function start():Void {
        network.popup.add(this);
    }

    private function show():Void {
        var net:OdnoklassnikiClient = untyped network;
        net.onUIResult.on(onUIResult);
        SDK.UI.showInvite(message, null, users==null?null:users.join(";"));
    }

    private function onUIResult(method:String, result:String, data:Dynamic):Void {
        var net:OdnoklassnikiClient = untyped network;
        if (method == "showInvite" && net.popup.current == this && !isComplete) {

            // Читаем ответ:
            this.result = net.parser.getInvitedResult(result);
            if (net.parser.isResultDataError(data))
                this.error = new Error(Tools.msg(ErrorMessages.UI_ERROR, ["showInvite", Std.string(data)]));
            else
                this.resultUsers = net.parser.getInvitedResultUsers(data);

            // Завершаем задачу:
            isComplete = true;
            net.onUIResult.off(onUIResult);
            net.popup.remove(this);
            if (onComplete != null)
                onComplete(this);
        }
    }

    public function cancel():Void {
        if (isComplete)
            return;

        isComplete = true;

        var net:OdnoklassnikiClient = untyped network;
        net.onUIResult.off(onUIResult);
        net.popup.remove(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[InviteTask]";
    }
}