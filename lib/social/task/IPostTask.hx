package social.task;

/**
 * Задача постинга на стену.
 */
interface IPostTask extends ITask<IPostTask> 
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