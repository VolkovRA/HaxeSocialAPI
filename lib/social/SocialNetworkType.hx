package social;

/**
 * Тип социальной сети.
 * Перечисление всех доступных типов соц. сетей в рамках библиотеки.
 */
@:enum abstract SocialNetworkType(String) to String
{
    /**
     * ВКонтакте.
     */
    var VK = "VK";

    /**
     * Одноклассники.
     */
    var OK = "OK";

    /**
     * Фейсбук.
     */
    var FB = "FB";
}