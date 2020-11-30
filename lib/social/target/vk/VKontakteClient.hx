package social.target.vk;

import haxe.DynamicAccess;
import js.Browser;
import js.lib.Error;
import js.html.Event;
import js.html.ScriptElement;
import social.network.INetworkClient;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.task.IInviteTask;
import social.task.IPostTask;
import social.target.vk.sdk.SDK;
import social.target.vk.task.GetUsersTask;
import social.target.vk.task.GetFriendsTask;
import social.target.vk.task.InviteTask;
import social.target.vk.task.PostTask;
import social.user.User;
import social.user.UserField;

/**
 * Реализация интерфейса VK для клиентского приложения.  
 * @see Документация VK: https://vk.com/dev/manuals
 */
@:dce
class VKontakteClient extends VKontakte implements INetworkClient 
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
        super();
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public var permissions(default, null)   = new Permissions();
    public var isInit(default, null)        = false;
    public var token:String                 = null;

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

    public function invite( users:Array<UserID> = null,
                            message:String = null,
                            onComplete:IInviteTask->Void = null
    ):IInviteTask {
        var task:IInviteTask    = new InviteTask(this);
        task.users              = users;
        task.message            = message;
        task.onComplete         = onComplete;
        task.start();
        return task;
    }

    public function post(   message:String = null,
                            image:String = null,
                            url:String = null,
                            onComplete:IPostTask->Void = null
    ):IPostTask {
        var task:IPostTask  = new PostTask(this);
        task.message        = message;
        task.image          = image;
        task.url            = url;
        task.onComplete     = onComplete;
        task.start();
        return task;
    }

    @:keep
    @:noCompletion
    override public function toString():String {
        return "[VKontakteClient]";
    }



    ////////////////////////////////
    //   СОБСТВЕННАЯ РЕАЛИЗАЦИЯ   //
    ////////////////////////////////

    /**
     * Ссылка на JavaScript SDK.  
     * Становится доступной после завершения инициализации.  
     * Поле продублировано просто для удобства обращения.
     * 
     * Этот геттер аналогичен вызову:
     * ```
     * trace(social.target.vk.sdk.SDK);
     * ```
     * 
     * По умолчанию: `null`
     */
    @:keep
    public var sdk(get, never):Class<SDK>;
    inline function get_sdk():Class<SDK> {
        return SDK;
    }
}