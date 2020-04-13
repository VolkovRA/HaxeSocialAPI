package social.vk;

import social.ISocialNetwork;
import social.InitConfig;
import social.SocialError;
import social.SocialNetworkType;

#if node
import js.node.Crypto;			
#end

/**
 * Реализация ВКонтакте API.
 * @author VolkovRA
 */
class VKontakte implements ISocialNetwork 
{
	/// Создать объект.
	public function new() {
	}
	
	
	
	////////////////////
	//   КОМПОЗИЦИЯ   //
	////////////////////
	
	/**
	 * Парсер данных VK.
	 * Не может быть null.
	 */
	public var parser(default, null):Parser = new Parser();
	
	
	
	//////////////////
	//   СВОЙСТВА   //
	//////////////////
	
	/**
	 * Версия библиотеки VK.
	 * Семантическое версианирование в формате: <i>major.minor.path</i>
	 * Пример: 1.2.3
	 */
	public var version(default, null):String = "0.0.2";
	
	/**
	 * Название социальной сети.
	 * По умолчанию: ВКонтакте
	 */
	public var title(default, null):String = "ВКонтакте";
	
	/**
	 * Тип социальной сети.
	 * По умолчанию: SocialNetworkType.VK
	 */
	public var type(default, null):SocialNetworkType = SocialNetworkType.VK;
	
	/**
	 * Статус инициализации.
	 * Равен true, если этот интерфейс API был проинициализирован.
	 */
	public var isInit(default, null):Bool = false;
	
	/**
	 * ID Приложения.
	 * Уникальный идентификатор приложения в VK.
	 * По умолчанию: null.
	 */
	public var appID:String = null;
	
	/**
	 * Секретный ключ.
	 * Этот ключ выдаётся приложению социальной сетью ВКонтакте и используется приложением на серверной стороне.
	 * Необходим для проверки авторизации.
	 * По умолчанию: null.
	 */
	public var secretKey:String = null;
	
	/**
	 * Сервисный ключ доступа.
	 * Некоторые методы API ВКонтакте сети могут требовать этот ключ.
	 * Документация: https://vk.com/dev/service_token
	 * По умолчанию: null.
	 */
	public var serviceKey:String;
	
	
	
	////////////////
	//   МЕТОДЫ   //
	////////////////
	
	/**
	 * Инициализировать интерфейс.
	 * Для некоторых методов может быть необходима предварительная инициализация интерфейса.
	 * @param	options Параметры инициализации.
	 * @param	callback Калбек завершения.
	 */
	public function init(options:InitConfig, callback:SocialError->Void):Void {
		if (isInit) {
			if (callback != null)
				callback(new SocialError("Интерфейс уже инициализирован"));
			
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
	 * Метод возвращает true, если переданный пользователь и его ключ успешно проходят проверку на авторизацию.
	 * Требования:
	 *   1. Указанный <b>appID</b>.
	 *   2. Указанный <b>secret</b>.
	 *   3. Указанный флаг компиляции <b>node</b>.
	 * 
	 * Документация: https://vk.com/dev/apps_init?f=3.%20auth_key
	 * @param	sid ID Пользователя в соц. сети.
	 * @param	key Ключ, которым представился пользователь.
	 * @return	Возвращает true, если пользователь тот, кем представился, false в любом ином случае, включая ошибки.
	 */
	public function checkAuthKey(sid:SID, key:String):Bool {
		// auth_key = md5(api_id + '_' + viewer_id + '_' + api_secret)
		#if node
		return Crypto.createHash(CryptoAlgorithm.MD5).update(appID + "_" + sid + "_" + secretKey).digest("hex") == key;
		#else
		return false;
		#end
	}
}