package social.target.ok.enums;

/**
 * Способ запуска приложения.  
 * Описывает источник запуска приложения пользователем.
 * @see Документация: https://apiok.ru/dev/types/enums.ApplicationReferencePlace
 */
@:enum abstract ApplicationReferencePlace(String) to String from String
{
    var AD_LINK_BLOCK_FOR_ADS_MANAGER = "ad_link_block_for_ads_manager";

    /**
     * 129 - прямой запуск с телефона Android
     */
    var ANDROID_STANDALONE = "android_standalone";

    /**
     * 29 - переход по картинке в игровом блоке приложения
     */
    var APP_BLOCK = "app_block";

    /**
     * 30 - переход по ссылке в игровом блоке приложения
     */
    var APP_BLOCK_ACT_LINK = "app_block_act_link";

    /**
     * 131 - топовая игра из той же категории
     */
    var APP_BOTTOM_TOP_GAMES = "app_bottom_top_games";

    /**
     * 163 - продолжить играть
     */
    var APP_CONTINUE = "app_continue";

    /**
     * 11 - массовая нотификация из игры
     */
    var APP_NOTIFICATION = "app_notification";

    /**
     * 41 - application preset (configurable via web / app.apps.presets)
     */
    var APP_PRESET = "app_preset";

    /**
     * 98 - блок с промо акциями
     */
    var APP_PROMO_INFO = "app_promo_info";

    /**
     * 20 - с карды из поиска приложений
     */
    var APP_SEARCH_APPS = "app_search_apps";

    /**
     * 5 - с баннеров
     */
    var BANNER = "banner";

    /**
     * 13 - с картинки баннера
     */
    var BANNER_IMG = "banner_img";

    /**
     * 12 - с текста баннера
     */
    var BANNER_TEXT = "banner_text";

    /**
     * 74 - тестирование приложений
     */
    var BETA_APPS = "beta_apps";

    /**
     * 96 - рекомендованные от бигдаты
     */
    var BIG_DATA_APPS = "big_data_apps";

    /**
     * 100 - контрольная группа для BIG_DATA_APPS
     */
    var BIG_DATA_PLACEBO = "big_data_placebo";

    /**
     * 173 - блок Все из раздела Приложения
     */
    var BIZ_APP_ALL = "biz_app_all";

    /**
     * 167 - блок Популярные из раздела Приложения
     */
    var BIZ_APP_CATALOGUE = "biz_app_catalogue";

    /**
     * 176 - блок Рекомендуем из раздела Приложения
     */
    var BIZ_APP_RECO = "biz_app_reco";

    /**
     * 177 - Поиск из раздела Приложения
     */
    var BIZ_APP_SEARCH = "biz_app_search";

    /**
     * 178 - Баннер слайдера из раздела Приложения
     */
    var BIZ_APP_SLIDER = "biz_app_slider";

    var BIZ_APP_UPLOADED = "biz_app_uploaded";

    /**
     * 168 - блок Мои из раздела Приложения
     */
    var BIZ_APP_USER = "biz_app_user";

    /**
     * 4 - из каталога
     */
    var CATALOG = "catalog";

    /**
     * 75 - игры в чате
     */
    var CHAT = "chat";

    /**
     * 95 - сыграть ещё раз
     */
    var CHAT_PLAY_AGAIN = "chat_play_again";

    /**
     * 99 - карусель в играх в сообщениях
     */
    var CHAT_SLIDER = "chat_slider";

    /**
     * 76 - старт игры в чате
     */
    var CHAT_START = "chat_start";

    /**
     * 24 - Карды на портлете “Вас Объединяет с другом”
     */
    var COMMON_APPS = "common_apps";

    /**
     * 113 - иконка приложения на десктопе устройства
     */
    var DESKTOP_ICON = "desktop_icon";

    /**
     * 0 - прямой переход
     */
    var DIRECT = "direct";

    /**
     * 26 - внешняя ссылка в письме приглашения в игру
     */
    var EMAIL_APP_INVITE = "email_app_invite";

    /**
     * 27 - внешняя ссылка в письме нотификации от друга в игре
     */
    var EMAIL_APP_SUGGEST = "email_app_suggest";

    /**
     * 132 - блок частых приложений
     */
    var EOI_RECENT = "eoi_recent";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_0 = "exp_group_0";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_1 = "exp_group_1";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_2 = "exp_group_2";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_3 = "exp_group_3";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_4 = "exp_group_4";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_5 = "exp_group_5";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_6 = "exp_group_6";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_7 = "exp_group_7";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_8 = "exp_group_8";

    /**
     * 101 - 110 контрольные группы для экспериментов
     */
    var EXP_GROUP_9 = "exp_group_9";

    /**
     * 92 - ссылка на игру из всплывашки фав рассылки
     */
    var FAV_NOTIFICATION = "fav_notification";

    var FEED_HEADER = "feed_header";

    /**
     * 42 - приложения друзей
     */
    var FRIENDS_APPS = "friends_apps";

    /**
     * 15 - с карды из приложений друга
     */
    var FRIEND_APPS = "friend_apps";

    /**
     * 161 - портлет игр друзей в своей витрине
     */
    var FRIEND_APPS_PORTLET = "friend_apps_portlet";

    /**
     * 50 - общее с другом
     */
    var FRIEND_COMMON_APPS = "friend_common_apps";

    /**
     * 7 - кастомная лента друга
     */
    var FRIEND_CUSTOM_FEED = "friend_custom_feed";

    /**
     * 2 - лента друга
     */
    var FRIEND_FEED = "friend_feed";

    /**
     * 1 - приглашение друга (старое)
     */
    var FRIEND_INVITATION = "friend_invitation";

    /**
     * 6 - переход в приложение после получения предложения от друга
     */
    var FRIEND_NOTIFICATION = "friend_notification";

    /**
     * 3 - текст под фоткой пользователя
     */
    var FRIEND_PHOTO_UNDERTEXT = "friend_photo_undertext";

    /**
     * 10 - рекомендация друга
     */
    var FRIEND_SUGGEST = "friend_suggest";

    /**
     * 87 Портлет с играми крутящимися через нашу баннерокрутилку
     */
    var GAME_CAMPAIGN_PORTLET = "game_campaign_portlet";

    var GAME_CHALLENGE_PORTLET = "game_challenge_portlet";

    /**
     * 45 - текстовая ссылка в игровом фиде
     */
    var GAME_FEED_TEXT_LINK = "game_feed_text_link";

    var GAME_HYPERCASUAL_PORTLET = "game_hypercasual_portlet";

    /**
     * 94 - ссылка на игру из топика открытого из ленты новостей из игр
     */
    var GAME_NEWS_FEED = "game_news_feed";

    /**
     * 93 - ссылка на игру из топика открытого из портлета
     */
    var GAME_NEWS_FEED_PORTLET = "game_news_feed_portlet";

    /**
     * 159 - глобальный поиск в приложении Android
     */
    var GLOBAL_SEARCH = "global_search";

    /**
     * 134 - блок с промо акциями
     */
    var GOK_APP_PROMO_INFO = "gok_app_promo_info";

    /**
     * 135 - с карды из поиска приложений
     */
    var GOK_APP_SEARCH_APPS = "gok_app_search_apps";

    /**
     * 142 - тестирование приложений
     */
    var GOK_BETA_APPS = "gok_beta_apps";

    /**
     * 137 - из каталога
     */
    var GOK_CATALOG = "gok_catalog";

    /**
     * 140 - с карды из новых приложений
     */
    var GOK_NEW_APPS = "gok_new_apps";

    /**
     * 138 - портлеты с жанрами в витрине игр
     */
    var GOK_SHOWCASE_APPS = "gok_showcase_apps";

    /**
     * 141 - с карды из топа
     */
    var GOK_TOP_APPS = "gok_top_apps";

    /**
     * 144 - портлет с трендовыми играми. Десктопное приложение OK GameCenter
     */
    var GOK_TREND = "gok_trend";

    /**
     * 136 - с карды из моих приложений
     */
    var GOK_USER_APPS = "gok_user_apps";

    /**
     * 139 - портлеты мои игры в левой колонке
     */
    var GOK_USER_APPS_PORTLET = "gok_user_apps_portlet";

    /**
     * 146 - видеобаннер в портлете видео на главной странице новой витрины.  
     * Десктопное приложение OK GameCenter
     */
    var GOK_VIDEO = "gok_video";

    /**
     * 47 - текстовая ссылка в групповом фиде
     */
    var GROUP_FEED_TEXT_LINK = "group_feed_text_link";

    /**
     * 90 - ссылка на игру из шапки группы
     */
    var GROUP_PLAY_BUTTON = "group_play_button";

    var INTERNAL_OBJECT_ANNIVERSARY = "internal_object_anniversary";

    /**
     * 53 - ссылка на игру в медиатопике
     */
    var INTERNAL_OBJECT_APP_REF = "internal_object_app_ref";

    /**
     * 88 - ссылка на игру в медиатопике из сообщений
     */
    var INTERNAL_OBJECT_APP_REF_MESSAGE = "internal_object_app_ref_message";

    /**
     * 89 - ссылка на игру в медиатопике из нового в играх
     */
    var INTERNAL_OBJECT_NEWS_FEED = "internal_object_news_feed";

    /**
     * 128 - прямой запуск с телефона iOS
     */
    var IOS_STANDALONE = "ios_standalone";

    /**
     * 25 - внутренний сервис покупки музыки на Одноклассниках
     */
    var MUSIC = "music";

    /**
     * 116 - список загруженных игр
     */
    var MY_UPLOADED = "my_uploaded";

    /**
     * 156 - Панель навигации слева
     */
    var NAVIGATION_PANEL = "navigation_panel";

    var NEWBIE_BOT = "newbie_bot";

    /**
     * 17 - с карды из новых приложений
     */
    var NEW_APPS = "new_apps";

    /**
     * 55 - из оповещения о удалении оверлея
     */
    var NOTIFICATION_OVERLAY_DELETED = "notification_overlay_deleted";

    /**
     * 54 - из оповещения о прилеплении оверлея
     */
    var NOTIFICATION_OVERLAY_RECEIVED = "notification_overlay_received";

    /**
     * 158 - баннер промо услуг в ленте
     */
    var OFFER_BANNER_FEED = "offer_banner_feed";

    /**
     * 157 - баннер промо услуг в ленте
     */
    var OFFER_PROMO_FEED = "offer_promo_feed";

    /**
     * 22 - с карды из портлета наших приложений
     */
    var OUR_APPS = "our_apps";

    /**
     * 71 - пассивная массовая нотификация из игры
     */
    var PASSIVE_APP_NOTIFICATION = "passive_app_notification";

    /**
     * 91 - ссылка на игру из леера фав рассылки
     */
    var PASSIVE_FAV_NOTIFICATION = "passive_fav_notification";

    /**
     * 48 - пассивный инвайт в леере
     */
    var PASSIVE_FRIEND_INVITATION = "passive_friend_invitation";

    /**
     * 49 - пассивный саджест в леере
     */
    var PASSIVE_FRIEND_SUGGEST = "passive_friend_suggest";

    /**
     * 73 - пассивная simple нотификация из игры
     */
    var PASSIVE_SIMPLE_APP_NOTIFICATION = "passive_simple_app_notification";

    /**
     * 160 - раздел платежей
     */
    var PAYMENTS = "payments";

    /**
     * 19 - с карды из “обратите внимание”
     */
    var PAY_ATTENTION_APPS = "pay_attention_apps";

    /**
     * 162 - чат с группой мастеров
     */
    var PCHELA_CHAT_BOT = "pchela_chat_bot";

    /**
     * 155 - Панель исполнителя в профиле ОК
     */
    var PCHELA_EXECUTOR_PANEL = "pchela_executor_panel";

    /**
     * 164 - печать фото на странице фотографий пользователя
     */
    var PHOTO_PROMO = "photo_promo";

    /**
     * 44 - текстовая ссылка в описание фотографии
     */
    var PHOTO_TEXT_LINK = "photo_text_link";

    /**
     * 8 - с подарка
     */
    var PRESENT = "present";

    /**
     * 9 - с тултипа подарка
     */
    var PRESENT_TOOLTIP = "present_tooltip";

    /**
     * 63 - промо кнопка на вебе
     */
    var PROMO_BUTTON = "promo_button";

    /**
     * 65 - промо кнопка на вебе у друга
     */
    var PROMO_BUTTON_FRIEND = "promo_button_friend";

    var PROMO_BUTTON_IN_FEED = "promo_button_in_feed";

    /**
     * 68 - кнопка на витрине подарков на вебе в разделе “Актуальное”
     */
    var PROMO_BUTTON_IN_GIFTS_FRONT = "promo_button_in_gifts_front";

    /**
     * 69 - кнопка на витрине подарков на вебе в разделе “К празднику”
     */
    var PROMO_BUTTON_IN_GIFTS_FRONT_HOLIDAY = "promo_button_in_gifts_front_holiday";

    /**
     * 70 - кнопка на витрине подарков на мобе
     */
    var PROMO_BUTTON_IN_GIFTS_FRONT_MOB = "promo_button_in_gifts_front_mob";

    /**
     * 62 - Промо линк на вебе. Под аватаркой пользователя
     */
    var PROMO_LINK = "promo_link";

    /**
     * 64 - промо линк на вебе у друга. Под аватаркой друга на его странице
     */
    var PROMO_LINK_FRIEND = "promo_link_friend";

    /**
     * 67 - пункт меню в ШМ подарка на аватарке его владельца на вебе
     */
    var PROMO_LINK_IN_PRESENT_TOOLTIP = "promo_link_in_present_tooltip";

    /**
     * 66 - пункт меню в ШМ пользоваеля (например в списке друзей) на вебе
     */
    var PROMO_LINK_IN_USER_SHORTCUT_MENU = "promo_link_in_user_shortcut_menu";

    /**
     * 56 - промо подарок с аватарки.  
     * В данный момент не поддерживается в мобильных приложениях Одноклассники
     * на платформах iOS и Android.
     */
    var PROMO_PRESENT_AVATAR = "promo_present_avatar";

    /**
     * 57 - промо подарок из ленты
     */
    var PROMO_PRESENT_FEED = "promo_present_feed";

    /**
     * 59 - промо подарок из витрины
     */
    var PROMO_PRESENT_FRONT = "promo_present_front";

    /**
     * 61 - промо подарок из витрины друга
     */
    var PROMO_PRESENT_FRONT_FRIEND = "promo_present_front_friend";

    /**
     * 60 - промо подарок из витрины своей
     */
    var PROMO_PRESENT_FRONT_SELF = "promo_present_front_self";

    /**
     * 58 - промо подарок из оповещения
     */
    var PROMO_PRESENT_NOTIFICATION = "promo_present_notification";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_0 = "rb_0";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_1 = "rb_1";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_10 = "rb_10";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_11 = "rb_11";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_12 = "rb_12";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_13 = "rb_13";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_14 = "rb_14";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_15 = "rb_15";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_16 = "rb_16";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_17 = "rb_17";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_18 = "rb_18";

    /**
     * 77 - 86 цели для использования в РБ
     */
    var RB_19 = "rb_19";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_2 = "rb_2";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_3 = "rb_3";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_4 = "rb_4";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_5 = "rb_5";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_6 = "rb_6";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_7 = "rb_7";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_8 = "rb_8";

    /**
     * 31 - 40 цели для использования в РБ
     */
    var RB_9 = "rb_9";

    /**
     * 16 - с карды из рекомендованных приложений
     */
    var RECOMMENDED_APPS = "recommended_apps";

    /**
     * 43 - собственный фид
     */
    var SELF_FEED = "self_feed";

    /**
     * 150 - каталог услуг
     */
    var SERVICE_CATALOGUE = "service_catalogue";

    /**
     * 151 - сервисы по категориям
     */
    var SERVICE_CATEGORY = "service_category";

    /**
     * 152 - портлет популярное в каталоге услуг или в моих услугах
     */
    var SERVICE_POPULAR = "service_popular";

    /**
     * 154 - поиск услуг
     */
    var SERVICE_SEARCH = "service_search";

    /**
     * 153 - страница услуг пользователя
     */
    var SERVICE_USER = "service_user";

    /**
     * 21 - с карды из магазинов
     */
    var SHOPS_CATALOG_APPS = "shops_catalog_apps";

    /**
     * 23 - с карды из портлета развлечений
     */
    var SHORT_APPS = "short_apps";

    /**
     * 51 - портлеты с жанрами в витрине игр
     */
    var SHOWCASE_APPS = "showcase_apps";

    /**
     * 72 - simple нотификация из игры
     */
    var SIMPLE_APP_NOTIFICATION = "simple_app_notification";

    /**
     * 112 - раздел игровых подписок
     */
    var SUBSCRIPTION_AUTO = "subscription_auto";

    /**
     * 18 - с карды из топа
     */
    var TOP_APPS = "top_apps";

    /**
     * 143 - портлет с трендовыми играми
     */
    var TREND = "trend";

    /**
     * 14 - с карды из моих приложений
     */
    var USER_APPS = "user_apps";

    /**
     * 28 - по карде из моих приложений (снизу) на full screen аппликации
     */
    var USER_APPS_BOTTOM_APP_MAIN = "user_apps_bottom_app_main";

    /**
     * 52 - портлеты мои игры в левой колонке
     */
    var USER_APPS_PORTLET = "user_apps_portlet";

    /**
     * 46 - текстовая ссылка в пользовательском фиде
     */
    var USER_FEED_TEXT_LINK = "user_feed_text_link";

    /**
     * 97 - видеоролик
     */
    var VIDEO = "video";

    /**
     * 111 - портлет VIP-предложений от игр
     */
    var VIP_OFFERS = "vip_offers";

    /**
     * 119 - блок с промо акциями
     */
    var VITRINE_APP_PROMO_INFO = "vitrine_app_promo_info";

    /**
     * 120 - с карды из поиска приложений
     */
    var VITRINE_APP_SEARCH_APPS = "vitrine_app_search_apps";

    /**
     * 127 - тестирование приложений
     */
    var VITRINE_BETA_APPS = "vitrine_beta_apps";

    /**
     * 122 - из каталога игр по жанру
     */
    var VITRINE_CATALOG = "vitrine_catalog";

    /**
     * 115 - новая витрина игр, фичеринг в выпадающем списке
     */
    var VITRINE_DROP_DOWN_FEATURED = "vitrine_drop_down_featured";

    /**
     * 114 - новая витрина игр, топ в выпадающем списке
     */
    var VITRINE_DROP_DOWN_TOP = "vitrine_drop_down_top";

    /**
     * 125 - с карды из новых приложений
     */
    var VITRINE_NEW_APPS = "vitrine_new_apps";

    /**
     * 123 - портлеты с жанрами в витрине игр
     */
    var VITRINE_SHOWCASE_APPS = "vitrine_showcase_apps";

    /**
     * 126 - с карды из топа
     */
    var VITRINE_TOP_APPS = "vitrine_top_apps";

    /**
     * 121 - с карды из моих приложений
     */
    var VITRINE_USER_APPS = "vitrine_user_apps";

    /**
     * 124 - портлеты мои игры в левой колонке
     */
    var VITRINE_USER_APPS_PORTLET = "vitrine_user_apps_portlet";

    /**
     * 145 - видеобаннер в портлете видео на главной странице новой витрины
     */
    var VITRINE_VIDEO = "vitrine_video";

    /**
     * 130 - Оповещение об изменении статуса товара в Юле
     */
    var YOULA_ADVERT_NOTIFICATION = "youla_advert_notification";

    /**
     * 133 - Создание объявления в Юле
     */
    var YOULA_CREATE_ADVERT = "youla_create_advert";

    /**
     * 148 - ссылка на создание объявления Юлы из мотиватора
     */
    var YOULA_CREATE_ADVERT_MOTIVATOR = "youla_create_advert_motivator";

    /**
     * 149 - ссылка на создание объявления Юлы из порт
     */
    var YOULA_CREATE_ADVERT_PORTLET = "youla_create_advert_portlet";

    /**
     * 147 - ссылка на объявления Юлы в новом навигационном меню
     */
    var YOULA_NAV_ITEM = "youla_nav_item";

    /**
     * 117 - объявление в портлете Юлы
     */
    var YOULA_PORTLET_AD = "youla_portlet_ad";

    /**
     * 118 - все объявления в портлете Юлы
     */
    var YOULA_PORTLET_ALL = "youla_portlet_all";
}