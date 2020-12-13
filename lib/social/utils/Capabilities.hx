package social.utils;

/**
 * Поддерживаемый функционал и его возможности.  
 * Объект содержит описание поддерживаемого функционала
 * под конкретную соц. сеть. Дело в том, что хоть интерфейс
 * и абстрагирует API социальной сети, тем не менее, он
 * **может** различаться в некоторых деталях. Этот объект
 * описывает все важные различия, которые могут быть полезны.
 * 
 * Вы не должны изменять эти значения, они служат для
 * дополнительной информации и более тесной интеграции с
 * социальной сетью, а так-же для возможности оптимизации
 * некоторых запросов.
 */
typedef Capabilities =
{
    /**
     * Параметры поддержки приглашения друзей.  
     * Не может быть `null`
     */
    var invite:InviteCapabilities;

    /**
     * Параметры поддержки постинга.  
     * Не может быть `null`
     */
    var post:PostCapabilities;

    /**
     * Параметры поддержки уровней игроков.  
     * Не может быть `null`
     */
    var setLevel:SetLevelCapabilities;

    /**
     * Параметры поддержки очков игроков.  
     * Не может быть `null`
     */
    var setScores:SetScoresCapabilities;

    /**
     * Ограничение на количество одновременно запрашиваемых данных 
     * пользователей в одном запросе к социальной сети.
     * 
     * Используется при вызове метода: `getUsers()`. Библиотека
     * автоматически дробит большие запросы на несколько, если в
     * одном из них количество запрошенных пользователей превысит
     * это значение.
     * 
     * Не может быть `null`
     */
    var getUsersMax:Int;
}

/**
 * Параметры доступности функционала для приглашения друзей.  
 * Объект описывает поддерживаемый функционал методом: `INetworkClient.invite()`
 * в данной реализации социальной сети.
 */
typedef InviteCapabilities =
{
    /**
     * Функционал доступен.
     */
    var enabled:Bool;

    /**
     * Выбор приглашаемых пользователей.  
     * Вы можете указать список ID приглашаемых пользователей.
     * 
     * Поле: `IInviteTask.users`
     */
    var users:Bool;

    /**
     * Текст приглашения.  
     * Вы можете указать отправляемый текст приглашения.
     * 
     * Поле: `IInviteTask.message`
     */
    var message:Bool;

    /**
     * Результат вызова.  
     * Вы можете получить реакцию пользователя в ответ на этот вызов.
     * 
     * Поле: `IInviteTask.result`
     */
    var result:Bool;

    /**
     * Результат вызова - список приглашённых.  
     * Вы можете получить список приглашённых пользователей.
     * 
     * Поле: `IInviteTask.resultUsers`
     */
    var resultUsers:Bool;
}

/**
 * Параметры доступности функционала для постинга на стену.  
 * Объект описывает поддерживаемый функционал методом: `INetworkClient.post()`
 * в данной реализации социальной сети.
 */
typedef PostCapabilities =
{
    /**
     * Функционал доступен.
     */
    var enabled:Bool;

    /**
     * Текст сообщения.  
     * Вы можете указать произвольный текст для поста на стену.
     * 
     * Поле: `IPostTask.message`
     */
    var message:Bool;

    /**
     * Изображение.  
     * Вы можете указать произвольное изображение для отправки на стену.
     * 
     * Поле: `IPostTask.image`
     */
    var image:Bool;

    /**
     * Ссылка.  
     * Вы можете указать произвольную URL ссылку.
     * 
     * Поле: `IPostTask.link`
     */
    var link:Bool;

    /**
     * Результат вызова.  
     * Вы можете получить реакцию пользователя в ответ на этот вызов.
     * 
     * Поле: `IPostTask.result`
     */
    var result:Bool;

    /**
     * Результат вызова - ID созданного сообщения.  
     * Вы можете получить ссылку на созданное сообщение.
     * 
     * Поле: `IPostTask.resultPostID`
     */
    var resultPostID:Bool;
}

/**
 * Параметры доступности функционала для передачи уровня игрока социальной сети.
 * Объект описывает поддерживаемый функционал методом: `INetworkServer.setLevel()`
 * в данной реализации социальной сети.
 */
typedef SetLevelCapabilities =
{
    /**
     * Функционал доступен.
     */
    var enabled:Bool;
}

/**
 * Параметры доступности функционала для передачи очков игрока социальной сети.
 * Объект описывает поддерживаемый функционал методом: `INetworkServer.setScores()`
 * в данной реализации социальной сети.
 */
typedef SetScoresCapabilities =
{
    /**
     * Функционал доступен.
     */
    var enabled:Bool;
}