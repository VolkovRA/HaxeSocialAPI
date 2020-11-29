package social.target.vk.task;

import js.lib.Error;
import social.network.INetwork;
import social.task.IInviteTask;
import social.target.vk.sdk.SDK;
import social.target.vk.sdk.Method;
import social.target.vk.sdk.Event;
import social.user.User;

/**
 * Реализация запроса списка друзей.
 * Может быть использован на клиенте и на сервере.
 */
@:dce
class InviteTask implements IInviteTask 
{
    /**
     * Создать задачу.
     * @param network Реализация соц. сети VK.
     */
    public function new(network:INetwork) {
        this.network = network;
    }

    public var network(default, null):INetwork;
    public var users:Array<UserID> = null;
    public var result:Array<UserID> = null;
    public var message:String = null;
    public var error:Error = null;
    public var onComplete:IInviteTask->Void = null;
    public var userData:Dynamic = null;
    private var isCompleted:Bool = false;

    public function start():Void {
        SDK.addCallback(Event.WINDOW_FOCUS, onFocus);
        SDK.callMethod(Method.SHOW_INVITE_BOX);
    }

    public function cancel():Void {
        if (isCompleted)
            return;

        isCompleted = true;
        SDK.removeCallback(Event.WINDOW_FOCUS, onFocus);
    }

    private function onFocus():Void {
        isCompleted = true;
        SDK.removeCallback(Event.WINDOW_FOCUS, onFocus);
        if (onComplete != null)
            onComplete(this);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[InviteTask VK]";
    }
}