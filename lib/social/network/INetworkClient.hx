package social.network;

import js.lib.Error;
import social.user.User;
import social.task.IInviteTask;

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
     * Ключ доступа для вызова методов API.  
     * Используется для авторизации запросов на стороне социальной сети.
     * 
     * **Обратите внимание**  
     * Перед использованием вы должны указать этот ключ.  
     * Обычно он передаётся в параметрах к iframe.
     * 
     * По умолчанию: `null`
     */
    public var token:String;



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
     * Пригласить друзей.  
     * Открывает диалоговое окно с возможностью приглашения друзей в приложение.  
     * - Для вызова этого метода требуется инициализация SDK.
     * - Вы можете проверить доступность этого функционала в: `social.network.INetwork.support.invite`
     * @param users Список приглашаемых пользователей.
     * @param message Отправляемое сообщение.
     * @param onComplete Колбек завершения выполнения вызова.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function invite( users:Array<UserID> = null,
                            message:String = null,
                            onComplete:IInviteTask->Void = null
    ):IInviteTask;
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
     * Если `true`, будет произведена также инициализация и JavaScript SDK.
     * 
     * По умолчанию: `false` *(Не инициализировать SDK)*
     */
    @:optional var sdk:Bool;
}