package social.vk;

/**
 * Тип пользователя, который просматривает приложение.
 * В зависимости от источника запуска, значение может иметь разный смысл. 
 * По сути, это разные сущности, но их зачем-то объединили в одну. (Привет от говнокодеров из прошлого ВК)
 * 
 * Источники запуска могут быть:
 *   1. Если приложение запущено со страницы сообщества: group_id != 0.
 *   2. Если приложение запущено со страницы пользователя: user_id != 0.
 * 
 * Документация: <i>https://vk.com/dev/apps_init?f=2.%20viewer_type</i>
 * @author VolkovRA
 */
@:enum abstract ViewerType(Int) to Int
{
	/**
	 * <b>Если пользователь не состоит в сообществе</b> для приложения, запущенного со страницы сообщества: <b>group_id != 0</b>.
	 * <b>Если пользователь не состоит в друзьях владельца страницы</b> для приложения, запущенного со страницы пользователя: <b>user_id != 0</b>.
	 */
	var VALUE_0	= 0;
	
	/**
	 * <b>Если пользователь является участником сообщества</b> для приложения, запущенного со страницы сообщества: <b>group_id != 0</b>.
	 * <b>Если пользователь является другом владельца страницы</b> для приложения, запущенного со страницы пользователя: <b>user_id != 0</b>.
	 */
	var VALUE_1	= 1;
	
	/**
	 * <b>Если пользователь является модератором сообщества</b> для приложения, запущенного со страницы сообщества: <b>group_id != 0</b>.
	 * <b>Если пользователь является владельцем страницы</b> для приложения, запущенного со страницы пользователя: <b>user_id != 0</b>.
	 */
	var VALUE_2	= 2;
	
	/**
	 * <b>Если пользователь является редактором сообщества</b> для приложения, запущенного со страницы сообщества: <b>group_id != 0</b>.
	 */
	var VALUE_3	= 3;
	
	/**
	 * <b>Если пользователь является создателем или администратором сообщества</b> для приложения, запущенного со страницы сообщества: <b>group_id != 0</b>.
	 */
	var VALUE_4	= 4;
}