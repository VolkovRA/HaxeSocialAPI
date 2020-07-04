package social;

/**
 * Маска параметров пользователя социальной сети.
 * 
 * Используется для перечисления свойств объекта: `SocialUser`,
 * при запросе его данных из соц. сети и т.п.
 */
typedef SocialUserFields = Int;

/**
 * Поле данных пользователя социальной сети.
 * 
 * Перечисление всех полей объекта: `SocialUser`, используется
 * при запросе данных из соц. сети и т.п.
 */
@:enum abstract SocialUserField(Int) to Int
{
    /**
     * ID Пользователя: `SocialUser.id`
     */
    var ID = 1;

    /**
     * Имя: `SocialUser.firstName`
     */
    var FIRST_NAME = 2;

    /**
     * Фамилия: `SocialUser.lastName`
     */
    var LAST_NAME = 4;

    /**
     * Статус онлайна: `SocialUser.online`
     */
    var ONLINE = 8;

    /**
     * URL Адрес страницы пользователя: `SocialUser.home`
     */
    var HOME = 16;

    /**
     * Гендернывй признак: `SocialUser.sex`
     */
    var SEX = 32;

    /**
     * URL Адрес аватарки пользователя 50x50: `SocialUser.avatar50`
     */
    var AVATAR_50 = 64;

    /**
     * URL Адрес аватарки пользователя 100x100: `SocialUser.avatar100`
     */
    var AVATAR_100 = 128;

    /**
     * URL Адрес аватарки пользователя 200x200: `SocialUser.avatar200`
     */
    var AVATAR_200 = 256;

    /**
     * Пользователь заблокирован: `SocialUser.banned`
     */
    var BANNED = 512;

    /**
     * Пользователь удалён или никогда не существовал: `SocialUser.deleted`
     */
    var DELETED = 1024;
}