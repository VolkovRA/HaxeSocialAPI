package social.task.client;

import social.network.INetworkClient;

/**
 * Задача постинга на стену.
 */
@:dce
interface IPostTask extends ITask<IPostTask, INetworkClient> 
{
    /**
     * Текст сообщения.  
     * Может быть `null`
     */
    public var message:String;

    /**
     * Прикрепляемое изображение.  
     * Формат данных зависит от платформы.
     * 
     * Может быть `null`
     */
    public var image:String;

    /**
     * URL Адрес внешнего ресурса.  
     * Может быть `null`
     */
    public var url:String;

    /**
     * Результат выполнения.  
     * Не может быть `null`
     */
    public var result:Bool;

    /**
     * ID Поста, если тот был создан.  
     * Может быть `null`
     */
    public var postID:String;
}