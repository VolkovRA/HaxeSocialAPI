package social.task.server;

import social.network.INetworkServer;
import social.user.User;

/**
 * Задача установки уровня игрока.
 */
@:dce
interface ISetLevelTask extends ITask<ISetLevelTask, INetworkServer> 
{
    /**
     * ID Пользователя.  
     * Не может быть `null`
     */
    public var user:UserID;

    /**
     * Достигнутый уровень.  
     * Не может быть `null`
     */
    public var level:Int;

    /**
     * Ключ авторизации, с которым должен быть выполнен данный запрос.  
     * По умолчанию: `null`
     */
    public var token:String;

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