package social;

/**
 * Пол человека.
 * Перечисление всех возможных гендерных признаков.
 * @author VolkovRA
 */
@:enum abstract Sex(Int) to Int
{
	/**
	 * Не определён.
	 */
	var UNKNOWN	= 0;
	
	/**
	 * Мужчина.
	 */
	var MALE	= 1;
	
	/**
	 * Женщина.
	 */
	var FEMALE	= -1;
}