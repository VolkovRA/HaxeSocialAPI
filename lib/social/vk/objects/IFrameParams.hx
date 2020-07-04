package social.vk.objects;

import social.vk.enums.Language;
import social.vk.enums.Referrer;
import social.vk.enums.ViewerType;
import social.vk.enums.UserPermissions;

/**
 * Параметры IFrame.
 * 
 * При запуске приложения ВКонтакте в него передаются данные об источнике
 * запуска, пользователе, его правах доступа и другая полезная информация.
 * 
 * @see Документация: https://vk.com/dev/apps_init
 */
typedef IFrameParams =
{
    /**
     * URL сервиса API, по которому необходимо осуществлять запросы.
     */
    @:optional var api_url:String;

    /**
     * Идентификатор запущенного приложения.
     */
    @:optional var api_id:Int;

    /**
     * Битовая маска настроек прав доступа текущего пользователя в приложении.
     */
    @:optional var api_settings:UserPermissions;

    /**
     * Идентификатор пользователя, который запустил приложение.
     */
    @:optional var viewer_id:Int;

    /**
     * Тип пользователя, который просматривает приложение.
     */
    @:optional var viewer_type:ViewerType;

    /**
     * Идентификатор сессии для осуществления запросов к API.
     * Устаревший параметр.
     */
    @:optional var sid:String;

    /**
     * Секрет, необходимый для подписи запросов к API.
     * **Устаревший параметр.**
     */
    @:optional var secret:String;

    /**
     * Ключ доступа для вызова методов API по классической схеме.
     */
    @:optional var access_token:String;

    /**
     * Идентификатор пользователя, со страницы которого было запущено приложение.
     * Если приложение запущено не со страницы пользователя, содержит `0`.
     */
    @:optional var user_id:Int;

    /**
     * Идентификатор сообщества, со страницы которого было запущено приложение.
     * Если приложение запущено не со страницы сообщества, содержит `0`.
     */
    @:optional var group_id:Int;

    /**
     * Если пользователь установил приложение, содержит `1`, иначе — `0`.
     */
    @:optional var is_app_user:Int;

    /**
     * Ключ, необходимый для авторизации пользователя на стороннем сервере.
     */
    @:optional var auth_key:String;

    /**
     * Идентификатор языка пользователя, просматривающего приложение.
     */
    @:optional var language:Language;

    /**
     * Идентификатор языка, которым можно заменить язык пользователя.
     * Возвращается для неофициальных языковых версий.
     */
    @:optional var parent_language:Language;

    /**
     * Если пользователем используется защищенное соединение – `1`, иначе — `0`.
     */
    @:optional var is_secure:Int;

    /**
     * Результат первого запроса к API, который выполняется при загрузке приложения.
     */
    @:optional var api_result:String;

    /**
     * Обозначение места, откуда пользователь перешёл в приложение.
     */
    @:optional var referrer:Referrer;

    /**
     * Хэш запроса.
     * Данные после символа # в строке адреса.
     */
    @:optional var hash:String;

    /**
     * Служебные параметры.
     */
    @:optional var lc_name:String;

    /**
     * Служебные параметры.
     */
    @:optional var ads_app_id:String;
}