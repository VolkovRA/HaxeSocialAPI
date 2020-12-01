package social.target.ok.objects;

import social.target.ok.enums.ErrorCode;
import social.target.ok.enums.ValueErrorCode;

/**
 * Формат ошибки Одноклассников.
 * @see Документация: https://apiok.ru/dev/errors
 */
typedef BaseError = 
{
    /**
     * Код ошибки.
     */
    var error_code:ErrorCode;

    /**
     * Человеко-читаемое описание. (Англ.)
     */
    var error_msg:String;

    /**
     * Код ошибки переданного значения.  
     * Объясняет почему не подошёл тот или иной переданный параметр.
     * 
     * Может быть `null`
     */
    @:optional var error_data:ValueErrorCode;

    /**
     * Имя некорректного параметра.  
     * Используется в связке с `error_data`
     * 
     * Может быть `null`
     */
    @:optional var error_field:String;
}