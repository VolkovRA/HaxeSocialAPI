package social;

import js.Error;

/**
 * Ошибка интерфейса соц. сети.
 * @author VolkovRA
 */
class SocialError extends js.Error
{
	/**
	 * Создать ошибку интерфейса соц. сети.
	 * @param	message Сообщение.
	 */
	public function new(?message:String) {
		super(message);
	}
}