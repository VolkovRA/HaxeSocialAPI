package social.task.client;

import social.network.INetworkClient;

/**
 * Задача постинга сообщения на стену.  
 * Вы можете получить экземпляр этого объекта путём вызова
 * метода API: `INetworkClient.post()` одной из реализаций
 * социальной сети.
 * 
 * Этот интерфейс описывает параметры задачи для всех типов
 * социальных сетей.
 */
@:dce
interface IPostTask extends ITask<IPostTask, INetworkClient> 
{
    /**
     * Текст сообщения.  
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.post.message`*
     */
    public var message(default, null):String;

    /**
     * Прикрепляемое изображение.  
     * Формат данных зависит от типа социальной сети:
     * 
     * |Сеть|Пример|Документация|
     * |:-|:-|:-|
     * |`VK`| `photo-192978621_457239019` | https://vk.com/dev/wall.post |
     * |`OK`| `https://mysite.com/logo.png` | https://apiok.ru/dev/methods/rest/mediatopic/mediatopic.post |
     * 
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.post.image`*  
     */
    public var image(default, null):String;

    /**
     * URL Адрес ресурса.  
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.post.link`*
     */
    public var link(default, null):String;

    /**
     * Результат вызова.  
     * Содержит реакцию пользователя, запостил или нет.
     * 
     * По умолчанию: `PostResult.UNKNOWN`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.post.result`*
     */
    public var result(default, null):PostResult;

    /**
     * Результат вызова - ID созданного поста.  
     * Содержит ссылку на созданный пост, если пользователь подтвердил действие.
     * 
     * По умолчанию: `null`
     * 
     * ---
     * *Может не поддерживаться. См.: `INetwork.capabilities.post.resultPostID`*
     */
     public var resultPostID(default, null):String;
}

/**
 * Результат вызова поста на стену.  
 * Описывает реакцию пользователя в ответ на вызов.
 */
@:enum abstract PostResult(String) to String from String
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
     * Пользователь разместил пост на своей стене.
     */
    var ACCEPTED = "accepted";

    /**
     * Отмена.  
     * Пользователь отменил вызов.
     */
    var CANCELED = "canceled";
}