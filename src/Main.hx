package;

import social.ISocialNetwork;
import social.InitConfig;
import social.SocialError;
import social.vk.VKontakte;
import social.SocialNetworkType;

/**
 * Example for use.
 * @author VolkovRA
 */
class Main 
{
	private static var social:ISocialNetwork;
	
	static function main() {
		var opt:InitConfig = {};
		
		social = new VKontakte();
		social.init(opt, onInit);
		
		switch (social.type) {
			case SocialNetworkType.VK:
				trace("VK");
			case SocialNetworkType.OK:
				trace("OK");
			default:
				trace("other");
		}
	}
	
	static function onInit(err:SocialError):Void {
		if (err != null)
			trace(err);
		
		trace(social.version);
	}
}