package social.target.ok;

import social.network.IParser;
import social.target.ok.objects.IFrameParams;
import social.task.client.IInviteTask;
import social.task.client.IPostTask;
import social.user.OnlineType;
import social.user.Sex;
import social.user.User;
import social.user.UserField;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Парсер данных для Одноклассников.
 */
@:dce
class Parser implements IParser
{
    /**
     * Время юзера в онлайне после последней активности в сети. (mc)  
     * Это количество миллисекунд, которые пользователь будет считаться
     * в онлайне после последней активности в сети. Используется для
     * определения статуса онлайна пользователя.
     */
    static private inline var USER_ONLINE_TIMEOUT:Float = 1 * 60 * 1000;

    /**
     * Создать парсер OK.
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
            if (NativeJS.flagsOR(fields, UserField.FIRST_NAME))      user.firstName = readUserFirstName(data);
            if (NativeJS.flagsOR(fields, UserField.LAST_NAME))       user.lastName = readUserLastName(data);
            if (NativeJS.flagsOR(fields, UserField.DELETED))         user.deleted = readUserDeleted(data);
            if (NativeJS.flagsOR(fields, UserField.BANNED))          user.banned = readUserBanned(data);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_50))       user.avatar50 = readUserPhoto50(data);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_100))      user.avatar100 = readUserPhoto100(data);
            if (NativeJS.flagsOR(fields, UserField.AVATAR_200))      user.avatar200 = readUserPhoto200(data);
            if (NativeJS.flagsOR(fields, UserField.HOME))            user.home = readUserHome(data);
            if (NativeJS.flagsOR(fields, UserField.SEX))             user.sex = readUserSex(data);
            if (NativeJS.flagsOR(fields, UserField.ONLINE))          user.online = readUserOnline(data);
        }
        user.dateUpdated = NativeJS.stamp();
    }

    public function readUserFirstName(data:Dynamic):String {
        if (data.first_name == null)    return null;
        if (data.first_name == "")      return null;
        return NativeJS.str(data.first_name);
    }

    public function readUserLastName(data:Dynamic):String {
        if (data.last_name == null)     return null;
        if (data.last_name == "")       return null;
        return NativeJS.str(data.last_name);
    }

    public function readUserDeleted(data:Dynamic):Bool {
        return false;
    }

    public function readUserBanned(data:Dynamic):Bool {
        // todo: Протестить на забаненном юзере!
        // Эта функция не тестировалось, так-как не удалось 
        // найти забаненного юзера в Одноклассниках.
        // Писал на верочку, по аналогий..
        if (data.blocked == null)       return false;
        if (data.blocked == "")         return false;
        return true;
    }

    public function readUserPhoto50(data:Dynamic):String {
        if (data.pic50x50 == null)      return null;
        if (data.pic50x50 == "")        return null;
        return NativeJS.str(data.pic50x50);
    }

    public function readUserPhoto100(data:Dynamic):String {
        if (data.pic128x128 == null)    return null;
        if (data.pic128x128 == "")      return null;
        return NativeJS.str(data.pic128x128);
    }

    public function readUserPhoto200(data:Dynamic):String {
        if (data.pic224x224 == null)    return null;
        if (data.pic224x224 == "")      return null;
        return NativeJS.str(data.pic224x224);
    }

    public function readUserHome(data:Dynamic):String {
        if (data.url_profile == null)   return null;
        if (data.url_profile == "")     return null;
        return NativeJS.str(data.url_profile);
    }

    public function readUserSex(data:Dynamic):Sex {
        if (data.gender == "male")      return Sex.MALE;
        if (data.gender == "female")    return Sex.FEMALE;
        return Sex.UNKNOWN;
    }

    public function readUserOnline(data:Dynamic):OnlineType {
        if (data.last_online_ms == null)    return OnlineType.OFFLINE;
        if (data.last_online_ms == "")      return OnlineType.OFFLINE;
        if (NativeJS.parseInt(data.last_online_ms, 10) + USER_ONLINE_TIMEOUT > NativeJS.stamp())
            return OnlineType.ONLINE;

        return OnlineType.OFFLINE;
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
        if (result == null)                     return InviteResult.UNKNOWN;
        if (result.toLowerCase() == "cancel")   return InviteResult.CANCELED;
        if (result.toLowerCase() == "ok")       return InviteResult.ACCEPTED;
        return InviteResult.UNKNOWN;
    }

    /**
     * Прочитать результат вызова приглашения друзей - список приглашённых пользователей.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return Список приглашённых.
     */
    public function getInvitedResultUsers(result:String):Array<UserID> {
        if (result == null || result == "" || result.toLowerCase() == "null")
            return null;

        return result.split(",");
    }

    /**
     * Прочитать результат вызова поста на стену.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return Результат вызова в стандартизированном виде.
     */
    public function getPostResult(result:String):PostResult {
        if (result == null)                     return PostResult.UNKNOWN;
        if (result.toLowerCase() == "cancel")   return PostResult.CANCELED;
        if (result.toLowerCase() == "ok")       return PostResult.ACCEPTED;
        return PostResult.UNKNOWN;
    }

    /**
     * Прочитать результат поста на стену - ID нового поста.
     * @param result Результат вызова, полученный от Одноклассников.
     * @return ID Нового поста.
     */
    public function getPostResultPostID(result:String):String {
        if (result == null || result == "" || result.toLowerCase() == "null" || result == "0")
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
        if (result == null || result == "" || result.toLowerCase() == "null" || result == "0" || result.toLowerCase() == "cancel")
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

    /**
     * Получить параметр `fields` для указания конкретных, запрашиваемых полей пользователя.
     * @param fields Запрашиваемые флаги.
     * @return Список запрашиваемых полей для атрибута: `fields`.
     * @see users.getInfo: https://apiok.ru/dev/methods/rest/users/users.getInfo
     */
    public function getUserFields(fields:UserFields):String {
        var str = "";

//        return
//        "ACCESSIBLE," +
//        "AGE," +
//        "ALLOWS_ANONYM_ACCESS," +
//        "ALLOWS_MESSAGING_ONLY_FOR_FRIENDS," +
//        "ALLOW_ADD_TO_FRIEND," +
//        "BECOME_VIP_ALLOWED," +
//        "BIRTHDAY," +
//        "BLOCKED," +
//        "BLOCKS," +
//        "BUSINESS," +
//        "CAN_USE_REFERRAL_INVITE," +
//        "CAN_VCALL," +
//        "CAN_VMAIL," +
//        "CITY_OF_BIRTH," +
//        "CLOSE_COMMENTS_ALLOWED," +
//        "COMMON_FRIENDS_COUNT," +
//        "CURRENT_LOCATION," +
//        "CURRENT_STATUS," +
//        "CURRENT_STATUS_DATE," +
//        "CURRENT_STATUS_DATE_MS," +
//        "CURRENT_STATUS_ID," +
//        "CURRENT_STATUS_MOOD," +
//        "CURRENT_STATUS_TRACK_ID," +
//        "EMAIL," +
//        "EXECUTOR," +
//        "FIRST_NAME," +
//        "FIRST_NAME_INSTRUMENTAL," +
//        "FOLLOWERS_COUNT," +
//        "FORBIDS_MENTIONING," +
//        "FRIEND," +
//        "FRIENDS_COUNT," +
//        "FRIEND_INVITATION," +
//        "FRIEND_INVITE_ALLOWED," +
//        "GENDER," +
//        "GROUP_INVITE_ALLOWED," +
//        "HAS_DAILY_PHOTO," +
//        "HAS_EMAIL," +
//        "HAS_GROUPS_TO_COMMENT," +
//        "HAS_PHONE," +
//        "HAS_PRODUCTS," +
//        "HAS_SERVICE_INVISIBLE," +
//        "INTERNAL_PIC_ALLOW_EMPTY," +
//        "INVITED_BY_FRIEND," +
//        "IS_MERCHANT," +
//        "LAST_NAME," +
//        "LAST_NAME_INSTRUMENTAL," +
//        "LAST_ONLINE," +
//        "LAST_ONLINE_MS," +
//        "LOCALE," +
//        "LOCATION," +
//        "LOCATION_OF_BIRTH," +
//        "MODIFIED_MS," +
//        "NAME," +
//        "NAME_INSTRUMENTAL," +
//        "ODKL_BLOCK_REASON," +
//        "ODKL_EMAIL," +
//        "ODKL_LOGIN," +
//        "ODKL_MOBILE," +
//        "ODKL_MOBILE_ACTIVATION_DATE," +
//        "ODKL_MOBILE_STATUS," +
//        "ODKL_USER_OPTIONS," +
//        "ODKL_USER_STATUS," +
//        "ODKL_VOTING," +
//        "ONLINE," +
//        "PHOTO_ID," +
//        "PIC1024X768," +
//        "PIC128MAX," +
//        "PIC128X128," +
//        "PIC180MIN," +
//        "PIC190X190," +
//        "PIC224X224," +
//        "PIC240MIN," +
//        "PIC288X288," +
//        "PIC320MIN," +
//        "PIC50X50," +
//        "PIC600X600," +
//        "PIC640X480," +
//        "PIC_1," +
//        "PIC_2," +
//        "PIC_3," +
//        "PIC_4," +
//        "PIC_5," +
//        "PIC_BASE," +
//        "PIC_FULL," +
//        "PIC_MAX," +
//        "POSSIBLE_RELATIONS," +
//        "PREMIUM," +
//        "PRESENTS," +
//        "PRIVATE," +
//        "PROFILE_BUTTONS," +
//        "PROFILE_COVER," +
//        "PROFILE_PHOTO_SUGGEST_ALLOWED," +
//        "PYMK_PIC224X224," +
//        "PYMK_PIC288X288," +
//        "PYMK_PIC600X600," +
//        "PYMK_PIC_FULL," +
//        "REF," +
//        "REGISTERED_DATE," +
//        "REGISTERED_DATE_MS," +
//        "RELATIONS," +
//        "RELATIONSHIP," +
//        "SEND_MESSAGE_ALLOWED," +
//        "SHORTNAME," +
//        "SHOW_LOCK," +
//        "STATUS," +
//        "UID," +
//        "URL_CHAT," +
//        "URL_CHAT_MOBILE," +
//        "URL_PROFILE," +
//        "URL_PROFILE_MOBILE," +
//        "VIP";

        if (NativeJS.flagsOR(fields, UserField.FIRST_NAME))     str += "FIRST_NAME,";
        if (NativeJS.flagsOR(fields, UserField.LAST_NAME))      str += "LAST_NAME,";
        //if (NativeJS.flagsOR(fields, UserField.DELETED))      // Поля не существует, если нет юзера - он не возвращает
        if (NativeJS.flagsOR(fields, UserField.BANNED))         str += "BLOCKED,";
        if (NativeJS.flagsOR(fields, UserField.AVATAR_50))      str += "PIC50X50,";
        if (NativeJS.flagsOR(fields, UserField.AVATAR_100))     str += "PIC128X128,";
        if (NativeJS.flagsOR(fields, UserField.AVATAR_200))     str += "PIC224X224,";
        if (NativeJS.flagsOR(fields, UserField.HOME))           str += "URL_PROFILE,";
        if (NativeJS.flagsOR(fields, UserField.SEX))            str += "GENDER,";
        if (NativeJS.flagsOR(fields, UserField.ONLINE))         str += "LAST_ONLINE_MS,";

        if (str == '')
            return str;

        return str.substring(0, str.length - 1);
    }
}