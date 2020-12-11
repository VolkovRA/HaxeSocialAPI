package social.task.client;

import social.network.INetworkClient;
import social.user.User;

/**
 * Задача получения списка друзей.
 */
@:dce
interface IGetFriendsTask extends ITask<IGetFriendsTask, INetworkClient> 
{
    /**
     * ID Пользователя, список друзей которого нужно получить.  
     * По умолчанию: `null`
     */
    public var user(default, null):UserID;

    /**
     * Ключ авторизации, с которым должен быть выполнен данный запрос.  
     * По умолчанию: `null`
     */
    public var token(default, null):String;

    /**
     * Загруженный список друзей.  
     * Становится доступным после завершения выполнения задачи.
     * 
     * По умолчанию: `null`
     */
     public var result(default, null):Array<UserID>;

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