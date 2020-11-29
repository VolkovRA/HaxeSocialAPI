package social.user;

/**
 * Гендерный признак пользователя.  
 * Этот енум содержит перечисление всех доступных вариантов.
 */
@:enum abstract Sex(Int) to Int from Int
{
    /**
     * Не указан.
     */
    var UNKNOWN = 0;

    /**
     * Мужчина.
     */
    var MALE = 1;

    /**
     * Женщина.
     */
    var FEMALE = -1;
}