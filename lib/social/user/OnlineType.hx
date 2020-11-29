package social.user;

/**
 * Статус онлайна пользователя.  
 * Этот енум содержит перечисление всех доступных вариантов.
 */
@:enum abstract OnlineType(Int) to Int from Int
{
    /**
     * Пользователь не в сети.
     */
    var OFFLINE = 0;

    /**
     * Пользователь в сети.
     */
    var ONLINE = 1;

    /**
     * Пользователь в сети с мобильного устройства.
     */
    var ONLINE_MOBILE = 10;
}