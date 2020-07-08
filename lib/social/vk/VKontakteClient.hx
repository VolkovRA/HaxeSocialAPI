package social.vk;

import haxe.DynamicAccess;
import js.Browser;
import js.lib.Error;
import js.html.ScriptElement;
import js.html.Event;
import loader.Balancer;
import social.ISocialNetworkClient;
import social.SocialNetworkType;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.vk.task.GetUsersTask;
import social.vk.task.GetFriendsTask;
import social.vk.enums.UserPermissions;
import social.vk.sdk.SDK;

/**
 * Реализация интерфейса VK для клиентского приложения.
 * 
 * @see Документация VK: https://vk.com/dev/manuals
 */
class VKontakteClient implements ISocialNetworkClient 
{
    /**
     * URL Адрес для подключения VK JavaScript SDK.
     */
    static public inline var SDK_URL:String = "https://vk.com/js/api/xd_connection.js?2";

    // Приват
    static private var tagSdk:ScriptElement;
    private var onComplete:Error->Void;

    /**
     * Создать интерфейс VK.
     */
    public function new() {
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public var title(default, null):String              = "VKontakte";
    public var apiURL(default, null):String             = "https://api.vk.com/method/";
    public var apiVersion(default, null):String         = "5.120"; // 03.07.2020
    public var type(default, null):SocialNetworkType    = SocialNetworkType.VK;
    public var parser(default, null):IParser            = new Parser();
    public var balancer(default, null):Balancer         = new Balancer(3);
    public var isInit(default, null):Bool               = false;
    public var appID:String                             = null;
    public var token:String                             = null;
    public var requestRepeatTry:Int                     = 3;
    public var permissionFriends(get, never):Bool;

    public function get_permissionFriends():Bool {
        return Utils.flagsOR(permissions, UserPermission.FRIENDS);
    }

    public function init(onComplete:Error->Void = null):Void {
        if (isInit) {
            if (onComplete != null)
                onComplete(new Error("The VK API interface is already initialized"));
            return;
        }
        
        isInit = true;

        if (tagSdk == null) {
            this.onComplete = onComplete;

            // Подключение SDK:
            tagSdk = Browser.document.createScriptElement();
            tagSdk.addEventListener("load", onSDKLoadComplete);
            tagSdk.addEventListener("error", onSDKLoadError);
            tagSdk.src = SDK_URL;
            Browser.document.head.appendChild(tagSdk);
        }
        else {
            if (onComplete != null)
                onComplete(null);
        }
    }
    private function onSDKLoadError(e:Event):Void {
        tagSdk.removeEventListener("load", onSDKLoadComplete);
        tagSdk.removeEventListener("error", onSDKLoadError);

        if (tagSdk.parentNode == Browser.document.head)
            Browser.document.head.removeChild(tagSdk);

        tagSdk = null;

        if (onComplete != null) {
            var f = onComplete;
            onComplete = null;
            f(new Error("Failed to load VK JavaScript SDK"));
        }
    }
    private function onSDKLoadComplete(e:Event):Void {
        tagSdk.removeEventListener("load", onSDKLoadComplete);
        tagSdk.removeEventListener("error", onSDKLoadError);

        try {
            SDK.init(onSDKInitComplete, onSDKInitError, apiVersion);
        }
        catch(err:Dynamic) {
            if (onComplete != null) {
                var f = onComplete;
                onComplete = null;
                f(err);
            }
        }
    }
    private function onSDKInitComplete():Void {
        if (onComplete != null) {
            var f = onComplete;
            onComplete = null;
            f(null);
        }
    }
    private function onSDKInitError():Void {
        if (onComplete != null) {
            var f = onComplete;
            onComplete = null;
            f(new Error("Failed to init VK JavaScript SDK"));
        }
    }

    public function getUsers(   users:Array<SocialUser>,
                                fields:SocialUserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<SocialUser>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.users              = users;
        task.token              = token;
        task.fields             = fields == null ? task.fields : fields;
        task.onComplete         = onComplete;
        task.onProgress         = onProgress;
        task.priority           = priority;
        task.requestRepeatTry   = requestRepeatTry;
        task.start();
        return task;
    }

    public function getFriends( user:SID,
                                onComplete:IGetFriendsTask->Void = null,
                                priority:Int = 0
    ):IGetFriendsTask {
        var task:IGetFriendsTask = new GetFriendsTask(this);
        task.user               = user;
        task.token              = token;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.requestRepeatTry   = requestRepeatTry;
        task.start();
        return task;
    }

    @:keep
    public function toString():String {
        return "[VKontakteClient]";
    }



    ////////////////////////////////
    //   СОБСТВЕННАЯ РЕАЛИЗАЦИЯ   //
    ////////////////////////////////

    /**
     * Маска прав доступа к данным пользователя.
     * 
     * По умолчанию: `0` (Нет прав)
     */
    public var permissions:UserPermissions = 0;

    /**
     * Ссылка на JavaScript SDK VKontakte.
     * 
     * Становится доступной после завершения инициализации.
     * Поле продублировано просто для удобства.
     * 
     * Этот геттер аналогичен вызову:
     * ```
     * trace(social.vk.SDK);
     * ```
     * 
     * По умолчанию: `null`
     */
    public var sdk(get, never):Class<SDK>;
    inline function get_sdk():Class<SDK> {
        return SDK;
    }
}