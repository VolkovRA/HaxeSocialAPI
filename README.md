# API Интерфейс cоциальных сетей

Описание
------------------------------

Интерфейс и его реализация для различных API социальных сетей на Haxe.
Дополняется по мере личной необходимости.

Пример использования
------------------------------
```
package;

import social.ISocialNetwork;
import social.InitConfig;
import social.SocialError;
import social.vk.VKontakte;

class Main 
{
	private static var social:ISocialNetwork;
	
	static function main() {
		var opt:InitConfig = {};
		
		social = new VKontakte();
		social.init(opt, onInit)
	}
	
	static function onInit(err:SocialError):Void {
		if (err != null)
			trace(err);
		
		trace(social.version);
	}
}
```
