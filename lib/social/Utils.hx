package social;

import js.Syntax;

/**
 * Вспомогательные утилиты.
 */
class Utils 
{
    /**
     * Декодировать унифицированный идентификатор ресурса (URI), созданный при
     * помощи метода `encodeURI()` или другой подобной процедуры.
     * 
     * @param uri Полный закодированный унифицированный идентификатор ресурса.
     * @return Новая строка, представляющая собой незакодированную версию данного
     *         унифицированного идентификатора ресурса.
     * @see Документация: https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/decodeURI
     */
    static public inline function decodeURI(uri:String):String {
        return Syntax.code("decodeURI({0})", uri);
    }

    /**
     * Кодировать универсальный идентификатор ресурса (URI).
     * 
     * Замещает некоторые символы на одну, две, три или четыре управляющие
     * последовательности, представляющие UTF-8 кодировку символа (четыре
     * управляющие последовательности будут использованы только для символов,
     * состоящих из двух "суррогатных" символов).
     * 
     * @param uri Полный URI.
     * @return Новая строка, представляющая собой строку-параметр, закодированную
     *         в виде универсального идентификатора ресурса (URI).
     * @see Документация: https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/encodeURI
     */
    static public inline function encodeURI(uri:String):String {
        return Syntax.code("encodeURI({0})", uri);
    }

    /**
     * Нативная js реализация `parseInt()`.
     * 
     * Функция принимает строку в качестве аргумента и возвращает целое число
     * в соответствии с указанным основанием системы счисления.
     * 
     * @param str Число в строковом виде.
     * @return Возвращает целое число или `NaN`, если преобразование не удалось.
     * @see Документация: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt
     */
    static public inline function parseInt(str:String):Int {
        return Syntax.code("parseInt({0})", str);
    }
}