package social.target.ok.enums;

/**
 * Мобильная платформа, на которой запущена игра.
 */
@:enum abstract MobilePlatform(String) to String from String
{
    /**
     * Мобильный браузер на платформе Android.
     */
    var ANDROIDWEB = "androidweb";

    /**
     * Android-приложение ОК.
     */
    var ANDROID = "android";

    /**
     * Мобильный браузер на платформе iOS.
     */
    var IOSWEB = "iosweb";

    /**
     * iOS-приложение ОК.
     */
    var IOS = "ios";

    /**
     * Все остальные случаи запуска.
     */
    var MOBWEB = "mobweb";
}