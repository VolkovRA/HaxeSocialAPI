package social.task.client;

import social.network.INetworkClient;
import social.user.User;

/**
 * Задача для приглашения друзей в приложение.  
 * Вы можете получить экземпляр этого объекта путём вызова
 * метода API: `INetworkClient.invite()` одной из реализаций
 * социальной сети.
 * 
 * Этот интерфейс описывает параметры задачи для всех типов
 * социальных сетей.
 */
@:dce
interface IInviteTask extends ITask<IInviteTask, INetworkClient> 
{
    /**
     * Список приглашаемых пользователей.  
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.invite.users`*
     */
    public var users(default, null):Array<UserID>;

    /**
     * Текст приглашения.  
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.invite.message`*
     */
    public var message(default, null):String;

    /**
     * Результат вызова.  
     * Содержит реакцию пользователя, пригласил или нет.
     * 
     * По умолчанию: `InviteResult.UNKNOWN`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.invite.result`*
     */
    public var result(default, null):InviteResult;

    /**
     * Результат вызова - список приглашённых.  
     * Содержит ID пользователей, которым было отправлено приглашение.
     * 
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.invite.resultUsers`*
     */
    public var resultUsers(default, null):Array<UserID>;
}

/**
 * Результат вызова приглашения друзей.  
 * Описывает реакцию пользователя в ответ на вызов.
 */
@:enum abstract InviteResult(String) to String from String
{
    /**
     * Неизвестно.   
     * Пользователь не отреагировал на вызов метода или
     * социальная сеть не предоставила нам его ответ.
     * 
     * Значение по умолчанию.
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