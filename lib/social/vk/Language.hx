package social.vk;

/**
 * Идентификатор языка.
 * @see Документация: https://vk.com/dev/apps_init?f=4.%20language
 */
@:enum abstract Language(Int) to Int
{
    /**
     * Русский язык.
     */
    var RU = 0;

    /**
     * Украинский язык.
     */
    var UK = 1;

    /**
     * Белорусский язык.
     */
    var BE = 2;

    /**
     * Английский язык.
     */
    var EN = 3;
}