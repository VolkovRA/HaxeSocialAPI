package social.target.vk.sdk;

import haxe.Constraints.Function;
import haxe.extern.Rest;

/**
 * Официальная JavaScript SDK ВКонтакте.  
 * В рантайме представлена глобальным объектом `VK`, тут переименована
 * для исключения конфликтов и приведения всех SDK соц. сетей к одному имени. 
 * 
 * Это описание глобального объекта VK, являющегося частью JavaScript SDK
 * ВКонтакте. Используется для вызова клиентских методов, окон, форм
 * социальной сети и выполнения запросов.
 * 
 * Перед использованием должна быть загружена на страницу и инициализирована:
 * ```
 * <script src="https://vk.com/js/api/xd_connection.js?2"  type="text/javascript"></script>
 * <script type="text/javascript">
 * VK.init(function() {
 *  // API initialization succeeded
 *  // Your code here
 * }, function() {
 *  // API initialization failed
 *  // Can reload page here
 * }, '5.120');
 * </script>
 * ```
 * Не будет работать, если родительский iframe не относится к https://vk.com/
 * @see Документация: https://vk.com/dev/Javascript_SDK 
 */
@:native("VK")
extern class SDK
{
    /**
     * Инициализировать приложение.  
     * Нужно иметь в виду, что инициализация приложения может закончиться ещё
     * до полной загрузки Вашего приложения и выполнения события: `window.onload`
     * @param onSuccess Функция, вызываемая при успешной инициализации API.
     * @param onFail Функция, вызываемая при ошибке.
     * @param apiVersion Версия API, используемая приложением.
     */
    public static function init(?onSuccess:Void->Void, ?onFail:Void->Void, ?apiVersion:String):Void;

    /**
     * Вызывать клиентский метод API пользовательского интерфейса.  
     * Пример вызова метода `showSettingsBox` для запроса прав доступа к стене,
     * аудио, видео и друзьям:
     * ```
     * VK.callMethod("showSettingsBox", 8214);
     * ```
     * @param methodName Название метода Client API.
     * @param params Параметры метода Client API.
     */
    public static function callMethod(methodName:Method, params:Rest<Dynamic>):Void;

    /**
     * Вызвать метод API.  
     * Пример вызова метода `wall.post` для создания записи с текстом `Hello!`:
     * ```
     * VK.api("wall.post", {"message": "Hello!", "v":"5.73"}, function (data) {
     *    alert("Post ID:" + data.response.post_id);
     * });
     * ```
     * @param methodName Название метода API.
     * @param params Объект, содержащий параметры метода.
     * @param callback Функция, в которую будет передан полученный результат после выполнения метода.
     * @see Описание методов API: https://vk.com/dev/methods
     */
    public static function api(methodName:String, ?params:Dynamic, ?callback:Function):Void;

    /**
     * Добавить обработчик событий VK.  
     * Добавляет функцию `callback` в качестве обработчика события с названием `eventName`.
     * Например, вывод хэша URL (значения после `#`) после его изменения:
     * ```
     * VK.addCallback('onLocationChanged', function f(location) {
     *     alert("location: " + location);
     * });
     * ```
     * @param eventName Событие.
     * @param callback Обработчик.
     */
    public static function addCallback(eventName:Event, callback:Function):Void;

    /**
     * Удаляет функцию `callback` из обработчика события с названием `eventName`.
     * @param eventName Событие.
     * @param callback Обработчик.
     */
    public static function removeCallback(eventName:Event, callback:Function):Void;

    /**
     * Объект для работы с виджетами VK.
     */
    public static var Widgets:Dynamic;
}