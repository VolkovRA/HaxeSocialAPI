package social.utils;

/**
 * Временная метка. *(mc)*  
 * Это дата в формате [Unix Timestamp](https://en.wikipedia.org/wiki/Unix_time "Unix time"),
 * которая записана в миллисекундах.  
 * Она обозначает время, прошедшее с 1 января 1970 года. (UTC)
 * 
 * @see Конвертер timestamp: https://www.unixtimestamp.com/
 * @see Получение временной метки: `social.utils.NativeJS.stamp()`
 */
typedef Timestamp = Float;