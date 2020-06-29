package social.vk;

/**
 * Обозначение места, откуда пользователь перешёл в приложение.
 * 
 * Этот тип может содержать одно **динамическое** значение:
 * (И снова привет от говнокодеров вк) `ad_{AD_ID}` – Если приложение
 * было открыто в результате перехода по рекламному объявлению.
 * `{AD_ID}` Содержит идентификатор рекламного объявления.
 * 
 * @see Документация: https://vk.com/dev/apps_init?f=6.%20referrer
 */
@:enum abstract Referrer(String) to String
{
    /**
     * Источник перехода неизвестен.
     */
    var UNKNOWN = "unknown";

    /**
     * Переход из левого меню.
     */
    var MENU = "menu";

    /**
     * Уведомление.
     */
    var NOTIFICATION = "notification";

    /**
     * Приложение запущено из блока рекомендаций.
     */
    var RECOMMENDATION = "recommendation";

    /**
     * Раздел активности друзей в каталоге.
     */
    var FRIENDS_FEED = "friends_feed";

    /**
     * Список популярных приложений в каталоге.
     */
    var CATALOG_POPULAR = "catalog_popular";

    /**
     * Список новых приложений в каталоге.
     */
    var CATALOG_NEW = "catalog_new";

    /**
     * Рекламный блок в каталоге.
     */
    var CATALOG_ADS = "catalog_ads";

    /**
     * Результаты быстрого поиска.
     */
    var QUICK_SEARCH = "quick_search";

    /**
     * Список собственных приложений пользователя.
     */
    var USER_APPS = "user_apps";

    /**
     * Список приложений в сообществе.
     */
    var GROUP = "group";

    /**
     * Центральный блок баннеров в каталоге.
     */
    var FEATURED = "featured";

    /**
     * Запрос.
     * В этом случае дополнительно вернутся параметры: `request_key` и `request_id`.
     */
    var REQUEST = "request";

    /**
     * Статус профиля.
     */
    var PROFILE_STATUS = "profile_status";

    /**
     * Специализированный рекламный блок в разделе **Приложения**.
     */
    var APP_SUGGESTIONS = "app_suggestions";

    /**
     * Название приложения в приглашении друга.
     * Со страницы: http://vk.com/apps
     */
    var JOIN_REQUEST = "join_request";

    /**
     * Подборка **Кассовые приложения** в каталоге.
     */
    var TOP_GROSSING = "top_grossing";

    /**
     * Подборка **Приложения друзей** в каталоге.
     */
    var FRIENDS_APPS = "friends_apps";

    /**
     * Тематические подборки в каталоге.
     */
    var COLLECTIONS = "collections";

    /**
     * Подборки по жанрам в каталоге.
     */
    var GENRE = "genre";

    /**
     * Список оповещений на странице: http://vk.com/apps
     */
    var NOTIFICATIONS_PAGE = "notifications_page";

    /**
     * Список **Мои приложения**: http://vk.com/apps?act=apps
     */
    var MYAPPS_PAGE = "myapps_page";

    /**
     * Подборка **Популярные** в каталоге.
     */
    var BESTSELLERS = "bestsellers";
}