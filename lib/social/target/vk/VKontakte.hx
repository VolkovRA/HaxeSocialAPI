package social.target.vk;

import haxe.ds.IntMap;
import loader.Balancer;
import social.network.INetwork;
import social.utils.Capabilities;
import social.target.vk.enums.ErrorCode;

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
        apiFatalErrors.set(ErrorCode.PRIVATE_USER, true);
        apiFatalErrors.set(ErrorCode.USER_DEACTIVATED, true);
        apiFatalErrors.set(ErrorCode.USER_REMOVED, true);
        apiFatalErrors.set(ErrorCode.WRONG_VALUE, true);
        apiFatalErrors.set(ErrorCode.AUTHORISATION_FAILED, true);
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
    public var apiFatalErrors               = new IntMap();
    public var appID:String                 = null;
    public var repeats                      = 2;
    public var capabilities(default, null):Capabilities = {
        invite: {
            enabled: true,
            users: false,
            message: false,
            result: false,
            resultUsers: false,
        },
        post: {
            enabled: true,
            message: true,
            link: true,
            image: true,
            result: true,
            resultPostID: true,
        },
        setLevel: {
            enabled: true,
        },
        setScores: {
            enabled: true,
        },
        getUsersMax: 1000,
    };

    @:keep
    @:noCompletion
    public function toString():String {
        return "[VKontakte]";
    }
}