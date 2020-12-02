package social.target.ok.sdk;

import js.lib.Error;
import haxe.Constraints.Function;
import haxe.extern.Rest;
import social.target.ok.objects.Attachment;
import social.target.ok.objects.IFrameParams;

/**
 * Официальная JavaScript SDK Одноклассников.  
 * Используется для вызова диалоговых окон социальной сети.
 * 
 * Для использования ваше приложение в iframe должно находиться
 * на сайте социальной сети.
 * 
 * @see Документация: https://apiok.ru/dev/sdk/js/
 */
@:native("FAPI")
extern class SDK
{
    /**
     * Утилиты SDK.
     */
    static public var Util(default, null):Util;

    /**
     * Методы для вызова диалоговых окон SDK.
     */
    static public var UI(default, null):UI;

    /**
     * Клиентское API.
     */
    static public var Client(default, null):Client;

    /**
     * Инициализировать SDK.  
     * Инициализация SDK должна производиться при первом открытии
     * приложения до вызова какого-либо другого метода SDK, а также
     * при внутренних переходах по фрейму игры.
     * @param apiServer Адрес сервера API. Можно получить с помощью метода `FAPI.Util.getRequestParameters`
     * @param apiConnection Идентификатор соединения с API. Можно получить с помощью метода `FAPI.Util.getRequestParameters`
     * @param onSuccess Успешная инициализация SDK.
     * @param onError Неуспешная инициализация SDK.
     */
    public static function init(apiServer:String, apiConnection:String, onSuccess:Void->Void, onError:Error->Void):Void;

    /**
     * Показать диалоговое окно оформления подписки.  
     * Отображает диалог подписки на товар / услугу в приложении. Для успешной подписки серверный
     * callback со стороны разработчика должен подтвердить подписку, иначе она закончится неудачей
     * и подписка не произведется.
     * 
     * В случае успешной подписки с периодичностью, указанной в настройках подписки, пользователь
     * автоматически будет производить оплату товара по подписке по стоимости, которая была
     * установлена разработчиков для данной подписки.
     * @param value Метод вызова.
     * @param productID ID Подписки, зарегистрированной в Одноклассников для приложения.
     * @param price Цена подписки за один период времени.
     * @see Документация: https://apiok.ru/dev/sdk/js/ui.showPaymentSubscription
     */
    static public function invokeUIMethod(value:UIMethod = UIMethod.SHOW_PAYMENT_SUBSCRIPTION, productID:String, price:Int):Void;
}

/**
 * Утилиты SDK.
 */
@:native("FAPI.Util")
extern class Util
{
    /**
     * Функция возвращает объект, состоящий из пар ключ-значение для GET-параметров запроса.
     * @return Возвращается объект, содержащий все параметры, переданные приложению в фрейме,
     *         в котором оно запущено.
     */
    public function getRequestParameters():IFrameParams;
}

/**
 * Методы SDK для работы с интерфейсом социальной сети.
 * 
 * **Обратите внимание**
 * Методы из группы FAPI.UI не требуют передачи callback-функции при вызове.
 * После выполнения метода будет вызвана глобальная функция, которую должен
 * реализовать разработчик. Функция должна иметь следующую сигнатуру:
 * ```
 * function API_callback(method, result, data);
 * ```
 */
@:native("FAPI.UI")
extern class UI
{
    /**
     * Показать диалоговое окно оплаты.  
     * Отображает диалог оплаты для конечного продукта. Для успешной оплаты серверный callback
     * со стороны разработчика должен подтвердить оплату, иначе оплата закончится неудачей и
     * средства будут возвращены пользователю. После успешного завершения транзакции приложение
     * получит уведомление «ok» и JSON с amount как данные, иначе он получит уведомление «error».  
     * Результат выполнения передаётся в глобальную функцию обратного вызова: `API_callback`
     * @param name Наименование продукта, например: 1 яблоня.
     * @param description Описание продукта, например: Золото позволяет покупать полезные вещи в игре.
     * @param code Идентификатор продукта, кодирующий продукты, сумму и т. п. в свободном формате.
     * @param price Общая стоимость в виртуальной валюте портала.
     * @param options Устарело. Всегда `null`.
     * @param attributes Кодированные JSON пары ключей/значений, содержащие дополнительные параметры
     *                   транзакции, которые будут переданы на сервер.
     * @param currency Валюта платежа, на данный момент поддерживается только `ok` (по умолчанию).
     * @param callback `"false"` (по умолчанию) - обновить приложение после успешного выполнения транзакции,
     *                 `"true"` - не обновлять приложение, а уведомить с помощью обратной связи
     *                 (см. раздел API_callback)
     * @param uiConf Кодированные JSON пары ключей/значений, содержащие конфигурацию для отображения
     *               UI диалога оплаты. См. раздел «Возможные значения атрибута uiConf».
     * @see Документация: https://apiok.ru/dev/sdk/js/ui.showPayment/
     */
    public function showPayment(
        name:String,
        description:String,
        code:String,
        price:Int,
        ?options:String,
        ?attributes:String,
        ?currency:String,
        ?callback:String,
        ?uiConf:String
    ):Void;

    /**
     * Подготовить rewarded-рекламу.  
     * - Используется только для rewarded-рекламы.
     * - Результат выполнения передаётся в глобальную функцию обратного вызова: `API_callback`
     * @see Документация: https://apiok.ru/dev/sdk/js/ui.loadAd
     */
    public function loadAd():Void;

    /**
     * Показать rewarded-рекламу пользователю.  
     * - Предварительно необходимо загрузить рекламу с помощью метода: `loadAd()`  
     * - Результат выполнения передаётся в глобальную функцию обратного вызова: `API_callback`
     */
    public function showLoadedAd():Void;

    /**
     * Показать interstitial-рекламу пользователю.  
     * - Этот метод доступен только для мобильной версий приложения.
     * - Предварительная загрузка рекламы не требуется.
     * - Результат выполнения передаётся в глобальную функцию обратного вызова: `API_callback`
     */
    public function showAd():Void;

    /**
     * Публикация медиатопика с подтверждением от пользователя.
     * @param attachment Объект с данными будущего медиатопика.
     * @param status Установить ли медиатопик в качестве текущего статуса.
     */
    public function postMediatopic(attachment:Attachment, ?status:Bool):Void;

    /**
     * Показать диалог приглашения пользователя.
     * @param text Текст, который будет отправлен в приглашении.
     * @param params Кастомные данные, передаваемые приложению, когда пользователь принимает
     *               приглашение. Данные будут переданы в параметре `custom_args`, подробную
     *               информацию см. в разделе [Параметры приложения](https://apiok.ru/dev/app/).
     *               Максимальная длина: 120 символов.
     * @param selected_uids Список идентификаторов друзей, которые будут уже выбраны при открытии
     *                      окна приглашения. Максимум 5 ID за запрос. Пользователи должны быть в
     *                      списке друзей, выделяются только те пользователи, которые играли в
     *                      последнее время в игры. Пример: `"3573457;2342321;343435"`.
     */
    public function showInvite(text:String, ?params:String, ?selected_uids:String):Void;

    /**
     * Показать диалог оповещения пользователя.
     * @param text Текст, который будет отправлен в оповещении.
     * @param params Кастомные данные, передаваемые приложению, когда пользователь принимает
     *               приглашение. Данные будут переданы в параметре `custom_args`, подробную
     *               информацию см. в разделе [Параметры приложения](https://apiok.ru/dev/app/).
     *               Максимальная длина: 120 символов.
     * @param selected_uids Список идентификаторов друзей, которые будут уже выбраны при открытии
     *                      окна приглашения. Максимум 20 ID за запрос. Пользователи должны быть в
     *                      списке друзей, выделяются только те пользователи, которые играли в
     *                      последнее время в игры. Пример: `"3573457;2342321;343435"`.
     */
    public function showNotification(text:String, ?params:String, selected_uids:String):Void;

    /**
     * Запросить права доступа у пользователя.  
     * Пример:
     * ```
     * var permissions = '"PHOTO_CONTENT","VALUABLE_ACCESS"';
     * ```
     * @param permissions Список запрашиваемых у пользователя прав. (См.: `social.target.ok.enums.Permissions`)
     */
    public function showPermissions(permissions:String):Void;

    /**
     * Получить информацию о странице. (Высота, ширина, позиция прокрутки, позиция iframe приложения)  
     * - Результат выполнения передаётся в глобальную функцию обратного вызова: `API_callback`
     */
    public function getPageInfo():Void;

    /**
     * Смена текущего URL пользователя.
     * @param url query-часть URL, которая будет добавлена, либо на которую будет заменена текущая query-часть URL.
     */
    public function changeHistory(url:String):Void;

    /**
     * Прокрутка страницы к указанной позиции.
     * @param left Координата по оси X.
     * @param top Координата по оси Y.
     */
    public function scrollTo(left:Int, top:Int):Void;

    /**
     * Прокрутка страницы к началу.
     */
    public function scrollToTop():Void;

    /**
     * Изменение размера контейнера приложения.
     * @param width Ширина контейнера с приложением. (100-760)
     * @param height Высота контейнера с приложением. (100-4000)
     */
    public function setWindowSize(width:Int, height:Int):Void;

    /**
     * Диалог на покупку ОКов (внутренней валюты одноклассников).
     */
    public function showPortalPayment():Void;
}

/**
 * Методы SDK для работы с клиентским API.
 */
@:native("FAPI.Client")
extern class Client
{
    /**
     * Функция используется для вызова [REST-методов](https://apiok.ru/dev/methods/) API.
     * @param params Набор пар ключ-значение для вызываемого метода (включая имя метода).
     * @param userCallback Функция, которая будет вызвана после ответа сервера: `function(status, data, error)`.
     * @param resig Требуется, когда необходимо запросить подтверждение пользователя на какое-либо
     *              действие через отдельное превью. Во всех остальных случаях вызывайте функцию,
     *              указав только 2 параметра.
     */
    public function call(params:Dynamic, userCallback:String->Dynamic->Error->Void, ?resig:Dynamic):Void;
}

/**
 * Глобальная функция обратного вызова для всех методов SDK UI.  
 * 
 * Методы из группы FAPI.UI не требуют передачи callback-функции при вызове.
 * После выполнения метода будет вызвана глобальная функция, которую должен реализовать разработчик.
 * Функция должна иметь следующую сигнатуру:
 * @param method Название вызванного метода.
 * @param result Результат выполнения (`ok` в случае успеха, `cancel` в случае, если пользователь
 *               отменил действие).
 * @param data Дополнительная информация, например, для showInvite() – это список id приглашенных
 *             друзей, разделенный запятыми, в формате строки.
 */
typedef API_callback = String->String->Dynamic->Void;

/**
 * Метод для вызова UI.
 */
@:enum abstract UIMethod(String) to String from String
{
    /**
     * Показ диалога оформления подписки на товар / услугу в игре.
     */
    var SHOW_PAYMENT_SUBSCRIPTION = "showPaymentSubscription";

    /**
     * Открытие фрейма игры во весь экран.
     */
    var REQUEST_FULLSCREEN = "requestFullscreen";

    /**
     * Показ подсказки для скролла для закрытия навигационного бара.
     */
    var SHOW_HIDELOCATION = "showHideLocation";

    /**
     * Обновление стикер-сетов на стороне мобильного ОК-приложения.
     */
    var UPDATE_STICKERSETS = "updateStickerSets";
}