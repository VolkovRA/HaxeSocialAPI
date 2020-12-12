package social.target.ok.objects;

import social.target.ok.enums.ApplicationReferencePlace;
import social.target.ok.enums.MobilePlatform;

/**
 * Параметры приложения.  
 * При открытии приложения на Одноклассниках ему передается особый
 * набор GET-параметров для идентификации пользователя и возможности
 * интеграции с API.
 * 
 * В зависимости от платформы, на которой запущено приложение (полная
 * версия сайта, мобильная версия сайта), ему могут передаваться разные
 * наборы параметров:
 * - Если приложение запущено на полной версии сайта, то ему передается
 *   параметр `container` со значением `true`;
 * - Если приложение запущено на мобильной версии сайта, то ему передается
 *   параметр `mob` со значением `true`.
 * 
 * Приведенные ниже параметры передаются приложениям, открывающимся в iframe.
 * @see Документация: https://apiok.ru/dev/app/
 */
typedef IFrameParams =
{
    /**
     * Основной URL API-сервера, например: `https://api.ok.ru/`  
     */
    @:optional var api_server:String;

    /**
     * Имя соединения.  
     */
    @:optional var apiconnection:String;

    /**
     * Открытый ключ приложения.
     */
    @:optional var application_key:String;

    /**
     * MD5-хеш параметров `logged_user_id+session_key+application_secret_key`  
     * Может использоваться для упрощенной проверки вошедшего в систему
     * пользователя.
     */
    @:optional var auth_sig:String;

    /**
     * Пользователь авторизован.  
     * - `1` Если авторизован.
     * - `0` В ином случае.
     */
    @:optional var authorized:Int;

    /**
     * Будет передан со значением `true`, если приложение открыто внутри
     * нативного приложения или iframe (при этом дополнительная шапка из
     * [widget.getWidgetContent](https://apiok.ru/dev/methods/rest/widget/widget.getWidgetContent)
     * не требуется)
     */
    @:optional var container:Bool;

    /**
     * Будет передан со значением `true`, если приложение открыто на
     * мобильной версии сайта.
     */
    @:optional var mob:Bool;

    /**
     * Мобильная платформа, на которой запущена игра.  
     * Параметр передаётся только если `mob=true`  
     * Список возможных значений:
     * - `androidweb` - мобильный браузер на платформе Android;
     * - `android` - android-приложение ОК;
     * - `iosweb` - мобильный браузер на платформе iOS;
     * - `ios` - iOS-приложение ОК;
     * - `mobweb` - все остальные случаи
     */
    @:optional var mob_platform:MobilePlatform;

    /**
     * Кастомные параметры, передаваемые, когда пользователь открывает
     * кастомную ссылку в ленте друга, принимает приглашение друга или
     * просматривает оповещение от друга.
     */
    @:optional var custom_args:String;

    /**
     * `1`, если это новый инсталл.
     */
    @:optional var first_start:Int;

    /**
     * Название мобильного виджета заголовка, который должен быть
     * показан на страницах приложения.
     */
    @:optional var header_widget:String;

    /**
     * Идентификатор авторизованного пользователя, который является постоянным.
     */
    @:optional var logged_user_id:Float;

    /**
     * Идентификатор способа, зависит от `refplace`  
     * Для способов, связанных с пользователем, это идентификатор друга.
     */
    @:optional var referer:String;

    /**
     * Способ запуска приложения.
     */
    @:optional var refplace:ApplicationReferencePlace;

    /**
     * Ключ сессии пользователя в приложении.
     */
    @:optional var session_key:String;

    /**
     * Секретный ключ сессии пользователя в приложении.
     */
    @:optional var session_secret_key:String;

    /**
     * MD5-хеш текущего запроса и `application_secret_key`
     */
    @:optional var sig:String;

    /**
     * Адрес веб-сервера Одноклассников, с которого запущена игра.
     */
    @:optional var web_server:String;

    /**
     * Есть ли активная промо-акция для показа перед игрой.
     */
    @:optional var payment_promo_active:Bool;

    /**
     * Используется ли новый формат подписи.
     */
    @:optional var new_sig:Bool;

    /**
     * Геопозиция пользователя, определенная по его IP-адресу.
     */
    @:optional var ip_geo_location:String;
}