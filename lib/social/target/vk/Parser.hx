package social.target.vk;

import social.network.IParser;
import social.target.vk.objects.IFrameParams;
import social.user.OnlineType;
import social.user.Sex;
import social.user.User;
import social.user.UserField;
import social.utils.NativeJS;

/**
 * Парсер данных VK.
 */
@:dce
class Parser implements IParser
{
    /**
     * Создать парсер VK.
     */
    public function new() {
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public function readUser(data:Dynamic, user:User, fields:UserFields):Void {
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
        user.dateUpdated = NativeJS.stamp();
    }

    public function readUserOnline(data:Dynamic):OnlineType {
        if (data.online > 0) {
            if (data.online_mobile > 0)
                return OnlineType.ONLINE_MOBILE;
            else
                return OnlineType.ONLINE;
        }

        return OnlineType.OFFLINE;
    }

    public function readUserPhoto(data:Dynamic):String {
        var str = NativeJS.str(data);

        // Невалидные данные:
        if (str.indexOf("vk.com/images/deactivated") != -1) return null;    // https://vk.com/images/deactivated_50.png
        if (str.indexOf("vk.com/images/camera") != -1) return null;         // https://vk.com/images/camera_50.png?ava=1

        return str;
    }

    public function readHome(data:Dynamic):String {
        return "https://vk.com/" + NativeJS.str(data);
    }

    public function readUserBanned(data:Dynamic):Bool {
        if (data.deactivated == 'banned')
            return true;

        return false;
    }

    public function readUserDeleted(data:Dynamic):Bool {
        if (data.deactivated == 'deleted')
            return true;

        return false;
    }

    public function readUserSex(data:Dynamic):Sex {
        if (data.sex == 1)
            return Sex.FEMALE;
        if (data.sex == 2)
            return Sex.MALE;

        return Sex.UNKNOWN;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[ParserVK]";
    }



    ////////////////////////////////
    //   СОБСТВЕННАЯ РЕАЛИЗАЦИЯ   //
    ////////////////////////////////

    /**
     * Распарсить параметры запроса iframe.  
     * Просто передайте: `Browser.document.location.search`  
     * Считывает строку и возвращает данные, которые передал VK.
     * @param str Строка запроса с параметрами от VK. (То, что после символа "?" в URL)
     * @return Объект параметров VK.
     */
    public function readIFrameParams(str:String):IFrameParams {
        if (str == null)
            return {};

        var index = str.indexOf("?");
        if (index > -1) {
            str = str.substring(index + 1);
        }

        var arr = str.split("&");
        str = null; // <-- Go to GC
        var len = arr.length;
        var map:Dynamic = {};
        while (len-- != 0) {
            index = arr[len].indexOf("=");
            if (index == -1)
                untyped map[NativeJS.decodeURI(arr[len])] = null;
            else
                untyped map[NativeJS.decodeURI(arr[len].substring(0, index))] = NativeJS.decodeURI(arr[len].substring(index + 1));
        }
        arr = null; // <-- Go to GC

        var data:IFrameParams = {};

        // Максимально эффективный JavaScript
        // String:
        if (map.api_url != null)        data.api_url = map.api_url;
        if (map.sid != null)            data.sid = map.sid;
        if (map.secret != null)         data.secret = map.secret;
        if (map.access_token != null)   data.access_token = map.access_token;
        if (map.auth_key != null)       data.auth_key = map.auth_key;
        if (map.api_result != null)     data.api_result = map.api_result;
        if (map.referrer != null)       data.referrer = map.referrer;
        if (map.hash != null)           data.hash = map.hash;
        if (map.lc_name != null)        data.lc_name = map.lc_name;
        if (map.ads_app_id != null)     data.ads_app_id = map.ads_app_id;

        // Int:
        if (map.api_id != null          && map.api_id != "")            untyped data.api_id             = NativeJS.parseInt(map.api_id);
        if (map.api_settings != null    && map.api_settings != "")      untyped data.api_settings       = NativeJS.parseInt(map.api_settings);
        if (map.viewer_id != null       && map.viewer_id != "")         untyped data.viewer_id          = NativeJS.parseInt(map.viewer_id);
        if (map.viewer_type != null     && map.viewer_type != "")       untyped data.viewer_type        = NativeJS.parseInt(map.viewer_type);
        if (map.user_id != null         && map.user_id != "")           untyped data.user_id            = NativeJS.parseInt(map.user_id);
        if (map.group_id != null        && map.group_id != "")          untyped data.group_id           = NativeJS.parseInt(map.group_id);
        if (map.is_app_user != null     && map.is_app_user != "")       untyped data.is_app_user        = NativeJS.parseInt(map.is_app_user);
        if (map.language != null        && map.language != "")          untyped data.language           = NativeJS.parseInt(map.language);
        if (map.parent_language != null && map.parent_language != "")   untyped data.parent_language    = NativeJS.parseInt(map.parent_language);
        if (map.is_secure != null       && map.is_secure != "")         untyped data.is_secure          = NativeJS.parseInt(map.is_secure);

        return data;
    }

    /**
     * Получить параметр `fields` для указания конкретных, запрашиваемых полей пользователя.
     * @param fields Запрашиваемые флаги.
     * @return Список запрашиваемых полей для атрибута: `fields`.
     * @see users.get: https://vk.com/dev/users.get
     */
    public function getUserFields(fields:UserFields):String {
        var str = "";

        //if (NativeJS.flagsOR(fields, UserField.FIRST_NAME))    // Запрашивается по дефолту всегда
        //if (NativeJS.flagsOR(fields, UserField.LAST_NAME))     // Запрашивается по дефолту всегда
        //if (NativeJS.flagsOR(fields, UserField.DELETED))       // Запрашивается по дефолту всегда
        //if (NativeJS.flagsOR(fields, UserField.BANNED))        // Запрашивается по дефолту всегда
        if (NativeJS.flagsOR(fields, UserField.AVATAR_50))       str += "photo_50,";
        if (NativeJS.flagsOR(fields, UserField.AVATAR_100))      str += "photo_100,";
        if (NativeJS.flagsOR(fields, UserField.AVATAR_200))      str += "photo_200,";
        if (NativeJS.flagsOR(fields, UserField.HOME))            str += "domain,";
        if (NativeJS.flagsOR(fields, UserField.SEX))             str += "sex,";
        if (NativeJS.flagsOR(fields, UserField.ONLINE))          str += "online,";

        if (str == '')
            return str;

        return str.substring(0, str.length - 1);
    }
}