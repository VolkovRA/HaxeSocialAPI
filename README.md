# Haxe API интерфейс для cоциальных сетей

![](https://github.com/VolkovRA/HaxeSocialAPI/blob/master/logo.png?raw=true)

Зачем это надо
------------------------------

Упростить работу с разношёрстными API социальных сетей, приведя их к единому, общему виду, по мере возможностей.  

Описание
------------------------------

Это Haxe библиотека содержит общий программный интерфейс для работы с любой социальной сетью. Она абстрагирует их самые часто используемые функций и данные в одном виде. Данная библиотека включает реализацию для работы с:
- [ВКонтакте](https://vk.com/)
- [Одноклассники](https://ok.ru/)
- [Facebook](https://www.facebook.com/)

Эта библиотека содержит отдельные классы для работы как на клиенте в браузере, так и на сервере в NodeJS. Пакет `social.target` содержит отдельные реализаций интерфейса под каждую конкретную соц. сеть.
Список реализаций поддерживаемых сетей может дополняться по мере необходимости.

Пример использования
------------------------------

Смотрите файл [Main](https://github.com/VolkovRA/HaxeSocialAPI/blob/develop/src/Main.hx).


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