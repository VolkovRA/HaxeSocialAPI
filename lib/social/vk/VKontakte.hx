package social.vk;

import social.ISocialNetwork;
import social.SocialError;
import social.SocialNetworkType;
#if nodejs
import js.node.Crypto;			
#end

/**
 * Реализация интерфейса для **ВКонтакте**.
 */
class VKontakte implements ISocialNetwork 
{
    /**
     * Создать объект.
     */
    public function new() {
    }



    ////////////////////
    //   КОМПОЗИЦИЯ   //
    ////////////////////

    /**
     * Парсер данных VK.
     */
    public var parser(default, null):Parser = new Parser();



    //////////////////
    //   СВОЙСТВА   //
    //////////////////

    public var version(default, null):String = "0.0.2";
    public var title(default, null):String = "ВКонтакте";
    public var type(default, null):SocialNetworkType = SocialNetworkType.VK;
    public var isInit(default, null):Bool = false;
    public var appID:String = null;
    public var secretKey:String = null;
    public var serviceKey:String = null;



    ////////////////
    //   МЕТОДЫ   //
    ////////////////

    public function init(options:InitParams, callback:SocialError->Void):Void {
        if (isInit) {
            if (callback != null)
                callback(new SocialError("Интерфейс уже был инициализирован"));

            return;
        }

        isInit = true;

        if (callback != null)
            callback(null);
    }



    ////////////////
    //   СЕРВЕР   //
    ////////////////

    /**
     * Проверка авторизации пользователя.
     * - Метод возвращает `true`, если переданный пользователь и его ключ
     *   успешно проходят проверку на авторизацию.
     * - Метод генерирует исключение `SocialError`, если вызывается не в
     *   серверном режиме `NodeJS`.
     * 
     * Требования:
     *   1. Указанный `appID`.
     *   2. Указанный `secret`.
     *   3. Приложение запущено в серверном режиме `NodeJS`.
     * 
     * @param sid ID Пользователя в соц. сети.
     * @param key Ключ, которым представился пользователь.
     * @return Возвращает `true`, если пользователь тот, кем представился.
     * @see Документация: https://vk.com/dev/apps_init?f=3.%20auth_key
     */
    public function checkAuthKey(sid:SID, key:String):Bool {
        // auth_key = md5(api_id + '_' + viewer_id + '_' + api_secret)
        #if nodejs
        return Crypto.createHash(CryptoAlgorithm.MD5).update(appID + "_" + sid + "_" + secretKey).digest("hex") == key;
        #else
        throw new SocialError("Метод доступен только в серверном режиме использования");
        #end
    }
}