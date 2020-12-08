package social.task.server;

import social.network.INetworkServer;
import social.user.User;

/**
 * Задача получения списка друзей.
 */
@:dce
interface IGetFriendsTask extends ITask<IGetFriendsTask, INetworkServer> 
{
    /**
     * ID Пользователя, список друзей которого нужно получить.  
     * По умолчанию: `null`
     */
    public var user:UserID;

    /**
     * Ключ авторизации, с которым должен быть выполнен данный запрос.  
     * По умолчанию: `null`
     */
    public var token:String;

    /**
     * Список друзей.  
     * Становится доступным после завершения выполнения задачи.
     * 
     * По умолчанию: `null`
     */
    public var users:Array<UserID>;

    /**
     * Приоритет выполнения задачи.  
     * Используется для повышения или понижения приоритета для
     * запросов к социальной сети. Задачи с высоким приоритетом
     * отправят свои запросы раньше остальных.
     * 
     * По умолчанию: `0`
     */
    public var priority:Int;

    /**
     * Количество повторных попыток запроса в случае ошибки.  
     * Инициирует повторный запрос в случае ошибки указанное
     * количество раз до получения валидного ответа или
     * исчерпания попыток.
     * 
     * *п.с. При повторных запросых колбеки не вызываются.*
     * 
     * По умолчанию: `social.network.INetwork.requestRepeatTry`
     */
    public var requestRepeatTry:Int;
}