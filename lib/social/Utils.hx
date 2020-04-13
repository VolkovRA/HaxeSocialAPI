package social;

import js.Syntax;

/**
 * Вспомогательные утилиты.
 * Статический класс для всех интерейсов, содержащий общие функций и утилиты.
 * @author VolkovRA
 */
class Utils 
{
	/**
	 * Декодировать унифицированный идентификатор ресурса (URI), созданный при помощи метода encodeURI или другой подобной процедуры.
	 * Документация: <i>https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/decodeURI</i>
	 * @param	uri Полный закодированный унифицированный идентификатор ресурса.
	 * @return	Новая строка, представляющая собой незакодированную версию данного унифицированного идентификатора ресурса.
	 */
	static public inline function decodeURI(uri:String):String {
		return Syntax.code("decodeURI({0})", uri);
	}
	
	/**
	 * Кодировать универсальный идентификатор ресурса (URI).
	 * Замещает некоторые символы на одну, две, три или четыре управляющие последовательности, представляющие UTF-8 кодировку
	 * символа (четыре управляющие последовательности будут использованы только для символов, состоящих из двух «суррогатных» символов).
	 * Документация: <i>https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/encodeURI</i>
	 * @param	uri Полный URI.
	 * @return	Новая строка, представляющая собой строку-параметр, закодированную в виде универсального идентификатора ресурса (URI).
	 */
	static public inline function encodeURI(uri:String):String {
		return Syntax.code("encodeURI({0})", uri);
	}
	
	/**
	 * Нативная реализация parseInt().
	 * Функция parseInt() принимает строку в качестве аргумента и возвращает целое число в соответствии с указанным основанием системы счисления.
	 * Документация: <i>https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt</i>
	 * @param	str Число в строковом виде.
	 * @return	Возвращает целое число или NaN, если преобразование не удалось.
	 */
	static public inline function parseInt(str:String):Int {
		return Syntax.code("parseInt({0})", str);
	}
}