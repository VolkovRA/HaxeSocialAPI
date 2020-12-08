package social.utils;

import js.Syntax;

/**
 * Нативный JavaScript.  
 * Используется для прямых вызовов JS, чтобы упростить реализацию и сделать
 * её более эффективной, чем стандартные Haxe обёртки. Или чтобы просто добавить
 * некоторый функционал JS, которого нет в Haxe.
 * 
 * Статический класс.
 */
@:dce
class NativeJS 
{
    /**
     * Проверить строгое равенство.  
     * Выполняет строгое равенство `===` и возвращает его результат.
     * @param v1 Значение 1.
     * @param v2 Значение 2.
     * @return Результат строгово сравнения.
     */
    static public inline function eq(v1:Dynamic, v2:Dynamic):Bool {
        return Syntax.code("({0} === {1})", v1, v2);
    }

    /**
     * Декодировать унифицированный идентификатор ресурса (URI), созданный при
     * помощи метода `encodeURI()` или другой подобной процедуры.  
     * @param uri Полный закодированный унифицированный идентификатор ресурса.
     * @return Новая строка, представляющая собой незакодированную версию данного
     *         унифицированного идентификатора ресурса.
     * @see Документация: https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/decodeURI
     */
    static public inline function decodeURI(uri:String):String {
        return Syntax.code("decodeURI({0})", uri);
    }

    /**
     * Кодировать универсальный идентификатор ресурса URI.  
     * 
     * Замещает некоторые символы на одну, две, три или четыре управляющие
     * последовательности, представляющие UTF-8 кодировку символа (четыре
     * управляющие последовательности будут использованы только для символов,
     * состоящих из двух "суррогатных" символов).
     * 
     * @param uri Полный URI.
     * 
     * @return Новая строка, представляющая собой строку-параметр, закодированную
     *         в виде универсального идентификатора ресурса (URI).
     * 
     * @see Документация: https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/encodeURI
     */
    static public inline function encodeURI(uri:String):String {
        return Syntax.code("encodeURI({0})", uri);
    }

    /**
     * Парсить строку в целое число.  
     * Функция принимает строку в качестве аргумента и возвращает целое число
     * в соответствии с указанным основанием системы счисления.
     * 
     * @param string Значение, которое необходимо проинтерпретировать.
     *               Если значение параметра `string` не принадлежит строковому
     *               типу, оно преобразуется в него (с помощью абстрактной операции `ToString`).
     *               Пробелы в начале строки не учитываются.
     * 
     * @param radix Целое число в диапазоне между `2` и `36`, представляющее собой
     *              основание системы счисления числовой строки `string`, описанной
     *              выше. В основном пользователи используют десятичную систему
     *              счисления и указывают `10`. Всегда указывайте этот параметр,
     *              чтобы исключить ошибки считывания и гарантировать корректность
     *              исполнения и предсказуемость результата. Когда основание системы
     *              счисления не указано, разные реализации могут возвращать разные
     *              результаты.
     * 
     * @return Целое число, полученное парсингом (разбором и интерпретацией)
     *         переданной строки. Если первый символ не получилось сконвертировать в
     *         число, то возвращается `NaN`.
     * 
     * @see Документация: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt
     */
    static public inline function parseInt(string:String, radix:Int = 10):Int {
        return Syntax.code("parseInt({0}, {1})", string, radix);
    }

    /**
     * Проверить наличие всех флагов в битовой маске.  
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
    public static inline function flagsAND(mask:Bitmask, flags:Bitmask):Bool {
        return Syntax.code('(({0} & {1}) === {1})', mask, flags);
    }

    /**
     * Проверить наличие одного или нескольких флагов в битовой маске.  
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
    public static inline function flagsOR(mask:Bitmask, flags:Bitmask):Bool {
        return Syntax.code('(({0} & {1}) > 0)', mask, flags);
    }

    /**
     * Проверка на массив.  
     * - Возвращается `true`, если переданный объект является JS экземпляром: `Array`
     * - Возвращает `false` во всех остальных случаях.
     * @param obj Проверяемый объект.
     * @return Результат проверки на массив.
     */
    public static inline function isArray(obj:Dynamic):Bool {
        return Syntax.code('({0} instanceof Array)', obj);
    }

    /**
     * Проверка на `undefined`. *(Нативный JS)*  
     * Производит сравнение: `value === undefined`
     * @param value Проверяемое значение.
     * @return Результат проверки.
     */
    inline static public function isUndefined(value:Dynamic):Bool {
        return Syntax.code('({0} === undefined)', value);
    }

    /**
     * Создать массив заданной длины.  
     * Полезно для разового выделения памяти нужной длины.
     * @param length Длина массива.
     * @return Новый массив указанной длины.
     */
    public static inline function createArray(length:Int):Dynamic {
        return Syntax.code('new Array({0})', length);
    }

    /**
     * Приведение к строке.  
     * Производит простое приведение указанного значения к строке:
     * ```
     * str + ""
     * ```
     * @param v Значение.
     * @return Строковое представление.
     */
    public static inline function str(v:Dynamic):String {
        return Syntax.code("({0} + '')", v);
    }

    /**
     * Получить метку текущей даты. (mc)  
     * Метод возвращает количество миллисекунд, прошедших с
     * 1 января 1970 года 00:00:00 по UTC по текущий момент
     * времени в качестве числа.
     * @return Временная метка.
     * @see `Date.now()`: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now
     */
    public static inline function stamp():Timestamp {
        return Syntax.code('Date.now()');
    }
}