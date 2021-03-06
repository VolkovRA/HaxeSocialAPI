package social.target.vk.sdk;

/**
 * Событие VK SavaScript SDK.  
 * Используется в клиентском приложении для уведомления приложения
 * о произошедших событиях. Для получения события вы должны
 * подписаться на него: `VK.addCallback()`.
 * @see Документация: https://vk.com/dev/Javascript_SDK?f=4.3.%20%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA%20%D1%81%D0%BE%D0%B1%D1%8B%D1%82%D0%B8%D0%B9
 */
@:enum abstract Event(String) to String from String
{
    /**
     * Пользователь добавил приложение на свою страницу.
     */
    var APPLICATION_ADDED = "onApplicationAdded";

    /**
     * Пользователь изменил настройки приложения.  
     * Передаваемые параметры вместе с событием:
     * 1. `settings` Битовая маска прав доступа. `Int`
     */
    var SETTINGS_CHANGED = "onSettingsChanged";

    /**
     * Запрос отправлен успешно.
     */
    var REQUEST_SUCCESS = "onRequestSuccess";

    /**
     * Запрос отменен пользователем.
     */
    var REQUEST_CANCEL = "onRequestCancel";

    /**
     * Отправка запроса не удалась.  
     * Передаваемые параметры вместе с событием:
     * 1. `error` Текст сообщения об ошибке. `String`
     */
    var REQUEST_FAIL = "onRequestFail";

    /**
     * Событие происходит, когда пользователь положил или снял голоса с баланса
     * приложения.
     * 
     * Параметр `balance` содержит текущий баланс пользователя в сотых долях
     * голоса. Этот параметр можно использовать только для вывода пользователю.
     * Достоверность баланса всегда нужно проверять с помощью метода `secure.getAppBalance`.
     * 
     * Передаваемые параметры вместе с событием:
     * 1. `balance` Текущий баланс пользователя в сотых долях голоса. `Int`
     */
    var BALANCE_CHANGED = "onBalanceChanged";

    /**
     * Пользователь отменил покупку.
     */
    var ORDER_CANCEL = "onOrderCancel";

    /**
     * Покупка закончилась успешно.  
     * Передаваемые параметры вместе с событием:
     * 1. `orderId` Идентификатор заказа. `Int`
     * @see Обработка платежных уведомлений: https://vk.com/dev/payments_callbacks
     */
    var ORDER_SUCCESS = "onOrderSuccess";

    /**
     * Покупка закончилась неуспешно.  
     * Передаваемые параметры вместе с событием:
     * 1. `errorCode` Код ошибки. `Int`
     * @see Коды ошибок: https://vk.com/dev/payments_errors
     */
    var ORDER_FAIL = "onOrderFail";

    /**
     * Пользователь подтвердил сохранение фотографии в окне, вызванном
     * с помощью метода `showProfilePhotoBox` Client API.
     */
    var PROFILE_PHOTO_SAVE = "onProfilePhotoSave";

    /**
     * Событие происходит, когда размер окна приложения был изменен.  
     * Передаваемые параметры вместе с событием:
     * 1. `width` Новое значение ширины окна в px. `Int`
     * 2. `height` Новое значение высоты окна в px. `Int`
     */
    var WINDOW_RESIZED = "onWindowResized";

    /**
     * Событие происходит, когда изменяется значение хэша после символа `#`
     * в адресной строке браузера.
     * 
     * Например, это происходит в результате использования кнопок "назад" и
     * "вперед" в браузере. Это событие всегда происходит при запуске приложения.
     * 
     * Передаваемые параметры вместе с событием:
     * 1. `location` Новое значение хэша. `String`
     */
    var LOCATION_CHANGED = "onLocationChanged";

    /**
     * Событие происходит, когда окно с приложением теряет фокус.  
     * Например, когда пользователь открывает окно с настройками приложения.
     */
    var WINDOW_BLUR = "onWindowBlur";

    /**
     * Событие происходит, когда окно с приложением получает фокус.  
     * Например, когда пользователь закрывает окно с настройками приложения.
     */
    var WINDOW_FOCUS = "onWindowFocus";

    /**
     * Событие происходит, когда вызывается метод Client API `scrollTop`  
     * Передаваемые параметры вместе с событием:
     * 1. `scrollTop`       Текущее положение прокрутки. `Int`
     * 2. `windowHeight`    Высота окна в браузере. `Int`
     * 3. `offset`          Отступ от начала страницы до объекта с приложением. `Int`
     * 4. `isActive`        Активна ли текущая вкладка. `Bool`
     */
    var SCROLL_TOP = "onScrollTop";

    /**
     * Событие происходит при прокрутке страницы.  
     * Для того, чтобы подписаться на это событие, необходимо вызвать
     * метод `scrollSubscribe` Client API.
     * 
     * Передаваемые параметры вместе с событием:
     * 1. `scrollTop`       Текущее положение прокрутки. `Int`
     * 2. `windowHeight`    Высота окна в браузере. `Int`
     */
    var SCROLL = "onScroll";

    /**
     * Событие происходит, когда открывается всплывающее окно, и
     * flash-компоненты в приложении, у которых нет возможности установить
     * `wmode = "opaque"`, необходимо спрятать.
     * 
     * Передаваемые параметры вместе с событием:
     * 1. `show` Показать или спрятать компонент. `Bool`
     */
    var TOGGLE_FLASH = "onToggleFlash";

    /**
     * Ссылка на мобильную версию игры успешно отправлена.
     */
    var INSTALL_PUSH_SUCCESS = "onInstallPushSuccess";
}