package social;

/**
 * Тип онлайна пользователя социальной сети.
 */
@:enum abstract OnlineType(Int) to Int
{
    /**
     * Не в сети.
     */
    var OFFLINE = 0;

    /**
     * В сети.
     */
    var ONLINE = 1;

    /**
     * В сети с мобильного телефона.
     */
    var ONLINE_MOBILE = 10;
}