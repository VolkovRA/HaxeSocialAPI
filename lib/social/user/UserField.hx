package social.user;

import social.utils.Bitmask;

/**
 * Битовая маска параметров пользователя социальной сети.  
 * Используется для перечисления отдельных свойств объекта: `social.user.User`  
 * Это полезно, например, для указания конкретных, запрашиваемых данных пользователя.
 */
typedef UserFields = Bitmask;

/**
 * Флаг свойства пользователя социальной сети.  
 * Этот енум содержит перечисление для всех флагов битовой для маски: `social.user.UserFields`
 * 
 * Используется для перечисления отдельных свойств объекта: `social.user.User`  
 * Это полезно для указания конкретных, запрашиваемых данных пользователя.
 */
@:enum abstract UserField(UserFields) to UserFields from UserFields
{
    /**
     * Имя пользователя.  
     * Соответсвтует свойству: `social.user.User.firstName`
     */
    var FIRST_NAME = 1;

    /**
     * Фамилия пользователя.  
     * Соответсвтует свойству: `social.user.User.lastName`
     */
    var LAST_NAME = 2;

    /**
     * Статус онлайна.  
     * Соответсвтует свойству: `social.user.User.online`
     */
    var ONLINE = 4;

    /**
     * URL Адрес страницы пользователя.  
     * Соответсвтует свойству: `social.user.User.home`
     */
    var HOME = 8;

    /**
     * Гендернывй признак.  
     * Соответсвтует свойству: `social.user.User.sex`
     */
    var SEX = 16;

    /**
     * URL Адрес аватарки пользователя 50x50.  
     * Соответсвтует свойству: `social.user.User.avatar50`
     */
    var AVATAR_50 = 32;

    /**
     * URL Адрес аватарки пользователя 100x100.  
     * Соответсвтует свойству: `social.user.User.avatar100`
     */
    var AVATAR_100 = 64;

    /**
     * URL Адрес аватарки пользователя 200x200.  
     * Соответсвтует свойству: `social.user.User.avatar200`
     */
    var AVATAR_200 = 128;

    /**
     * Статус блокировки пользователя.  
     * Соответсвтует свойству: `social.user.User.banned`
     */
    var BANNED = 256;

    /**
     * Статус отсутствия пользователя. *(Удалён или никогда не существовал)*  
     * Соответсвтует свойству: `social.user.User.deleted`
     */
    var DELETED = 512;
}