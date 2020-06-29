# API Интерфейс cоциальных сетей

Описание
------------------------------

Единый интерфейс API для разных социальных сетей.
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

Подключение в Haxe
------------------------------

1. Установите haxelib, чтобы можно было использовать библиотеки Haxe.
2. Выполните в терминале команду, чтобы установить библиотеку social глобально себе на локальную машину:
```
haxelib git social https://github.com/VolkovRA/HaxeSocialAPI master
```
Синтаксис команды:
```
haxelib git [project-name] [git-clone-path] [branch]
haxelib git minject https://github.com/massiveinteractive/minject.git         # Use HTTP git path.
haxelib git minject git@github.com:massiveinteractive/minject.git             # Use SSH git path.
haxelib git minject git@github.com:massiveinteractive/minject.git v2          # Checkout branch or tag `v2`.
```
3. Добавьте в свой проект библиотеку social, чтобы использовать её в коде. Если вы используете HaxeDevelop, то просто добавьте в файл .hxproj запись:
```
<haxelib>
	<library name="social" />
</haxelib>
```

Смотрите дополнительную информацию:
 * [Документация Haxelib](https://lib.haxe.org/documentation/using-haxelib/ "Using Haxelib")
 * [Документация HaxeDevelop](https://haxedevelop.org/configure-haxe.html "Configure Haxe")