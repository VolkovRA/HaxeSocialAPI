package social;

import haxe.DynamicAccess;
import loader.Balancer;
import social.SocialUserFields;
import social.task.IGetFriendsTask;
import social.task.IGetUsersTask;

/**
 * API Интерфейс социальной сети.
 * 
 * Используется как базовый интерфейс для клиентской
 * и серверной реализации. Содержит общие параметры
 * и методы.
 */
interface ISocialNetwork
{
    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Тип социальной сети.
     * 
     * Уникальный идентификатор типа социальной сети.
     * 
     * Не может быть `null`
     */
    public var type(default, null):SocialNetworkType;

    /**
     * Название социальной сети. (Английский)
     * 
     * Не может быть `null`
     */
    public var title(default, null):String;

    /**
     * Балансировщик запросов к API.
     * 
     * У каждой социальной сети есть собственные ограничения на количество
     * запросов в секунду. Этот балансировщик настроен по умолчанию для
     * каждой соц. сети. Доступ предоставлен для большего контроля.
     * 
     * Не может быть `null`.
     */
    public var balancer(default, null):Balancer;

    /**
     * Парсер данных социальной сети.
     * 
     * Не может быть `null`.
     */
    public var parser(default, null):IParser;

    /**
     * URL Адрес для отправки запросов к API социальной сети.
     * 
     * Не может быть `null`
     */
    public var apiURL(default, null):String;

    /**
     * Версия используемого API социальной сети.
     * 
     * Не может быть `null`
     */
    public var apiVersion(default, null):String;

    /**
     * ID Приложения.
     * 
     * Это уникальный идентификатор данного приложения в социальной сети.
     * 
     * По умолчанию: `null`
     */
    public var appID:String;

    /**
     * Общее количество попыток запросов к API.
     * 
     * Это значение используется некоторыми задачами по умолчанию.
     * Задаёт общее количество попыток запроса api до получения
     * валидного ответа. Между невалидными запросами колбеки не
     * вызываются.
     * 
     * По умолчанию: `3` (Всего 3 запроса)
     */
    public var requestRepeatTry:Int;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Загрузить данные пользователей.
     * @param users Список загружаемых пользователей.
     * @param fields Запрашиваемые поля. Если `null` - используются поля по умолчанию. (См. `IGetUsersTask.fields`)
     * @param onComplete Колбек завершения запроса.
     * @param onProgress Колбек прогресса загрузки.
     * @param priority Приоритет запроса.
     * @return Задача запроса данных пользователей.
     */
    public function getUsers(   users:Array<SocialUser>,
                                fields:SocialUserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<SocialUser>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask;

    /**
     * Получить список друзей пользователя.
     * @param user ID Пользователя, список друзей которого нужно получить.
     * @param onComplete Колбек завершения выполнения запроса.
     * @param priority Приоритет запроса.
     * @return Задача запроса списка друзей.
     */
    public function getFriends( user:SID,
                                onComplete:IGetFriendsTask->Void = null,
                                priority:Int = 0
    ):IGetFriendsTask;

    /**
     * Получить текстовое представление интерфейса.
     * @return Возвращает текстовое представление объекта.
     */
    @:keep
    public function toString():String;
}