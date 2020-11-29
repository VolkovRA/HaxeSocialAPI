package social.target.vk;

import haxe.DynamicAccess;
import loader.Balancer;
import social.network.Support;
import social.network.INetwork;
import social.network.INetworkServer;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.target.vk.task.GetUsersTask;
import social.target.vk.task.GetFriendsTask;
import social.user.User;
import social.user.UserField;

/**
 * Реализация интерфейса VK для серверного приложения. (NodeJS)
 * @see Документация VK: https://vk.com/dev/manuals
 */
@:dce
class VKontakteServer implements INetworkServer
{
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
    public var appID:String                 = null;
    public var secretKey:String             = null;
    public var serviceKey:String            = null;
    public var requestRepeatTry             = 2;
    public var support(default, null):Support = {
        getUsersMax: 1000,

        inviteFriends: true,
        inviteFriendsUsers: false,
        inviteFriendsMessage: false,
        inviteFriendsResult: false,
    };

    public function getUsers(   users:Array<User>,
                                fields:UserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<User>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.users              = users;
        task.token              = serviceKey;
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
        task.token              = serviceKey;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.start();
        return task;
    }

    public function userCheckAuth(sid:UserID, key:String):Bool {
        // auth_key = md5(api_id + '_' + viewer_id + '_' + api_secret)
        #if nodejs
        return js.node.Crypto.createHash(js.node.Crypto.CryptoAlgorithm.MD5).update(appID + "_" + sid + "_" + secretKey).digest("hex") == key;
        #else
        throw new js.lib.Error("Метод не реализован");
        #end
    }

    @:keep
    @:noCompletion
    public function toString():String {
        return "[VKontakteServer]";
    }
}