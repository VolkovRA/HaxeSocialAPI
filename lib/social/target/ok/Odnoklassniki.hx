package social.target.ok;

import haxe.ds.IntMap;
import loader.Balancer;
import social.network.INetwork;
import social.target.ok.enums.ErrorCode;
import social.utils.Capabilities;

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
        apiFatalErrors.set(ErrorCode.IP_BLOCKED, true);
        apiFatalErrors.set(ErrorCode.PARAM, true);
        apiFatalErrors.set(ErrorCode.PARAM_API_KEY, true);
        apiFatalErrors.set(ErrorCode.PARAM_SESSION_KEY, true);
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
    public var apiFatalErrors               = new IntMap();
    public var appID:String                 = null;
    public var repeats                      = 2;
    public var capabilities(default, null):Capabilities = {
        invite: {
            enabled: true,
            users: true,
            message: true,
            result: true,
            resultUsers: true,
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
            enabled: false,
        },
        setScores: {
            enabled: false,
        },
        getUsersMax: 1000,
    };

    /**
     * Публичный ключ приложения в Одноклассниках.  
     * По сути, это второй ID. Используется для запросов к API.
     * Может быть получен из iframe параметров или указан вручную.
     * 
     * По умолчанию: `null`
     */
    public var applicationKey:String = null;

    @:keep
    @:noCompletion
    public function toString():String {
        return "[Odnoklassniki]";
    }
}