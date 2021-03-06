package social.task;

import js.lib.Error;
import social.network.INetwork;

/**
 * Задача по обращению к API социальной сети.  
 * Используется для асинхронных, сложносоставных запросов.
 * Некоторые запросы могут выполняться в несколько этапов.
 * Этот объект инкапсулирует их сложность, содержит
 * реализацию и хранит промежуточные данные.
 * 
 * Абстрактный, базовый интерфейс для всех задач.
 */
@:dce
interface ITask<T:ITask<T>> 
{
    /**
     * API Интерфейс, к которому относится данная задача.  
     * Может использоваться некоторыми типами задач для
     * получения дополнительных сведений.
     * 
     * Не может быть `null`
     */
    public var network(default, null):INetwork;

    /**
     * Ошибка выполнения.  
     * Свойство будет содержать ошибку, если в ходе выполнения
     * данной задачи возникли какие-то проблемы.
     * 
     * По умолчанию: `null`
     */
    public var error:Error;

    /**
     * Колбек завершения.  
     * Если назначен, этот обработчик будет вызван после завершения
     * выполнения данной задачи.
     * 
     * По умолчанию: `null`
     */
    public var onComplete:T->Void;

    /**
     * Произвольные, пользовательские данные.  
     * Полезно для хранения ваших произвольных данных между запросами.  
     * Библиотека никак не управляет содержимым этого свойства.
     * 
     * По умолчанию: `null`
     */
    public var userData:Dynamic;

    /**
     * Запустить выполнение задачи.  
     * Вызывается автоматически, инициирует выполнение.
     * 
     * Может быть вызван только один раз.
     */
    public function start():Void;

    /**
     * Отмена выполнения.  
     * Вызов этого метода прекратит выполнение данной задачи.
     * - Колбеки не вызываются.
     * - Повторный вызов игнорируется.
     * - Вызов над уже завершившейся задачей игнорируется.
     * 
     * Полезно для отмены задачи, если вы передумали.
     */
    public function cancel():Void;

    /**
     * Получить текстовое представление объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String;
}