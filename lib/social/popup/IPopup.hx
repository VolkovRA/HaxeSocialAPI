package social.popup;

/**
 * Объект для вызова диалогового окна социальной сети.  
 * Предназначен для взаимодействия с пользователем при помощи
 * диалоговых окон социальной сети.
 * @see Менеджер всплывающих окон: `social.popup.PopupManager`
 */
@:dce
@:noCompletion
@:allow(social.popup.PopupManager)
interface IPopup
{
    /**
     * Индекс в очереди менеджера всплывающих окон.  
     * Используется для внутренней реализации, вы не должны
     * изменять это значение.
     * 
     * По умолчанию должен быть: `-1`
     */
    private var popupIndex:Int;

    /**
     * Показать диалоговое окно социальной сети.  
     * Этот вызов говорит объекту о том, что его очередь для работы
     * с UI настала. Он может вызвать диалоговое окно социальной сети.
     * 
     * **Обратите внимание**, что вы **должны** вызвать метод менеджера:
     * `PopupManager.remove()` после завершения работы с вашим UI, чтобы
     * другие объекты в очереди могли начать свою работу с интерфейсом
     * пользователя социальной сети.
     */
    private function show():Void;
}