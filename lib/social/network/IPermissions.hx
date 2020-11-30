package social.network;

/**
 * Права доступа к данным пользователя.  
 * Унифицированный интерфейс для определения прав доступа
 * приложения в едином стиле и одном месте.
 */
@:dce
interface IPermissions
{
    /**
     * Доступ к списку друзей пользователя.
     */
    public var friends(get, never):Bool;

    /**
     * Получить текстовое представление объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String;
}