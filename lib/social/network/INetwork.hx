package social.network;

import loader.Balancer;
import social.utils.Capabilities;

/**
 * Социальная сеть.  
 * Это базовый, обобщённый интерфейс для всех видов социальных сетей.
 */
@:dce
interface INetwork
{
    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    /**
     * Тип социальной сети.  
     * Уникальный идентификатор социальной сети для однозначной
     * её идентификации в рамках этой библиотеки.
     * 
     * Не может быть `null`
     */
    public var type(default, null):NetworkType;

    /**
     * Название социальной сети на английском.  
     * Удобно для текстового представления социальной сети человеку.
     * 
     * Не может быть `null`
     */
    public var title(default, null):String;

    /**
     * Балансировщик запросов к API.  
     * Используется для ограничения количества одновременных запросов
     * к API социальной сети.
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
     * Не может быть `null`.
     */
    public var parser(default, null):IParser;

    /**
     * URL Адрес для отправки запросов к API.  
     * Не может быть `null`
     */
    public var apiURL(default, null):String;

    /**
     * Версия используемого API социальной сети.  
     * Может быть `null`
     */
    public var apiVersion(default, null):String;

    /**
     * ID Приложения.  
     * Содержит уникальный идентификатор вашего приложения в социальной сети.  
     * Вы должны указать его самостоятельно.
     * 
     * По умолчанию: `null`
     */
    public var appID:String;

    /**
     * Количество повторных попыток запросов к API. *(По умолчанию)*  
     * Используется для указания количества повторных обращений к API
     * в случае ошибки, перед отклонением запроса с ошибкой.
     * 
     * Это значение используется задачами по умолчанию. Каждая конкретная
     * задача запроса к API может определить количество повторных попыток
     * на своё усмотрение.
     * 
     * По умолчанию: `2` *(Всего 3 запроса)*
     */
    public var requestRepeatTry:Int;

    /**
     * Параметры поддерживаемого функционала.  
     * Содержит описание и параметры поддерживаемого функционала
     * данной реализацией интерфейса.
     * 
     * Не может быть `null`
     */
    public var capabilities(default, null):Capabilities;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    /**
     * Получить текстовое представление объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String;
}

/**
 * Тип социальной сети.  
 * Уникальный идентификатор социальной сети для однозначной
 * её идентификации в рамках этой библиотеки.
 */
@:enum abstract NetworkType(String) to String from String
{
    /**
     * ВКонтакте.  
     * Домашняя страница: https://vk.com/
     */
    var VK = "VK";

    /**
     * Одноклассники.  
     * Домашняя страница: https://ok.ru/
     */
    var OK = "OK";

    /**
     * Facebook.  
     * Домашняя страница: https://www.facebook.com/
     */
    var FB = "FB";
}