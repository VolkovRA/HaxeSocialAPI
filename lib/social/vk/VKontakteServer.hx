package social.vk;

import haxe.DynamicAccess;
import loader.Balancer;
import social.ISocialNetworkServer;
import social.SocialNetworkType;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.vk.task.GetUsersTask;
import social.vk.task.GetFriendsTask;

/**
 * Реализация интерфейса VK для серверного приложения. (NodeJS)
 * 
 * @see Документация VK: https://vk.com/dev/manuals
 */
class VKontakteServer implements ISocialNetworkServer
{
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
    public var appID:String                             = null;
    public var requestRepeatTry:Int                     = 3;
    public var secretKey:String                         = null;
    public var serviceKey:String                        = null;
    public var consts(default, null):Constants = {
        getUsersMax: 1000
    };

    public function getUsers(   users:Array<SocialUser>,
                                fields:SocialUserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<SocialUser>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.users              = users;
        task.token              = serviceKey;
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
        task.token              = serviceKey;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.requestRepeatTry   = requestRepeatTry;
        task.start();
        return task;
    }

    public function userCheckAuth(sid:SID, key:String):Bool {
        // auth_key = md5(api_id + '_' + viewer_id + '_' + api_secret)
        #if nodejs
        return js.node.Crypto.createHash(js.node.Crypto.CryptoAlgorithm.MD5).update(appID + "_" + sid + "_" + secretKey).digest("hex") == key;
        #else
        throw new js.lib.Error("Method not implemented");
        #end
    }

    @:keep
    public function toString():String {
        return "[VKontakteServer]";
    }
}