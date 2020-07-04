package social.vk;

import social.Utils;
import social.SocialUserFields;
import social.vk.objects.IFrameParams;

/**
 * Парсер данных VK.
 */
class Parser 
{
    /**
     * Создать парсер VK.
     */
    public function new() {
    }

    /**
     * Распарсить параметры запроса iframe.
     * 
     * Просто передайте: `Browser.document.location.search`.
     * Считывает строку и возвращает данные, которые передал VK.
     * 
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
                untyped map[Utils.decodeURI(arr[len])] = null;
            else
                untyped map[Utils.decodeURI(arr[len].substring(0, index))] = Utils.decodeURI(arr[len].substring(index + 1));
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
        if (map.api_id != null          && map.api_id != "")            untyped data.api_id             = Utils.parseInt(map.api_id);
        if (map.api_settings != null    && map.api_settings != "")      untyped data.api_settings       = Utils.parseInt(map.api_settings);
        if (map.viewer_id != null       && map.viewer_id != "")         untyped data.viewer_id          = Utils.parseInt(map.viewer_id);
        if (map.viewer_type != null     && map.viewer_type != "")       untyped data.viewer_type        = Utils.parseInt(map.viewer_type);
        if (map.user_id != null         && map.user_id != "")           untyped data.user_id            = Utils.parseInt(map.user_id);
        if (map.group_id != null        && map.group_id != "")          untyped data.group_id           = Utils.parseInt(map.group_id);
        if (map.is_app_user != null     && map.is_app_user != "")       untyped data.is_app_user        = Utils.parseInt(map.is_app_user);
        if (map.language != null        && map.language != "")          untyped data.language           = Utils.parseInt(map.language);
        if (map.parent_language != null && map.parent_language != "")   untyped data.parent_language    = Utils.parseInt(map.parent_language);
        if (map.is_secure != null       && map.is_secure != "")         untyped data.is_secure          = Utils.parseInt(map.is_secure);

        return data;
    }

    /**
     * Прочитать ответ с данными пользователя: `users.get()`
     * @param data Полученные данные пользователя. Если `null` - пользователь считается не существующим.
     * @param user Цель записи данных.
     * @param fields Маска считываемых данных.
     */
    public function readUser(data:Dynamic, user:SocialUser, fields:SocialUserFields):Void {
        if (data == null) {
            if (Utils.flagsOR(fields, SocialUserField.FIRST_NAME))      user.firstName = null;
            if (Utils.flagsOR(fields, SocialUserField.LAST_NAME))       user.lastName = null;
            if (Utils.flagsOR(fields, SocialUserField.DELETED))         user.deleted = true;
            if (Utils.flagsOR(fields, SocialUserField.BANNED))          user.banned = null;
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_50))       user.avatar50 = null;
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_100))      user.avatar100 = null;
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_200))      user.avatar200 = null;
            if (Utils.flagsOR(fields, SocialUserField.HOME))            user.home = null;
            if (Utils.flagsOR(fields, SocialUserField.SEX))             user.sex = null;
            if (Utils.flagsOR(fields, SocialUserField.ONLINE))          user.online = null;
        }
        else {
            if (Utils.flagsOR(fields, SocialUserField.FIRST_NAME))      user.firstName = data.first_name;
            if (Utils.flagsOR(fields, SocialUserField.LAST_NAME))       user.lastName = data.last_name;
            if (Utils.flagsOR(fields, SocialUserField.DELETED))         user.deleted = readUserDeleted(data);
            if (Utils.flagsOR(fields, SocialUserField.BANNED))          user.banned = readUserBanned(data);
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_50))       user.avatar50 = data.photo_50;
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_100))      user.avatar100 = data.photo_100;
            if (Utils.flagsOR(fields, SocialUserField.AVATAR_200))      user.avatar200 = data.photo_200;
            if (Utils.flagsOR(fields, SocialUserField.HOME))            user.home = data.domain;
            if (Utils.flagsOR(fields, SocialUserField.SEX))             user.sex = readUserSex(data);
            if (Utils.flagsOR(fields, SocialUserField.ONLINE))          user.online = readUserOnline(data);
        }
    }

    /**
     * Получить параметр `fields` для указания конкретных, запрашиваемых полей пользователя.
     * @param fields Запрашиваемые флаги.
     * @return Список запрашиваемых полей для атрибута: `fields`.
     * @see users.get: https://vk.com/dev/users.get
     */
    public function getUserFields(fields:SocialUserFields):String {
        var str = "";

        //if (Utils.flagsOR(fields, SocialUserField.ID))            // Запрашивается по дефолту всегда
        //if (Utils.flagsOR(fields, SocialUserField.FIRST_NAME))    // Запрашивается по дефолту всегда
        //if (Utils.flagsOR(fields, SocialUserField.LAST_NAME))     // Запрашивается по дефолту всегда
        //if (Utils.flagsOR(fields, SocialUserField.DELETED))       // Запрашивается по дефолту всегда
        //if (Utils.flagsOR(fields, SocialUserField.BANNED))        // Запрашивается по дефолту всегда
        if (Utils.flagsOR(fields, SocialUserField.AVATAR_50))       str += "photo_50,";
        if (Utils.flagsOR(fields, SocialUserField.AVATAR_100))      str += "photo_100,";
        if (Utils.flagsOR(fields, SocialUserField.AVATAR_200))      str += "photo_200,";
        if (Utils.flagsOR(fields, SocialUserField.HOME))            str += "domain,";
        if (Utils.flagsOR(fields, SocialUserField.SEX))             str += "sex,";
        if (Utils.flagsOR(fields, SocialUserField.ONLINE))          str += "online,";

        if (str == '')
            return str;

        return str.substring(0, str.length - 1);
    }

    /**
     * Прочитать статус онлайна пользователя.
     * @param data Данные пользователя, полученные от VK.
     * @return Статус онлайна.
     */
    public function readUserOnline(data:Dynamic):OnlineType {
        if (data.online > 0) {
            if (data.online_mobile > 0)
                return OnlineType.ONLINE_MOBILE;
            else
                return OnlineType.ONLINE;
        }

        return OnlineType.OFFLINE;
    }

    /**
     * Прочитать статус бана пользователя.
     * @param data Данные пользователя, полученные от VK.
     * @return Статус блокировки пользователя.
     */
    public function readUserBanned(data:Dynamic):Bool {
        if (data.deactivated == 'banned')
            return true;

        return false;
    }

    /**
     * Прочитать статус удалённого пользователя.
     * @param data Данные пользователя, полученные от VK.
     * @return Статус удаления.
     */
    public function readUserDeleted(data:Dynamic):Bool {
        if (data.deactivated == 'deleted')
            return true;

        return false;
    }

    /**
     * Прочитать гендерный признак пользователя.
     * @param data Данные пользователя, полученные от VK.
     * @return Гендерный признак пользователя.
     */
    public function readUserSex(data:Dynamic):Sex {
        if (data.sex == 1)
            return Sex.FEMALE;
        if (data.sex == 2)
            return Sex.MALE;

        return Sex.UNKNOWN;
    }
}