package social;

import js.lib.Error;

/**
 * Ошибка интерфейса соц. сети.
 * @author VolkovRA
 */
class SocialError extends Error
{
	/**
	 * Создать ошибку интерфейса соц. сети.
	 * @param	message Сообщение.
	 */
	public function new(?message:String) {
		super(message);
	}
}