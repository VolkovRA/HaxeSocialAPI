package;

import social.ISocialNetwork;
import social.InitConfig;
import social.SocialError;
import social.vk.VKontakte;

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
	}
	
	static function onInit(err:SocialError):Void {
		if (err != null)
			trace(err);
		
		trace(social.version);
	}
}