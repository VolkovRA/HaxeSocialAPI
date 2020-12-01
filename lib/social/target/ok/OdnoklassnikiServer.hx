package social.target.ok;

import haxe.DynamicAccess;
import social.network.INetworkServer;
import social.task.IGetUsersTask;
import social.task.IGetFriendsTask;
import social.task.ISetLevelTask;
import social.task.ISetScoresTask;
import social.user.User;
import social.user.UserField;

/**
 * Реализация интерфейса OK для серверного приложения. (NodeJS)
 * @see Документация: https://apiok.ru/
 */
@:dce
class OdnoklassnikiServer extends Odnoklassniki implements INetworkServer
{
    /**
     * Создать интерфейс OK.
     */
    public function new() {
        super();
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public var secretKey:String = null;
    public var serviceKey:String = null;

    public function getUsers(   users:Array<User>,
                                fields:UserFields = null,
                                onComplete:IGetUsersTask->Void = null,
                                onProgress:IGetUsersTask->DynamicAccess<User>->Void = null,
                                priority:Int = 0
    ):IGetUsersTask {
        /*
        var task:IGetUsersTask  = new GetUsersTask(this);
        task.token              = serviceKey;
        task.users              = users;
        task.fields             = fields == null ? task.fields : fields;
        task.onComplete         = onComplete;
        task.onProgress         = onProgress;
        task.priority           = priority;
        task.start();
        return task;
        */
        return null;
    }

    public function getFriends( user:UserID,
                                onComplete:IGetFriendsTask->Void = null,
                                priority:Int = 0
    ):IGetFriendsTask {
        /*
        var task:IGetFriendsTask = new GetFriendsTask(this);
        task.token              = serviceKey;
        task.user               = user;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.start();
        return task;
        */
        return null;
    }

    public function setLevel(   user:UserID,
                                level:Int,
                                onComplete:ISetLevelTask->Void = null,
                                priority:Int = 0
    ):ISetLevelTask {
        /*
        var task:ISetLevelTask  = new SetLevelTask(this);
        task.token              = serviceKey;
        task.user               = user;
        task.level              = level;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.start();
        return task;
        */
        return null;
    }

    public function setScores(  user:UserID,
                                scores:Int,
                                onComplete:ISetScoresTask->Void = null,
                                priority:Int = 0
    ):ISetScoresTask {
        /*
        var task:ISetScoresTask = new SetScoresTask(this);
        task.token              = serviceKey;
        task.user               = user;
        task.scores             = scores;
        task.onComplete         = onComplete;
        task.priority           = priority;
        task.start();
        return task;
        */
        return null;
    }

    public function userCheckAuth(sid:UserID, key:String):Bool {
        /*
        // auth_key = md5(api_id + '_' + viewer_id + '_' + api_secret)
        #if nodejs
        return js.node.Crypto.createHash(js.node.Crypto.CryptoAlgorithm.MD5).update(appID + "_" + sid + "_" + secretKey).digest("hex") == key;
        #else
        throw new js.lib.Error("Метод не реализован");
        #end
        */
        return null;
    }

    @:keep
    @:noCompletion
    override public function toString():String {
        return "[OdnoklassnikiServer]";
    }
}