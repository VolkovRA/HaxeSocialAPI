package social.target.ok;

import loader.Balancer;
import social.network.Support;
import social.network.INetwork;

/**
 * Базовый, абстрактный класс для реализации интерфейса Одноклассников.  
 * Используется для определения основных параметров. Скорее всего
 * вы захотите использовать не этот класс, а один из его потомков.
 */
@:dce
@:noCompletion
class Odnoklassniki implements INetwork
{
    public function new() {
    }



    ///////////////////
    //   ИНТЕРФЕЙС   //
    ///////////////////

    public var title(default, null)         = "Odnoklassniki";
    public var apiURL(default, null)        = "https://api.ok.ru/api/";
    public var apiVersion(default, null)    = null; // 01.12.2020
    public var type(default, null)          = NetworkType.OK;
    public var parser(default, null)        = new Parser();
    public var balancer(default, null)      = new Balancer(3);
    public var appID:String                 = null;
    public var requestRepeatTry             = 2;
    public var support(default, null):Support = {
        invite: {
            enabled: true,
            users: true,
            message: true,
            result: true,
        },
        post: { enabled: true },
        setLevel: { enabled: true },
        setScores: { enabled: true },
        getUsersMax: 1000,
    };

    @:keep
    @:noCompletion
    public function toString():String {
        return "[Odnoklassniki]";
    }
}