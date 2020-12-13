package social.target.ok;

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
import social.target.ok.objects.IFrameParams;
import social.target.ok.sdk.SDK;
import social.target.ok.task.client.InviteTask;
import social.target.ok.task.client.PostTask;
import social.target.ok.task.client.GetUsersTask;
import social.target.ok.task.client.GetFriendsTask;
import social.user.User;
import social.user.UserField;
import social.popup.PopupManager;
import social.utils.Dispatcher;
import social.utils.ErrorMessages;
import social.utils.NativeJS;
import social.utils.Tools;

/**
 * Реализация интерфейса OK для клиентского приложения.  
 * @see Документация: https://apiok.ru/
 */
@:dce
@:access(social.task)
class OdnoklassnikiClient extends Odnoklassniki implements INetworkClient 
{
    /**
     * URL Адрес для подключения VK JavaScript SDK.
     */
    static public inline var SDK_URL:String = "https://api.ok.ru/js/fapi5.js";

    // Приват
    private var sdkTag:ScriptElement;
    private var initParams:NetworkInitParams;

    /**
     * Создать интерфейс OK.
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
                if (iframe.apiconnection == null)       throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_APPID, ["apiconnection"]));
                if (iframe.logged_user_id == null)      throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_USERID, ["logged_user_id"]));
                if (iframe.session_secret_key == null)  throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_AUTHKEY, ["session_secret_key"]));
                if (iframe.session_key == null)         throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_TOKEN, ["session_key"]));
                if (iframe.application_key == null)     throw new Error(Tools.msg(ErrorMessages.IFRAME_NO_TOKEN, ["application_key"]));

                appID = parser.readAppID(iframe.apiconnection);
                user = NativeJS.str(iframe.logged_user_id);
                authkey = iframe.session_secret_key;
                token = iframe.session_key;
                applicationKey = iframe.application_key;
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

        var params = SDK.Util.getRequestParameters();
        SDK.init(params.api_server, params.apiconnection, onSDKInitComplete, onSDKInitError);
    }
    private function onSDKInitComplete():Void {
        var f = initParams.callback;
        initParams = null;

        // Глобальное событие методов UI:
        untyped Browser.window.API_callback = function(method:String, result:String, data:Dynamic) {
            onUIResult.emit(method, result, data);
        }

        if (f != null)
            f(null);
    }
    private function onSDKInitError(error:Error):Void {
        if (sdkTag.parentNode == Browser.document.head)
            Browser.document.head.removeChild(sdkTag);

        var f = initParams.callback;
        sdkTag = null;
        initParams = null;

        if (f != null)
            f(new Error(ErrorMessages.SDK_INIT_ERROR + "\n" + Std.string(error)));
    }

    public function getUsers(   users:Array<User>,
                                fields:UserFields = 0,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<User>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.users              = users;
        task.token              = token;
        task.fields             = fields;
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
        return "[OdnoklassnikiClient]";
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
     * Глобальный колбек обратного вызова для всех методов категорий UI.  
     * Подпишитесь на это событие самостоятельно, если вам нужно получать
     * обратный вызов в ответ на использование всех методов категорий UI.
     * 
     * Не может быть `null`
     */
    @:keep
    public var onUIResult(default, null):Dispatcher<API_callback> = new Dispatcher();

    /**
     * Ссылка на JavaScript SDK.  
     * Становится доступной после завершения инициализации.  
     * Поле продублировано просто для удобства обращения.
     * 
     * Этот геттер аналогичен вызову:
     * ```
     * trace(social.target.ok.sdk.SDK);
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