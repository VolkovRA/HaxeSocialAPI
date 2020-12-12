package social.target.vk;

import haxe.DynamicAccess;
import js.Browser;
import js.lib.Error;
import js.html.Event;
import js.html.ScriptElement;
import social.network.INetworkClient;
import social.task.client.IGetUsersTask;
import social.task.client.IGetFriendsTask;
import social.task.client.IInviteTask;
import social.task.client.IPostTask;
import social.target.vk.objects.IFrameParams;
import social.target.vk.sdk.SDK;
import social.target.vk.task.client.GetUsersTask;
import social.target.vk.task.client.GetFriendsTask;
import social.target.vk.task.client.InviteTask;
import social.target.vk.task.client.PostTask;
import social.user.User;
import social.user.UserField;
import social.popup.PopupManager;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация интерфейса VK для клиентского приложения.  
 * @see Документация: https://vk.com/dev/manuals
 */
@:dce
@:access(social.task)
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
    public var popup(default, null)         = new PopupManager();
    public var isInit(default, null)        = false;
    public var user:UserID                  = null;
    public var token:String                 = null;
    public var authkey:String               = null;

    public function init(?params:NetworkInitParams):Void {
        if (params == null)
            params = {};

        // Интерфейс уже инициализирован:
        if (isInit) {
            if (params.callback != null)
                params.callback(new Error(ErrorMessages.SOCIAL_ALREADY_INIT));
            return;
        }
        
        isInit = true;
        initParams = params;

        // Инициализация iframe:
        if (params.iframe) {
            try {
                iframe = parser.readIFrameParams();
                if (iframe.api_id == null)         throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_APPID, ["api_id"]));
                if (iframe.viewer_id == null)      throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_USERID, ["viewer_id"]));
                if (iframe.auth_key == null)       throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_AUTHKEY, ["auth_key"]));
                if (iframe.access_token == null)   throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_TOKEN, ["access_token"]));
                if (iframe.api_settings == null)   throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_PERMISSIONS, ["api_settings"]));

                appID = NativeJS.str(iframe.api_id);
                user = NativeJS.str(iframe.viewer_id);
                token = iframe.access_token;
                authkey = iframe.auth_key;
                permissions.mask = iframe.api_settings;
            }
            catch(err:Dynamic) {
                if (params.callback != null)
                    params.callback(new Error(ErrorMessages.IFRAME_READ_ERROR + "\n" + err.message));
                return;
            }
        }

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
            f(new Error(ErrorMessages.SDK_LOAD_ERROR));
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
            f(new Error(ErrorMessages.SDK_INIT_ERROR));
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
                            link:String = null,
                            onComplete:IPostTask->Void = null
    ):IPostTask {
        var task:IPostTask  = new PostTask(this);
        task.message        = message;
        task.image          = image;
        task.link           = link;
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
     * Параметры iframe.  
     * Это поле становится доступным после инициализации с
     * переданным флагом `iframe`.
     * 
     * По умолчанию: `null`
     */
    public var iframe(default, null):IFrameParams = null;

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