package social.target.vk;

import social.network.IPermissions;
import social.target.vk.enums.UserPermissions;
import social.utils.NativeJS;

/**
 * Реализация списка прав доступа в ВКонтакте.
 */
@:dce
class Permissions implements IPermissions
{
    public function new() {
    }

    /**
     * Маска прав доступа.  
     * Не может быть `null`
     */
    @:keep
    public var mask:UserPermissions = 0;

    @:keep
    public var friends(get, never):Bool;
    function get_friends():Bool {
        return NativeJS.flagsOR(mask, UserPermission.FRIENDS);
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[VKontaktePermissions]";
    }
}