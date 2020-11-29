package social.target.vk;

import haxe.DynamicAccess;
import js.Browser;
import js.lib.Error;
import js.html.Event;
import js.html.ScriptElement;
import loader.Balancer;
import social.network.Constants;
import social.network.INetwork;
import social.network.INetworkClient;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.target.vk.sdk.SDK;
import social.target.vk.task.GetUsersTask;
import social.target.vk.task.GetFriendsTask;
import social.user.User;
import social.user.UserField;

/**
 * Реализация интерфейса VK для клиентского приложения.  
 * @see Документация VK: https://vk.com/dev/manuals
 */
@:dce
class VKontakteClient implements INetworkClient 
{
    /**
     * URL Адрес для подключения VK JavaScript SDK.
     */
    static public inline var SDK_URL:String = "https://vk.com/js/api/xd_connection.js?2";

    // Приват
    private var sdkTag:ScriptElement;
    private var initParams:NetworkInitParams;

    /**
     * Создать интерфейс VK.
     */
    public function new() {
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public var title(default, null)         = "VKontakte";
    public var apiURL(default, null)        = "https://api.vk.com/method/";
    public var apiVersion(default, null)    = "5.120"; // 03.07.2020
    public var type(default, null)          = NetworkType.VK;
    public var parser(default, null)        = new Parser();
    public var balancer(default, null)      = new Balancer(3);
    public var permissions(default, null)   = new Permissions();
    public var isInit(default, null)        = false;
    public var appID:String                 = null;
    public var token:String                 = null;
    public var requestRepeatTry             = 2;
    public var consts(default, null):Constants = {
        getUsersMax: 1000,
    };

    public function init(?params:NetworkInitParams):Void {
        if (params == null)
            params = {};

        // Интерфейс уже инициализирован:
        if (isInit) {
            if (params.callback != null)
                params.callback(new Error("API Интерфейс для ВКонтакте уже был инициализирован"));
            return;
        }
        
        isInit = true;
        initParams = params;

        // Инициализация SDK:
        if (params.sdk) {
            try {
                sdkTag = Browser.document.createScriptElement();
                sdkTag.addEventListener("load", onSDKLoadComplete);
                sdkTag.addEventListener("error", onSDKLoadError);
                sdkTag.src = SDK_URL;
                Browser.document.head.appendChild(sdkTag);
            }
            catch (err:Dynamic) {
                if (params.callback != null)
                    params.callback(err);
            }
            return;
        }

        // Готово:
        initParams = null;
        if (params.callback != null)
            params.callback(null);
    }
    private function onSDKLoadError(e:Event):Void {
        sdkTag.removeEventListener("load", onSDKLoadComplete);
        sdkTag.removeEventListener("error", onSDKLoadError);

        if (sdkTag.parentNode == Browser.document.head)
            Browser.document.head.removeChild(sdkTag);

        var f = initParams.callback;
        sdkTag = null;
        initParams = null;

        if (f != null)
            f(new Error("Ошибка загрузки JavaScript SDK для ВКонтакте"));
    }
    private function onSDKLoadComplete(e:Event):Void {
        sdkTag.removeEventListener("load", onSDKLoadComplete);
        sdkTag.removeEventListener("error", onSDKLoadError);

        try {
            SDK.init(onSDKInitComplete, onSDKInitError, apiVersion);
        }
        catch (err:Dynamic) {
            if (sdkTag.parentNode == Browser.document.head)
                Browser.document.head.removeChild(sdkTag);

            var f = initParams.callback;
            sdkTag = null;
            initParams = null;

            if (f != null)
                f(err);
        }
    }
    private function onSDKInitComplete():Void {
        var f = initParams.callback;
        initParams = null;
        if (f != null)
            f(null);
    }
    private function onSDKInitError():Void {
        if (sdkTag.parentNode == Browser.document.head)
            Browser.document.head.removeChild(sdkTag);

        var f = initParams.callback;
        sdkTag = null;
        initParams = null;

        if (f != null)
            f(new Error("Ошибка инициализации ВКонтакте JavaScript SDK"));
    }

    public function getUsers(   users:Array<User>,
                                fields:UserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<User>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.users              = users;
        task.token              = token;
        task.fields             = fields == null ? task.fields : fields;
        task.onComplete         = onComplete;
        task.onProgress         = onProgress;
        task.priority           = priority;
        task.start();
        return task;
    }

    public function getFriends( user:UserID,
                                onComplete:IGetFriendsTask->Void = null,
                                priority:Int = 0
    ):IGetFriendsTask {
        var task:IGetFriendsTask = new GetFriendsTask(this);
        task.user               = user;
        task.token              = token;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.start();
        return task;
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[VKontakteClient]";
    }



    ////////////////////////////////
    //   СОБСТВЕННАЯ РЕАЛИЗАЦИЯ   //
    ////////////////////////////////

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