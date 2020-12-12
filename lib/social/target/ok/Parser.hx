package social.target.ok;

import social.network.IParser;
import social.user.OnlineType;
import social.user.Sex;
import social.user.User;
import social.user.UserField;
import social.target.ok.objects.IFrameParams;
import social.task.client.IInviteTask;
import social.task.client.IPostTask;
import social.utils.NativeJS;
import social.utils.Tools;

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
     * Получить параметры iframe.  
     * Считывает и возвращает параметры, переданные приложению в iframe.
     * @return Параметры приложения.
     */
    public function readIFrameParams():IFrameParams {
        #if nodejs
        return null;
        #else
        var map = Tools.query(js.Browser.location.search);
        var data:IFrameParams = {};

        // Приведение к типу в соответствии с API (Маппинг)
        // String:
        if (map.api_server != null)         data.api_server = map.api_server;
        if (map.apiconnection != null)      data.apiconnection = map.apiconnection;
        if (map.application_key != null)    data.application_key = map.application_key;
        if (map.auth_sig != null)           data.auth_sig = map.auth_sig;
        if (map.mob_platform != null)       data.mob_platform = map.mob_platform;
        if (map.custom_args != null)        data.custom_args = map.custom_args;
        if (map.header_widget != null)      data.header_widget = map.header_widget;
        if (map.referer != null)            data.referer = map.referer;
        if (map.refplace != null)           data.refplace = map.refplace;
        if (map.session_key != null)        data.session_key = map.session_key;
        if (map.session_secret_key != null) data.session_secret_key = map.session_secret_key;
        if (map.sig != null)                data.sig = map.sig;
        if (map.web_server != null)         data.web_server = map.web_server;
        if (map.ip_geo_location != null)    data.ip_geo_location = map.ip_geo_location;

        // Int:
        if (map.authorized != null && map.authorized != "")         data.authorized = NativeJS.parseInt(map.authorized);
        if (map.first_start != null && map.first_start != "")       data.first_start = NativeJS.parseInt(map.first_start);
        if (map.logged_user_id != null && map.logged_user_id != "") data.logged_user_id = NativeJS.parseInt(map.logged_user_id);
        
        // Bool:
        if (map.mob != null && map.mob != "")                                   data.mob = readBool(map.mob);
        if (map.new_sig != null && map.new_sig != "")                           data.new_sig = readBool(map.new_sig);
        if (map.container != null && map.container != "")                       data.container = readBool(map.container);
        if (map.payment_promo_active != null && map.payment_promo_active != "") data.payment_promo_active = readBool(map.payment_promo_active);

        return data;
        #end
    }

    /**
     * Прочитать ID приложения из параметров iframe.  
     * @param apiconnection Свойство из iframe.
     * @return ID Приложения.
     */
    public function readAppID(apiconnection:String):String {
        // Пример: 1124642304_1607778743679
        if (apiconnection == null)
            return null;

        var index = apiconnection.indexOf("_");
        if (index == -1)
            return apiconnection;

        return apiconnection.substring(0, index);
    }

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

    /**
     * Прочитать результат вызова поста на стену.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return Результат вызова в стандартизированном виде.
     */
    public function getPostResult(result:String):PostResult {
        if (result == "cancel") return PostResult.CANCELED;
        if (result == "ok")     return PostResult.ACCEPTED;
        return PostResult.UNKNOWN;
    }

    /**
     * Прочитать результат поста на стену - ID нового поста.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return ID Нового поста.
     */
    public function getPostResultPostID(result:String):String {
        if (result == null || result == "" || result == "null" || result == "0")
            return null;

        return result;
    }

    /**
     * Проверка ответа на ошибку.  
     * SDK Возвращает ошибку в строке в формате JSON, если такова имела место быть.
     * @param result Ответ от JS SDK.
     * @return Это ошибка.
     */
    public function isResultDataError(result:String):Bool {
        if (result == null || result == "" || result == "null" || result == "0" || result == "cancel")
            return false;

        var obj:Dynamic = null;
        try {
            obj = NativeJS.parseJSON(result);
        }
        catch(err:Dynamic){
        }

        if (obj == null)
            return false;

        return true;
    }

    /**
     * Прочитать логическое значение.
     * @param value Строка с логическим значением.
     * @return Логическое значение.
     */
    public function readBool(value:String):Bool {
        if (value == null) return false;
        if (value == "") return false;
        if (value == "0") return false;
        if (value.toLowerCase() == "false") return false;
        return true;
    }
}