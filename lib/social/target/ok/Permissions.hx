package social.target.ok;

import social.network.IPermissions;

/**
 * Реализация списка прав доступа в Одноклассники.
 */
@:dce
class Permissions implements IPermissions
{
    public function new() {
    }

    @:keep
    public var friends(get, never):Bool;
    function get_friends():Bool {
        return false;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[Permissions]";
    }
}