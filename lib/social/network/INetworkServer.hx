package social.network;

import haxe.DynamicAccess;
import social.user.User;
import social.user.UserField;
import social.task.IGetFriendsTask;
import social.task.IGetUsersTask;
import social.task.ISetLevelTask;
import social.task.ISetScoresTask;

/**
 * API Интерфейс социальной сети для серверного приложения. *(NodeJS)*  
 * 
 * Суть этого интерфейса в том, чтобы инкапсулировать и абстрагировать
 * параметры и методы различных соц. сетей, на сколько это возможно.
 * Это позволяет упростить работу и интеграцию с ними.
 * 
 * Этот интерфейс предназначен для использования на серверной стороне.
 * Специфические API конкретных соц. сетей могут быть доступны в 
 * реализующих их классах, если обобщить их не представляется возможным.
 * 
 * Общий принцип работы с интерфейсом такой:
 * 1. Вы создаёте реализацию интерфейса нужной социальной сети.
 * 2. Настраиваете и инициализируете объект.
 * 3. Вызываете нужные методы.
 */
@:dce
interface INetworkServer extends INetwork
{
    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Секретный ключ приложения.  
     * Необходим для проверки авторизации пользователей на вашем сервере.
     * Этот ключ выдаётся вам социальной сетью и должен использоваться
     * приложением на серверной стороне для проверки авторизации юзеров.
     * 
     * **Обратите внимание**  
     * Перед использованием вы должны указать этот ключ.  
     * Обычно он указан в настройках вашего приложения.
     * 
     * По умолчанию: `null`
     */
    public var secretKey:String;

    /**
     * Сервисный ключ доступа.  
     * Некоторые методы API социальной сети могут требовать этот ключ.
     * Этот ключ выдаётся приложению социальной сетью и используется на
     * серверной стороне для отправки запросов к API соц. сети.
     * 
     * **Обратите внимание**  
     * Перед использованием вы должны указать этот ключ.  
     * Обычно он указан в настройках вашего приложения.
     * 
     * По умолчанию: `null`
     */
    public var serviceKey:String;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

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
     * Проверка авторизации пользователя.  
     * Позволяет выполнить авторизацию и проверку пользователя.
     * - Возвращает `true`, если пользователь успешно проходит проверку
     *   на авторизацию.
     * - Возвращает `false` в остальных случаях.
     * - Генерирует исключение, если вы вызываете этот метод не в NodeJS.
     * 
     * @param id ID Пользователя в соц. сети.
     * @param key Ключ, которым представился пользователь.
     * @return Результат авторизации пользователя.
     * @throws Error Метод не имплементирован для использования на клиенте. *(В браузере)*
     */
    public function userCheckAuth(id:UserID, key:String):Bool;

    /**
     * Установить уровень игрока.  
     * Позволяет социальной сети показать достигнутый уровень игроком
     * в игре его друзьям или в ленте активности.
     * @param user ID Пользователя в социальной сети.
     * @param level Достигнутый уровень.
     * @param onComplete Колбек завершения выполнения запроса.
     * @param priority Приоритет запроса. Используется для ограничения количества
     *                 одновременных запросов к API социальной сети.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
    public function setLevel(   user:UserID,
                                level:Int,
                                onComplete:ISetLevelTask->Void = null,
                                priority:Int = 0
    ):ISetLevelTask;

    /**
     * Установить очки игрока.  
     * Позволяет социальной сети показать достигнутый результат игроком
     * в игре его друзьям или в ленте активности.
     * @param user ID Пользователя в социальной сети.
     * @param scores Достигнутый результат по очкам.
     * @param onComplete Колбек завершения выполнения запроса.
     * @param priority Приоритет запроса. Используется для ограничения количества
     *                 одновременных запросов к API социальной сети.
     * @return Новый экземпляр созданной задачи для её контроля и отслеживания.
     */
     public function setScores( user:UserID,
                                scores:Int,
                                onComplete:ISetScoresTask->Void = null,
                                priority:Int = 0
    ):ISetScoresTask;
}