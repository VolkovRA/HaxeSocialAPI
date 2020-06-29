package social;

import js.lib.Error;

/**
 * Ошибка интерфейса социальной сети.
 */
class SocialError extends Error
{
    /**
     * Создать ошибку.
     * @param message Сообщение.
     */
    public function new(?message:String) {
        super(message);
    }
}