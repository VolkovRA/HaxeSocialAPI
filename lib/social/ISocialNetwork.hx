package social;

/**
 * API Интерфейс соц. сети.
 * @author VolkovRA
 */
interface ISocialNetwork 
{
	/**
	 * Версия библиотеки.
	 * Семантическое версианирование в формате: major.minor.path
	 * Пример: <i>1.2.3</i>
	 * Не может быть null.
	 */
	var version(default, null):String;
	
	/**
	 * Тип соц. сети.
	 * Не может быть null.
	 */
	var type(default, null):SocialNetworkType;
	
	/**
	 * Статус инициализации.
	 * Равен true, если этот интерфейс API был проинициализирован.
	 */
	var isInit(default, null):Bool;
	
	/**
	 * Инициализировать интерфейс соц. сеть.
	 * @param	options Параметры инициализации.
	 * @param	callback Калбек завершения.
	 */
	function init(options:InitConfig, callback:SocialError->Void):Void;
}