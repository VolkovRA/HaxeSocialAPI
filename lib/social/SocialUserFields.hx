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
     * Имя: `SocialUser.firstName`
     */
    var FIRST_NAME = 1;

    /**
     * Фамилия: `SocialUser.lastName`
     */
    var LAST_NAME = 2;

    /**
     * Статус онлайна: `SocialUser.online`
     */
    var ONLINE = 4;

    /**
     * URL Адрес страницы пользователя: `SocialUser.home`
     */
    var HOME = 8;

    /**
     * Гендернывй признак: `SocialUser.sex`
     */
    var SEX = 16;

    /**
     * URL Адрес аватарки пользователя 50x50: `SocialUser.avatar50`
     */
    var AVATAR_50 = 32;

    /**
     * URL Адрес аватарки пользователя 100x100: `SocialUser.avatar100`
     */
    var AVATAR_100 = 64;

    /**
     * URL Адрес аватарки пользователя 200x200: `SocialUser.avatar200`
     */
    var AVATAR_200 = 128;

    /**
     * Пользователь заблокирован: `SocialUser.banned`
     */
    var BANNED = 256;

    /**
     * Пользователь удалён или никогда не существовал: `SocialUser.deleted`
     */
    var DELETED = 512;
}