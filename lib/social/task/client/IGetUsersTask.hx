package social.task.client;

import haxe.DynamicAccess;
import social.network.INetworkClient;
import social.user.User;
import social.user.UserField;

/**
 * Задача запроса данных пользователей.  
 * Данная задача может выполняться в несколько запросов, между
 * каждой порцией данных она будет вызывать колбек: `onProgress`
 * 
 * Вы можете указать маску запрашиваемых данных: `fields`
 */
@:dce
interface IGetUsersTask extends ITask<IGetUsersTask, INetworkClient> 
{
    /**
     * Список запрошенных пользователей.  
     * По мере выполнения запросов к API пользователи в этом
     * списке будут заполняться данными.
     * - Список может быть пустым. (length=0)
     * - Список не должен содержать `null`.
     * - Список не должен быть `null`.
     * - Список не гарантирует фильтрацию дубликатов.
     * 
     * Не может быть `null`
     */
    public var users(default, null):Array<User>;

    /**
     * Ключ авторизации, с которым должен быть выполнен данный запрос.  
     * По умолчанию: `null`
     */
    public var token(default, null):String;

    /**
     * Маска запрашиваемых данных.  
     * Полезно для запроса только конкретных данных.
     * 
     * **Обратите внимание**  
     * Если какой-то флаг не указан, то соответствующие ему данные не
     * будут получены, даже если они придут в ответе от социальной сети.
     * 
     * По умолчанию: `0` *(Запросить все данные)*
     */
    public var fields(default, null):UserFields;

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

    /**
     * Колбек прогресса загрузки.  
     * Если назначен, этот обработчик будет вызываться каждый
     * раз при получении новой порции данных. Если запрос
     * большой, он будет выполняться частями, пока все данные
     * пользователей не будут загружены. С помощью этого колбека
     * вы можете отслеживать уже загруженных пользователей.
     * Вторым параметром передаётся мапа: `id->User` загруженных
     * пользователей социальной сети для вашего удобства.
     * 
     * Особенности:
     * - Вызывается как минимум один раз.
     * - Всегда предшествует вызову `onComplete`.
     * 
     * По умолчанию: `null`
     */
    public var onProgress:IGetUsersTask->DynamicAccess<User>->Void;
}