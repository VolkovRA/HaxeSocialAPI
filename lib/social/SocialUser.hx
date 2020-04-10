package social;

/**
 * Пользователь соц. сети.
 * @author VolkovRA
 */
typedef SocialUser =
{
	/**
	 * ID Пользователя в соц. сети.
	 */
	@:optional var uid:SID;
	
	/**
	 * Имя.
	 */
	@:optional var firstName:String;
	
	/**
	 * Фамилия.
	 */
	@:optional var lastName:String;
	
	/**
	 * Гендернывй признак.
	 */
	@:optional var sex:Sex;
	
	/**
	 * URL Адрес страницы пользователя.
	 */
	@:optional var home:String;
	
	/**
	 * URL Адрес аватарки пользователя.
	 * Используется аватарка максимального, доступного разрешения.
	 */
	@:optional var avatar:String;
	
	/**
	 * Пользователь заблокирован.
	 */
	@:optional var deactivated:Bool;
	
	/**
	 * Пользователь удалён.
	 */
	@:optional var deleted:Bool;
}