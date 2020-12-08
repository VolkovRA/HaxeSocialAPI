package social.target.ok;

import social.network.IParser;
import social.user.OnlineType;
import social.user.Sex;
import social.user.User;
import social.user.UserField;
import social.utils.NativeJS;
import social.task.client.IInviteTask;

/**
 * Парсер данных для Одноклассников.
 */
@:dce
class Parser implements IParser
{
    /**
     * Создать парсер OK.
     */
    public function new() {
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public function readUser(data:Dynamic, user:User, fields:UserFields):Void {
        /*
        if (data == null) {
            if (NativeJS.flagsOR(fields, UserField.FIRST_NAME))      user.firstName = null;
            if (NativeJS.flagsOR(fields, UserField.LAST_NAME))       user.lastName = null;
            if (NativeJS.flagsOR(fields, UserField.DELETED))         user.deleted = true;
            if (NativeJS.flagsOR(fields, UserField.BANNED))          user.banned = null;
            if (NativeJS.flagsOR(fields, UserField.AVATAR_50))       user.avatar50 = null;
            if (NativeJS.flagsOR(fields, UserField.AVATAR_100))      user.avatar100 = null;
            if (NativeJS.flagsOR(fields, UserField.AVATAR_200))      user.avatar200 = null;
            if (NativeJS.flagsOR(fields, UserField.HOME))            user.home = null;
            if (NativeJS.flagsOR(fields, UserField.SEX))             user.sex = null;
            if (NativeJS.flagsOR(fields, UserField.ONLINE))          user.online = null;
        }
        else {
            if (NativeJS.flagsOR(fields, UserField.FIRST_NAME))      user.firstName = data.first_name;
            if (NativeJS.flagsOR(fields, UserField.LAST_NAME))       user.lastName = data.last_name;
            if (NativeJS.flagsOR(fields, UserField.DELETED))         user.deleted = readUserDeleted(data);
            if (NativeJS.flagsOR(fields, UserField.BANNED))          user.banned = readUserBanned(data);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_50))       user.avatar50 = readUserPhoto(data.photo_50);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_100))      user.avatar100 = readUserPhoto(data.photo_100);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_200))      user.avatar200 = readUserPhoto(data.photo_200);
            if (NativeJS.flagsOR(fields, UserField.HOME))            user.home = readHome(data.domain);
            if (NativeJS.flagsOR(fields, UserField.SEX))             user.sex = readUserSex(data);
            if (NativeJS.flagsOR(fields, UserField.ONLINE))          user.online = readUserOnline(data);
        }
        */
        user.dateUpdated = NativeJS.stamp();
    }

    public function readUserOnline(data:Dynamic):OnlineType {
        /*
        if (data.online > 0) {
            if (data.online_mobile > 0)
                return OnlineType.ONLINE_MOBILE;
            else
                return OnlineType.ONLINE;
        }
        */
        return OnlineType.OFFLINE;
    }

    public function readUserPhoto(data:Dynamic):String {
        var str = NativeJS.str(data);
        /*
        // Невалидные данные:
        if (str.indexOf("vk.com/images/deactivated") != -1) return null;    // https://vk.com/images/deactivated_50.png
        if (str.indexOf("vk.com/images/camera") != -1) return null;         // https://vk.com/images/camera_50.png?ava=1
        */
        return str;
    }

    public function readHome(data:Dynamic):String {
        return "https://ok.ru/profile/" + NativeJS.str(data);
    }

    public function readUserBanned(data:Dynamic):Bool {
        //if (data.deactivated == 'banned')
        //    return true;

        return false;
    }

    public function readUserDeleted(data:Dynamic):Bool {
        //if (data.deactivated == 'deleted')
        //    return true;

        return false;
    }

    public function readUserSex(data:Dynamic):Sex {
        //if (data.sex == 1)
        //    return Sex.FEMALE;
        //if (data.sex == 2)
        //    return Sex.MALE;

        return Sex.UNKNOWN;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[Parser]";
    }



    ////////////////////////////////
    //   СОБСТВЕННАЯ РЕАЛИЗАЦИЯ   //
    ////////////////////////////////

    /**
     * Прочитать результат вызова приглашения друзей.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return Результат вызова в стандартизированном виде.
     */
    public function getInvitedResult(result:String):InviteResult {
        if (result == "cancel") return InviteResult.CANCELED;
        if (result == "ok")     return InviteResult.ACCEPTED;
        return InviteResult.UNKNOWN;
    }

    /**
     * Прочитать результат вызова приглашения друзей - список приглашённых пользователей.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return Список приглашённых.
     */
    public function getInvitedResultUsers(result:String):Array<UserID> {
        if (result == null || result == "" || result == "null")
            return null;

        return result.split(",");
    }
}