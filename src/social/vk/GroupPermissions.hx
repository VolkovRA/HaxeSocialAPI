package social.vk;

/**
 * Маска прав доступа к данным сообщества.
 * Права доступа определяют возможность использования токена для работы с тем или иным разделом данных.
 * Документация: <i>https://vk.com/dev/permissions?f=2.%20%D0%9F%D1%80%D0%B0%D0%B2%D0%B0%20%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0%20%D0%B4%D0%BB%D1%8F%20%D1%82%D0%BE%D0%BA%D0%B5%D0%BD%D0%B0%20%D1%81%D0%BE%D0%BE%D0%B1%D1%89%D0%B5%D1%81%D1%82%D0%B2%D0%B0</i>
 * @author VolkovRA
 */
typedef GroupPermissions = Int;

/**
 * Флаг права доступа к данным сообщества.
 * @author VolkovRA
 */
@:enum abstract GroupPermission(Int) to Int
{
	/**
	 * Доступ к историям.
	 */
	var STORIES		= 1;
	
	/**
	 * Доступ к фотографиям.
	 */
	var PHOTOS		= 4;
	
	/**
	 * Доступ к виджетам приложений сообществ.
	 * Это право можно запросить только с помощью метода Client API showGroupSettingsBox.
	 */
	var APP_WIDGET	= 64;
	
	/**
	 * Доступ к сообщениям сообщества.
	 */
	var MESSAGES	= 4096;
	
	/**
	 * Доступ к документам.
	 */
	var DOCS		= 131072;
	
	/**
	 * Доступ к администрированию сообщества.
	 */
	var MANAGE		= 262144;
}