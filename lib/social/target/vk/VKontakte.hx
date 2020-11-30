package social.target.vk;

import loader.Balancer;
import social.network.Support;
import social.network.INetwork;

/**
 * Базовый, абстрактный класс для реализации интерфейса ВКонтакте.  
 * Используется для определения основных параметров. Скорее всего
 * вы захотите использовать не этот класс, а один из его потомков.
 */
@:dce
@:noCompletion
class VKontakte implements INetwork
{
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
    public var requestRepeatTry             = 2;
    public var support(default, null):Support = {
        invite: {
            enabled: true,
            users: false,
            message: false,
            result: false,
        },
        post: { enabled: true },
        setLevel: { enabled: true },
        setScores: { enabled: true },
        getUsersMax: 1000,
    };

    @:keep
    @:noCompletion
    public function toString():String {
        return "[VKontakte]";
    }
}