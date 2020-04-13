package social;

/**
 * API Интерфейс соц. сети.
 * Суть этого интерфейса в том, что-бы инкапсулировать и абстрагировать параметры и методы различных
 * соц. сетей, на сколько это возможно. Это позволяет упростить работу и интеграцию с их апи.
 * 
 * <b>Флаг компиляции</b>
 * Обратите внимание, что для использования библиотеки в NodeJS, вы должны передать флаг компилятору:
 * <code>-D node</code>
 * Это флаг используется для определения запуска библиотеки в Браузере/NodeJS.
 * @author VolkovRA
 */
interface ISocialNetwork 
{
	//////////////////
	//   СВОЙСТВА   //
	//////////////////
	
	/**
	 * Версия библиотеки.
	 * Семантическое версианирование в формате: <i>major.minor.path</i>
	 * Пример: 1.2.3
	 * Не может быть null.
	 */
	var version(default, null):String;
	
	/**
	 * Тип социальной сети.
	 * Не может быть null.
	 */
	var type(default, null):SocialNetworkType;
	
	/**
	 * Название социальной сети.
	 * Не может быть null.
	 */
	var title(default, null):String;
	
	/**
	 * Статус инициализации.
	 * Равен true, если этот интерфейс API был проинициализирован.
	 */
	var isInit(default, null):Bool;
	
	/**
	 * ID Приложения.
	 * Это уникальный идентификатор данного приложения в социальной сети.
	 * По умолчанию: null.
	 */
	var appID:String;
	
	/**
	 * Секретный ключ приложения.
	 * Может быть необходим для проверки авторизации.
	 * Этот ключ выдаётся приложению социальной сетью и используется приложением на серверной стороне.
	 * По умолчанию: null.
	 */
	var secretKey:String;
	
	/**
	 * Сервисный ключ доступа.
	 * Некоторые методы API социальной сети могут требовать этот ключ.
	 * Этот ключ выдаётся приложению социальной сетью и используется на серверной стороне.
	 * По умолчанию: null.
	 */
	var serviceKey:String;
	
	
	
	////////////////
	//   МЕТОДЫ   //
	////////////////
	
	/**
	 * Инициализировать интерфейс.
	 * Для некоторых методов может быть необходима предварительная инициализация интерфейса.
	 * @param	options Параметры инициализации.
	 * @param	callback Калбек завершения.
	 */
	function init(options:InitConfig, callback:SocialError->Void):Void;
}