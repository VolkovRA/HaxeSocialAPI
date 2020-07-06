package social;

import js.Syntax;

/**
 * Вспомогательные утилиты.
 */
@:dce
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

    /**
     * Проверить наличие флагов в битовой маске.
     * - Возвращает `true`, если маска содержит все указанные флаги.
     * - Возвращает `false`, если маска не содержит хотя бы один из флагов.
     * - Возвращает `true`, если флаги не переданы. (`flags=0`)
     * 
     * Пример:
     * ```
     * var mask = 11; // 1011
     * var flag1 = 1; // 0001
     * var flag2 = 8; // 1000
     * var flag3 = 4; // 0100
     * trace(flagsAND(flag1));          // true
     * trace(flagsAND(flag2));          // true
     * trace(flagsAND(flag1 | flag2));  // true
     * trace(flagsAND(flag3));          // false
     * trace(flagsAND(flag3 | flag1));  // false
     * ```
     * @param mask Битовая маска.
     * @param flags Флаги.
     * @return Возвращает результат сравнения маски и флагов.
     */
    public static inline function flagsAND(mask:Int, flags:Int):Bool {
        return Syntax.code('(({0} & {1}) === {1})', mask, flags);
    }

    /**
     * Проверить наличие хотя бы одного флага в битовой маске.
     * - Возвращает `true`, если маска содержит хотя бы один из переданных флагов.
     * - Возвращает `false`, если маска не содержит ни одного флага.
     * - Возвращает `false`, если флаги не переданы. (`flags=0`)
     * 
     * Пример:
     * ```
     * var mask = 11; // 1011
     * var flag1 = 1; // 0001
     * var flag2 = 8; // 1000
     * var flag3 = 4; // 0100
     * trace(flagsOR(flag1));          // true
     * trace(flagsOR(flag2));          // true
     * trace(flagsOR(flag1 | flag2));  // true
     * trace(flagsOR(flag3));          // false
     * trace(flagsOR(flag3 | flag1));  // true
     * ```
     * @param mask Битовая маска.
     * @param flags Флаги.
     * @return Возвращает результат сравнения маски и флагов.
     */
    public static inline function flagsOR(mask:Int, flags:Int):Bool {
        return Syntax.code('(({0} & {1}) > 0)', mask, flags);
    }

    /**
     * Проверить, является ли объект массивом.
     * 
     * Возвращается `true`, если переданный объект является экземпляром `Array`.
     * Используется нативная JavaScript реализация: `instanceof()`
     * 
     * @param obj Объект.
     * @return Возвращает `true`, если объект является массивом.
     */
    public static inline function isArray(obj:Dynamic):Bool {
        return Syntax.code('({0} instanceof Array)', obj);
    }

    /**
     * Создать обычный JavaScript массив заданной длины.
     * 
     * По сути, является аналогом для использования конструктора: `new Vector(length)`.
     * Полезен для разового выделения памяти нужной длины.
     * 
     * @param length Длина массива.
     * @return Массив.
     */
    public static inline function createArray(length:Int):Dynamic {
        return Syntax.code('new Array({0})', length);
    }

    /**
     * Привести значение к `String`.
     * Быстрая, нативная реализация JavaScript.
     * @param v Значение.
     * @return Строковое представление.
     */
    public static inline function str(v:Dynamic):String {
        return Syntax.code("({0} + '')", v);
    }

    /**
     * Получить метку текущей даты. (mc)
     * 
     * Метод возвращает количество миллисекунд, прошедших
     * с 1 января 1970 года 00:00:00 по UTC по текущий момент
     * времени в качестве числа.
     * 
     * @return Временная метка.
     * @see `Date.now()`: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now
     */
    public static inline function stamp():Float {
        return Syntax.code('Date.now()');
    }
}