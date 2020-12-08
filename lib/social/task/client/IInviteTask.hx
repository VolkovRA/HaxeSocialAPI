package social.task.client;

import social.network.INetworkClient;
import social.user.User;

/**
 * Задача приглашения друзей в приложение.
 */
@:dce
interface IInviteTask extends ITask<IInviteTask, INetworkClient> 
{
    /**
     * Список приглашаемых.  
     * Может быть `null`
     */
    public var users:Array<UserID>;

    /**
     * Текст приглашения.  
     * Может быть `null`
     */
    public var message:String;

    /**
     * Результат вызова.  
     * Содержит ответ пользователя на вызов данного метода API.
     * 
     * **Платформозависимые данные**  
     * Не все социальные сети возвращают это поле. Для подробностей
     * поддержки смотрите свойство: `INetwork.capabilities.invite`
     * 
     * По умолчанию: `InviteResult.UNKNOWN` *(Для всех соц. сетей)*
     */
    public var result:InviteResult;

    /**
     * Результат вызова - список приглашённых.  
     * Содержит список ID пользователей, которым было отправлено
     * приглашение.
     * 
     * **Платформозависимые данные**  
     * Не все социальные сети возвращают это поле. Для подробностей
     * поддержки смотрите свойство: `INetwork.capabilities.invite`
     * 
     * Может быть `null`
     */
    public var resultUsers:Array<UserID>;
}

/**
 * Результат вызова метода API для приглашения пользователей.
 */
@:enum abstract InviteResult(String) to String from String
{
    /**
     * Неизвестно.   
     * Пользователь не отриагировал на вызов метода или
     * социальная сеть не предоставила нам его ответ.
     */
    var UNKNOWN = "unknown";

    /**
     * Принято.  
     * Пользователь подтвердил приглашение друзей.
     */
    var ACCEPTED = "accepted";

    /**
     * Отмена.  
     * Пользователь отменил приглашение друзей.
     */
    var CANCELED = "canceled";
}