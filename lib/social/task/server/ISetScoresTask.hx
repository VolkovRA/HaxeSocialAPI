package social.task.server;

import social.network.INetworkServer;
import social.user.User;

/**
 * Задача установки очков игрока.
 */
@:dce
interface ISetScoresTask extends ITask<ISetScoresTask, INetworkServer> 
{
    /**
     * ID Пользователя.  
     * Не может быть `null`
     */
    public var user(default, null):UserID;

    /**
     * Набранные очки.  
     * Не может быть `null`
     */
    public var scores(default, null):Int;

    /**
     * Ключ авторизации, с которым должен быть выполнен данный запрос.  
     * По умолчанию: `null`
     */
    public var token(default, null):String;

    /**
     * Приоритет выполнения задачи.  
     * Используется для повышения или понижения приоритета для
     * запросов к социальной сети. Задачи с высоким приоритетом
     * отправят свои запросы раньше остальных.
     * 
     * По умолчанию: `0`
     */
    public var priority(default, null):Int;

    /**
     * Количество повторных попыток запроса в случае ошибки.  
     * Инициирует повторный запрос в случае ошибки указанное
     * количество раз до получения валидного ответа или
     * полного исчерпания попыток.
     * 
     * *п.с. При повторных запросых колбеки не вызываются.*
     * 
     * По умолчанию: `social.network.INetwork.repeats`
     */
    public var repeats(default, null):Int;
}