package social;

/**
 * Пользователь социальной сети.
 * 
 * Обобщённый интерфейс для представления пользователя из любой соц. сети.
 */
typedef SocialUser =
{
    /**
     * ID Пользователя в социальной сети. (read-only)
     */
    var id:SID;
    
    /**
     * Имя.
     */
    @:optional var firstName:String;

    /**
     * Фамилия.
     */
    @:optional var lastName:String;

    /**
     * Статус онлайна.
     */
    @:optional var online:OnlineType;

    /**
     * Гендернывй признак.
     */
    @:optional var sex:Sex;

    /**
     * URL Адрес страницы пользователя.
     */
    @:optional var home:String;

    /**
     * URL Адрес аватарки пользователя: 50x50.
     */
    @:optional var avatar50:String;

    /**
     * URL Адрес аватарки пользователя: 100x100.
     */
    @:optional var avatar100:String;

    /**
     * URL Адрес аватарки пользователя: 200x200.
     */
    @:optional var avatar200:String;

    /**
     * Пользователь заблокирован.
     * 
     * У забаненного пользователя могут быть по прежнему доступны
     * некоторые данные.
     */
    @:optional var banned:Bool;

    /**
     * Пользователь удалён или никогда не существовал.
     * 
     * Никакие данные пользователя не будут доступны.
     */
    @:optional var deleted:Bool;
}