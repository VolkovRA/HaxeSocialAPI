package social;

/**
 * Тип соц. сети.
 * @author VolkovRA
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