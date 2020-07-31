package social;

import js.lib.Error;

/**
 * API Интерфейс социальной сети для клиентского приложения.
 * 
 * Суть этого интерфейса в том, чтобы инкапсулировать и абстрагировать
 * параметры и методы различных соц. сетей, на сколько это возможно.
 * Это позволяет упростить работу и интеграцию с ними.
 * 
 * Интерфейс предназначен для использования на клиентской стороне.
 * Специфические API конкретных соц. сетей могут быть доступны в 
 * реализующих их классах, если обобщить их не представляется возможным.
 * 
 * Общий принцип работы с интерфейсом такой:
 * 1. Вы создаёте реализацию интерфейса конкретной социальной сети.
 * 2. Настраиваете и инициализируете её.
 * 3. Вызываете методы или создаёте задачи: `ITask` для обращения к API.
 */
interface ISocialNetworkClient extends ISocialNetwork
{
    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Статус инициализации.
     * 
     * Равен `true`, если этот интерфейс API был проинициализирован и
     * готов к работе.
     * 
     * По умолчанию: `false`
     */
    public var isInit(default, null):Bool;

    /**
     * Ключ доступа для вызова методов API.
     * 
     * Используется для авторизации запроса на стороне социальной сети.
     * Для клиентских приложений ключ доступа передаётся в параметрах iframe.
     * 
     * По умолчанию: `null`
     */
    public var token:String;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Инициализировать клиентский API.
     * 
     * Некоторые интерфейсы могут требовать предварительной инициализации.
     * Если таковой не требуется, переданный колбек `onComplete` вызывается
     * мгновенно.
     * 
     * @param onComplete Обратный вызов завершения инициализации.
     */
    public function init(onComplete:Error->Void = null):Void;



    ////////////////////
    //   РАЗРЕШЕНИЯ   //
    ////////////////////

    /**
     * Разрешение на доступ к списку друзей.
     */
    public var permissionFriends(get, never):Bool;
}