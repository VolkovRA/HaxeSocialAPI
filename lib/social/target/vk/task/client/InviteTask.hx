package social.target.vk.task.client;

import js.lib.Error;
import social.network.INetworkClient;
import social.task.client.IInviteTask;
import social.target.vk.sdk.SDK;
import social.target.vk.sdk.Method;
import social.target.vk.sdk.Event;
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

    public var network(default, null):INetworkClient    = null;
    public var users(default, null):Array<UserID>       = null;
    public var message(default, null):String            = null;
    public var error(default, null):Error               = null;
    public var result(default, null):InviteResult       = InviteResult.UNKNOWN;
    public var resultUsers(default, null):Array<UserID> = null;
    public var userData:Dynamic                         = null;
    public var onComplete:IInviteTask->Void             = null;
    private var popupIndex:Int                          = -1;
    private var isCompleted:Bool                        = false;

    public function start():Void {
        network.popup.add(this);
    }

    private function show():Void {
        SDK.addCallback(Event.WINDOW_FOCUS, onFocus);
        SDK.callMethod(Method.SHOW_INVITE_BOX);
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        isCompleted = true;
        network.popup.remove(this);
        SDK.removeCallback(Event.WINDOW_FOCUS, onFocus);
    }

    private function onFocus():Void {
        isCompleted = true;
        network.popup.remove(this);
        SDK.removeCallback(Event.WINDOW_FOCUS, onFocus);
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[InviteTask]";
    }
}