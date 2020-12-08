package social.target.ok.task.client;

import js.lib.Error;
import social.network.INetworkClient;
import social.task.client.IInviteTask;
import social.target.ok.sdk.SDK;
import social.user.User;
import social.popup.IPopup;

/**
 * Реализация приглашения друзей.
 */
@:dce
class InviteTask implements IInviteTask implements IPopup
{
    /**
     * Создать задачу.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetworkClient) {
        this.network = network;
    }

    public var network(default, null):INetworkClient;
    public var users:Array<UserID> = null;
    public var message:String = null;
    public var error:Error = null;
    public var onComplete:IInviteTask->Void = null;
    public var userData:Dynamic = null;
    public var result:InviteResult = InviteResult.UNKNOWN;
    public var resultUsers:Array<UserID> = null;
    private var popupIndex:Int = -1;
    private var isCompleted:Bool = false;

    public function start():Void {
        network.popup.add(this);
    }

    private function show():Void {
        var net:OdnoklassnikiClient = untyped network;
        net.onUIResult.on(onUIResult);
        SDK.UI.showInvite(message, null, users==null?null:users.join(";"));
    }

    private function onUIResult(method:String, result:String, data:Dynamic) {
        var net:OdnoklassnikiClient = untyped network;
        if (method == "showInvite" && net.popup.current == this && !isCompleted) {

            // Считываем ответ:
            this.result = net.parser.getInvitedResult(result);
            this.resultUsers = net.parser.getInvitedResultUsers(data);

            // Завершаем задачу:
            isCompleted = true;
            net.onUIResult.off(onUIResult);
            net.popup.remove(this);

            if (onComplete != null)
                onComplete(this);
        }
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        var net:OdnoklassnikiClient = untyped network;
        net.onUIResult.off(onUIResult);
        net.popup.remove(this);
        isCompleted = true;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[InviteTask]";
    }
}