package social.task;

import social.user.User;

/**
 * Задача приглашения друзей в приложение.
 */
interface IInviteFriendsTask extends ITask<IInviteFriendsTask> 
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
     * Список приглашённых пользователей.  
     * Содержит список пользователей, которым игрок отправил запрос.
     * 
     * Может быть `null`
     */
    public var result:Array<UserID>;
}