package social.utils;

/**
 * Вспомогательные утилиты.  
 * Статический класс.
 */
@:dce
class Tools
{
    /**
     * Получить текстовое сообщение с подстановкой данных.  
     * Этот метод возвращает новую строку, в которой все вставки вида:
     * `{0}`, `{1}`, `{2}` и т.д. будут заменены на соответствующие
     * значения из переданного массива `data`.
     * - Если переданная строка равна `null`, возращается `null`.
     * - Если переданный массив равен `null`, строка возвращается "как есть".
     * - Если строка содержит вставки, выходящие за пределы переданного
     *   массива, они возвращаются "как есть".
     * 
     * Пример:
     * ```
     * trace(Text.data("Привет {0}, как дела?", ["Боб", "Галя"]));    // Привет Боб, как дела?
     * trace(Text.data("Привет {0}, {1}, как дела?", ["Боб", 10])); // Привет Боб, 10, как дела?
     * ```
     * 
     * @param str Исходная строка.
     * @param data Вставляемые данные.
     * @return Новая строка с вставленными данными.
     */
    static public function msg(str:String, data:Array<Dynamic>):String {
        if (str == null)
            return null;
        if (data == null)
            return str;

        var i = data.length;
        while (i-- != 0) {
            var v = NativeJS.str(data[i]);
            var len1 = v.length;
            var ind = 0;
            var ptr = "{" + i + "}";
            var len2 = ptr.length;
            while (true) {
                ind = str.indexOf(ptr, ind);
                if (ind == -1)
                    break;
                str = str.substring(0, ind) + v + str.substring(ind + len2);
                ind += len1;
            }
        }
        return str;
    }

    /**
     * Получить параметры запроса из URL.  
     * Возвращает объект с переданными данными из указанного URL.
     * @param url URL Строка запроса с параметрами, которые нужно извлечь.
     * @return Объект с параметрами запроса. Не может быть `null`.
     */
    static public function query(url:String):Dynamic {
        if (url == null)
            return {};

        var index = url.indexOf("?");
        if (index > -1)
            url = url.substring(index + 1);

        var arr = url.split("&");
        var len = arr.length;
        var map:Dynamic = {};
        while (len-- != 0) {
            index = arr[len].indexOf("=");
            if (index == -1)
                untyped map[NativeJS.decodeURI(arr[len])] = null;
            else
                untyped map[NativeJS.decodeURI(arr[len].substring(0, index))] = NativeJS.decodeURI(arr[len].substring(index + 1));
        }
        return map;
    }

    /**
     * Получить текстовое представление ошибки.  
     * Возвращает указанную ошибку в виде текста.
     * @param error Ошибка.
     * @return Текстовое описание ошибки.
     */
    static public function err(error:Dynamic):String {
        if (error == null)
            return null;
        if (error.message == null)
            return NativeJS.str(error);

        return error.message;
    }
}