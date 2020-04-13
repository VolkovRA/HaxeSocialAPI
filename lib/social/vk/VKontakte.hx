package social.vk;

import social.ISocialNetwork;
import social.InitConfig;
import social.SocialError;
import social.SocialNetworkType;

/**
 * Реализация ВКонтакте API.
 * @author VolkovRA
 */
class VKontakte implements ISocialNetwork 
{
	public var version(default, null):String			= "0.0.1";
	public var title(default, null):String				= "ВКонтакте";
	public var isInit(default, null):Bool				= false;
	public var type(default, null):SocialNetworkType	= SocialNetworkType.VK;
	
	/// Создать объект.
	public function new() {
	}
	
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
}