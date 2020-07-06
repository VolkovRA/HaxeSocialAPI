package social.task;

import social.ISocialNetwork;
import js.lib.Error;

/**
 * Задача по обращению к API социальной сети.
 * 
 * Интерфейс инкапсулирует в себе общие характеристики для
 * всех задач всех социальных сетей. Конкретная задача
 * имеет собственный интерфейс, унаследованный от этого.
 * 
 * Задача используется для хранения промежуточных данных и
 * для управления процессом запроса/ов к социальной сети,
 * которые могут состоять из нескольких этапов и циклов.
 */
interface ITask<T:ITask<T>> 
{
    /**
     * API Интерфейс, к которому относится данная задача.
     * 
     * Может использоваться некоторыми типами задач для
     * получения дополнительных, необходимых сведений.
     * 
     * По умолчанию: `null`
     */
    public var network(default, null):ISocialNetwork;

    /**
     * Сбой выполнения.
     * 
     * Свойство будет содержать ошибку, если в ходе выполнения
     * данной задачи возникли какие-то проблемы.
     * 
     * По умолчанию: `null`
     */
    public var error:Error;

    /**
     * Колбек завершения задачи.
     * 
     * Если назначен, этот обработчик будет вызван после завершения
     * выполнения данной задачи.
     * 
     * По умолчанию: `null`
     */
    public var onComplete:T->Void;

    /**
     * Произвольные, пользовательские данные.
     * 
     * Используется для хранения любых, пользовательских данных.
     * Никак не влияет на выполняемую задачу и не трогается ею.
     * 
     * По умолчанию: `null`
     */
    public var userData:Dynamic;

    /**
     * Запустить выполнение задачи.
     * 
     * Вызывается автоматически, если вы используйете интерфейс `ISocialNetwork`.
     * Инициирует выполнение задачи. Может быть вызван только один раз.
     */
    public function start():Void;

    /**
     * Отмена выполнения.
     * 
     * Вызов прекращает выполнение данной задачи, колбеки не
     * вызываются. Повторный вызов, или вызов над завершивейшся
     * задачей - игнорируется.
     * 
     * Устанавливает свойство `isComplete` в `true`.
     */
    public function cancel():Void;

    /**
     * Получить текстовое представление задачи.
     * @return Возвращает текстовое представление объекта.
     */
    @:keep
    public function toString():String;
}