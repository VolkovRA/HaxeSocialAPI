package social.user;

import social.utils.Timestamp;

/**
 * Пользователь социальной сети.  
 * 
 * Этот интерфейс описывает обощённый объект, содержащий данные
 * пользователя из любой социальной сети. Разные реализаций интерфейса
 * могут немного по разному поддерживать те или иные функций, но в
 * целом, они придерживаются этого общего API.
 * 
 * @see Данные пользователя VK: https://vk.com/dev/objects/user
 */
typedef User =
{
    /**
     * ID Пользователя в социальной сети. *(Строка)*  
     * Уникальный идентификатор пользователя в социальной сети
     * для его однозначной идентификации.
     * 
     * Не может быть: `null`
     */
    var id:UserID;

    /**
     * Дата последнего обновления данных. *(mc)*  
     * Содержит временную метку последнего запроса данных
     * для этого пользователя из социальной сети.
     * - Всегда автоматически проставляется при запросе данных этого пользователя.
     * 
     * По умолчанию: `null`
     */
    @:optional var dateUpdated:Timestamp;
    
    /**
     * Имя пользователя.  
     * По умолчанию: `null`
     */
    @:optional var firstName:String;

    /**
     * Фамилия пользователя.  
     * По умолчанию: `null`
     */
    @:optional var lastName:String;

    /**
     * Статус онлайна пользователя.  
     * По умолчанию: `null`
     */
    @:optional var online:OnlineType;

    /**
     * Гендернывй признак пользователя.  
     * По умолчанию: `null`
     */
    @:optional var sex:Sex;

    /**
     * URL Адрес домашней страницы пользователя.  
     * По умолчанию: `null`
     */
    @:optional var home:String;

    /**
     * URL Адрес аватарки пользователя: **50x50**  
     * По умолчанию: `null`
     */
    @:optional var avatar50:String;

    /**
     * URL Адрес аватарки пользователя: **100x100**  
     * По умолчанию: `null`
     */
    @:optional var avatar100:String;

    /**
     * URL Адрес аватарки пользователя: **200x200**  
     * По умолчанию: `null`
     */
    @:optional var avatar200:String;

    /**
     * Статус блокировки пользователя в социальной сети. *(Забанен)*  
     * - У заблокированного пользователя могут быть по-прежнему
     *   доступны некоторые данные.
     * 
     * По умолчанию: `null`
     */
    @:optional var banned:Bool;

    /**
     * Статус отсутствия пользователя в социальной сети. *(Удалён или никогда не существовал)*  
     * - У удалённого пользователя не доступны никакие данные.
     * 
     * По умолчанию: `null`
     */
    @:optional var deleted:Bool;
}

/**
 * ID Пользователя социальной сети. *(Строка)*  
 * Уникальный идентификатор пользователя в социальной сети.
 */
typedef UserID = String;