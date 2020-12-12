package social.network;

import haxe.DynamicAccess;
import js.lib.Error;
import social.user.User;
import social.user.UserField;
import social.task.client.IGetFriendsTask;
import social.task.client.IGetUsersTask;
import social.task.client.IInviteTask;
import social.task.client.IPostTask;
import social.popup.PopupManager;

/**
 * API Интерфейс социальной сети для клиентского приложения.
 * 
 * Суть этого интерфейса в том, чтобы инкапсулировать и абстрагировать
 * параметры и методы различных соц. сетей, на сколько это возможно.
 * Это позволяет упростить работу и интеграцию с ними.
 * 
 * Этот интерфейс предназначен для использования на клиентской стороне.
 * Специфические API конкретных соц. сетей могут быть доступны в 
 * реализующих их классах, если обобщить их не представляется возможным.
 * 
 * Общий принцип работы с интерфейсом такой:
 * 1. Вы создаёте реализацию интерфейса нужной социальной сети.
 * 2. Настраиваете и инициализируете объект.
 * 3. Вызываете нужные методы.
 */
@:dce
interface INetworkClient extends INetwork
{
    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Статус инициализации.  
     * Равен `true`, если этот экземпляр API был проинициализирован и
     * готов к работе.
     * 
     * По умолчанию: `false`
     */
    public var isInit(default, null):Bool;

    /**
     * Права доступа к данным пользователя.  
     * Содержит список прав, имеющихся у приложения для доступа к тем или
     * иным данным пользователя.
     * 
     * Не может быть `null`
     */
    public var permissions(default, null):IPermissions;

    /**
     * Менеджер всплывающих окон.  
     * Используется для реализации очереди вызова диалоговых окон
     * социальной сети. В основном предназначен для внутренней работы,
     * но вы также можете добавлять и свои объекты в очередь для вызова
     * UI социальной сети.
     * 
     * Социальные сети не позволяют отображать более одного диалогово окна
     * и не имеют очереди для их вызова. Этот объект решает эти проблемы.
     * 
     * Не может быть `null`
     */
    public var popup(default, null):PopupManager;

    /**
     * ID Текущего пользователя в социальной сети.  
     * - Это значение доступно после инициализации интерфейса с флагом `iframe`.
     * - Вы можете самостоятельно задать это значение.
     * 
     * По умолчанию: `null`
     */
    public var user:UserID;

    /**
     * Клиентский ключ доступа к методам API.  
     * Используется для авторизации запросов на стороне социальной сети.
     * - Это значение доступно после инициализации интерфейса с флагом `iframe`.
     * - Вы можете самостоятельно задать это значение.
     * 
     * По умолчанию: `null`
     */
    public var token:String;

    /**
     * Ключ для авторизации на собственном сервере.  
     * Используется для авторизации запросов на вашем сервере, для проверки
     * подлинности клиента.
     * - Это значение доступно после инициализации интерфейса с флагом `iframe`.
     * - Вы можете самостоятельно задать это значение.
     * 
     * По умолчанию: `null`
     */
    public var authkey:String;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Инициализировать этот интерфейс.  
     * Перед началом работы интерфейс должен быть один раз инициализирован.
     * @param params Параметры инициализации.
     */
    public function init(?params:NetworkInitParams):Void;

    /**
     * Запросить данные пользователей.  
     * Выполнить запрос в социальную сеть и получить данные пользователей.
     * @param users Список запрашиваемых пользователей.
     * @param fields Запрашиваемые поля. Если `null`, используются поля по умолчанию.
     *               См.: `social.task.IGetUsersTask.fields`
     * @param onComplete Колбек завершения запроса.
     * @param onProgress Колбек прогресса загрузки.
     * @param priority Приоритет запроса. Используется для ограничения количества
     *                 одновременных запросов к API социальной сети.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function getUsers(   users:Array<User>,
                                fields:UserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<User>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask;

    /**
     * Получить список друзей пользователя.  
     * Выполнить запрос в социальную сеть и получить список друзей конкретного пользователя.
     * @param user ID Пользователя, список друзей которого нужно получить.
     * @param onComplete Колбек завершения выполнения запроса.
     * @param priority Приоритет запроса. Используется для ограничения количества
     *                 одновременных запросов к API социальной сети.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function getFriends( user:UserID,
                                onComplete:IGetFriendsTask->Void = null,
                                priority:Int = 0
    ):IGetFriendsTask;

    /**
     * Пригласить друзей.  
     * Открывает диалоговое окно с возможностью приглашения друзей в приложение.  
     * Для вызова этого метода требуется инициализация SDK.
     * @param users Список приглашаемых пользователей.
     * @param message Отправляемое сообщение.
     * @param onComplete Колбек завершения выполнения вызова.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function invite( users:Array<UserID> = null,
                            message:String = null,
                            onComplete:IInviteTask->Void = null
    ):IInviteTask;

    /**
     * Пост на стену.  
     * Открывает диалоговое окно с возможностью поделиться информацией.  
     * Для вызова этого метода требуется инициализация SDK.
     * @param message Текст сообщения.
     * @param image Изображение. Формат данных зависит от платформы.
     * @param link URL Адрес внешнего ресурса.
     * @param onComplete Колбек завершения выполнения вызова.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function post(   message:String = null,
                            image:String = null,
                            link:String = null,
                            onComplete:IPostTask->Void = null
    ):IPostTask;
}

/**
 * Параметры для инициализации API интерфейса социальной сети.  
 */
typedef NetworkInitParams =
{
    /**
     * Колбек завершения инициализации.  
     * В случае неудачи передаётся объект с описанием ошибки.
     */
    @:optional var callback:Error->Void;

    /**
     * Инициализировать SDK.  
     * - Если `true`, будет произведена также инициализация и JavaScript SDK
     *   для данной соц. сети.
     * - Если `false`, SDK не будет инициализирована и связанные с ней методы
     *   будут недоступны.
     * 
     * По умолчанию: `false` *(Не инициализировать SDK)*
     */
    @:optional var sdk:Bool;

    /**
     * Инициализировать параметры iframe.  
     * Влияет на автоматическое определение таких параметров, как:
     * 1. `appID` ID Приложения в социальной сети.
     * 2. `user` ID Текущего пользователя.
     * 3. `token` Клиентский ключ для авторизации.
     * 
     * - Если `true`, будет произведена попытка чтения переданных параметров
     *   в iframe. Этот механизм передачи данных обычно используется в
     *   социальных сетях для запуска web приложений внутри iframe.
     * - Если `false`, данные iframe не считываются.
     * 
     * По умолчанию: `false` *(Не считывать параметры в iframe)*
     */
    @:optional var iframe:Bool;
}