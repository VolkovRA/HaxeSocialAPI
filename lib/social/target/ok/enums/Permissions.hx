package social.target.ok.enums;

/**
 * Права доступа.  
 * Документация: https://apiok.ru/ext/oauth/permissions
 */
@:enum abstract Permissions(String) to String from String
{
    /**
     * Основное разрешение, необходимо для вызова большинства методов.
     */
    var VALUABLE_ACCESS = "VALUABLE_ACCESS";

    /**
     * Получение длинных токенов от [OAuth авторизации](https://apiok.ru/ext/oauth/).
     */
    var LONG_ACCESS_TOKEN = "LONG_ACCESS_TOKEN";

    /**
     * Доступ к фотографиям.
     */
    var PHOTO_CONTENT = "PHOTO_CONTENT";

    /**
     * Доступ к группам.
     */
    var GROUP_CONTENT = "GROUP_CONTENT";

    /**
     * Доступ к видео.
     */
    var VIDEO_CONTENT = "VIDEO_CONTENT";

    /**
     * Разрешение приглашать друзей в игру методом [friends.appInvite](https://apiok.ru/dev/methods/rest/friends/friends.appInvite).
     */
    var APP_INVITE = "APP_INVITE";

    /**
     * Доступ к email адресу пользователя.
     */
    var GET_EMAIL = "GET_EMAIL";
}