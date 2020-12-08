package social.popup;

import js.Browser;
import social.utils.NativeJS;
import social.utils.Timestamp;

/**
 * Менеджер всплывающих окон.  
 * Используется для:
 * - Создание очереди на вызов диалоговых окон в интерфейсе
 *   социальной сети. Соц. сети не позволяют вызывать более
 *   одного окна за раз.
 * - Добавление задержки между вызовами диалоговых окон,
 *   так-как некоторые социальные сети могут блокировать
 *   мгновенные или слишком частые вызовы UI.
 * - Определение того, какое именно UI окно социальной сети
 *   открыто в данный момент и открыто ли вообще что-то.
 * 
 * Использование очень простое:
 * 1. Добавляете объект, реализующий интерфейс `social.popup.IPopup`
 *    в менеджер с помощью метода `add()`
 * 2. Когда можно будет вызывать метод UI, менеджер вызовет
 *    метод: `social.popup.IPopup.show()`
 * 3. Затем вы **должны** удалить отработанный объект из
 *    менеджера, чтобы он мог обработать следующий объект.
 */
@:dce
@:noCompletion
class PopupManager
{
    /**
     * Пауза между вызовами `setInterval`. *(mc)*  
     * Используется для проверки вызова всплывающих окон.
     */
    static private inline var INTERVAL:Int = 100;

    /**
     * Создать менеджер всплывающих окон.
     */
    public function new() {
    }

    /**
     * Очередь всплывающих окон.  
     * Содержит список добавленных объектов для вызова.
     * 
     * *п.с. Используется внутренней реализацией, вы не должны изменять
     * этот список.*
     * 
     * Не может быть `null`
     */
    private var items = new Array<IPopup>();

    /**
     * ID Интервала автообновления для запуска вызова.  
     * По умолчанию: `0`
     */
    private var intervalID:Int = 0;

    /**
     * Дата последнего закрытия окна.  
     * Не может быть `null`
     */
    private var stamp:Timestamp = 0;

    /**
     * Грязный список.  
     * Используется внутренней реализацией для оптимизации.  
     * Означает необходимость "чистки" списка.
     */
    private var dirty:Bool = false;

    /**
     * Задержка между вызовами окон. *(mc)*  
     * Используется для создания искуственной паузы между вызовом
     * диалоговых окон,   так-как некоторые соц. сети блокируют
     * или не обрабатывают мгновенные вызовы.
     * 
     * **Обратите внимание**, что низкая задержка может негативно
     * сказаться на вызове диалоговых окон. Социальные сети с их
     * кривыми API вообще не внушают доверия.
     * 
     * По умолчанию: `1000` *(1 секунда)*
     */
    public var delay:Int = 1000;

    /**
     * Количество элементов в очереди, включая активное в данный
     * момент окно.  
     * Не может быть `null`
     */
    public var length(get, never):Int;
    inline function get_length():Int {
        return items.length;
    }

    /**
     * Текущий, активный объект.  
     * Это свойство изменяется автоматический. Оно указывает на
     * активный в данный момент объект `social.popup.IPopup`, у
     * которого был вызван метод: `IPopup.show()`.
     * 
     * *п.с. Используется внутренней реализацией, вы не должны изменять
     * значение этого свойства.*
     * 
     * По умолчанию: `null` *(Всплывающее окно не вызвано)*
     */
    public var current(default, null):IPopup = null;

    /**
     * Добавить новый объект.  
     * - Вызов игнорируется, если передан `null`.
     * - Вызов игнорируется, если объект **уже содержится** в списке.
     * - Если в данный момент очередь пуста, объект будет вызван на
     *   следующем тике `setInterval`.
     * - Если очередь не пуста, объект будет вызван последним.
     * @param item Объект для вызова UI.
     */
    public function add(item:IPopup):Void {
        if (item == null)
            return;
        if (item.popupIndex >= 0)
            return;

        var len = items.length;
        item.popupIndex = len;
        items[len] = item;

        if (intervalID == 0)
            intervalID = Browser.window.setInterval(onUpdate, INTERVAL);
    }

    /**
     * Удалить объект.  
     * - Вызов игнорируется, если передан `null`.
     * - Вызов игнорируется, если объект **не содержится** в списке.
     * - Если удаляемый объект в данный момент активен `current == item`,
     *   он удаляется из очереди и с задержкой `delay` будет вызван
     *   следующий объект из очереди, если есть.
     * - Если объект не является активным `current != item`, он просто
     *   удаляется из очереди.
     * @param item Объект для вызова UI, завершивший свою миссию.
     */
    public function remove(item:IPopup):Void {
        if (item == null)
            return;

        // Удаление активного объекта:
        if (current == item) {
            stamp = NativeJS.stamp();
            items[item.popupIndex] = null;
            item.popupIndex = -1;
            dirty = true;
            current = null;

            if (intervalID == 0)
                intervalID = Browser.window.setInterval(onUpdate, INTERVAL);
            return;
        }

        // Удаление пассивного объекта:
        if (item.popupIndex >= 0) {
            items[item.popupIndex] = null;
            item.popupIndex = -1;
            dirty = true;

            if (intervalID == 0)
                intervalID = Browser.window.setInterval(onUpdate, INTERVAL);
            return;
        }
    }

    /**
     * Очистить очередь вызова.  
     * Полностью очищает всю очередь и приводит менеджер в изначальное
     * состояние.
     * - Полезно при зависании очереди вызова UI.
     * - Вызов игнорируется, если список пустой.
     * 
     * *п.с. Очень сложно построить детерменированное поведение, когда
     * социальная сеть тебе на 3 вызова возвращает результат в колбек
     * 4 раза, или не возвращает. (Одноклассники)*
     */
    public function clear():Void {
        var i = items.length;
        while (i-- > 0)
            items[i].popupIndex = -1;

        stamp = 0;
        dirty = false;

        if (intervalID > 0) {
            Browser.window.clearInterval(intervalID);
            intervalID = 0;
        }   
    }

    /**
     * Хендлер для обратного вызова `setInterval`.
     */
    private function onUpdate():Void {

        // Цикл обновления.
        // Чистим список, удаляем null'ы:
        if (dirty) {
            var i = 0;
            var index = 0;
            var len = items.length;
            while (i < len) {
                if (items[i] == null)
                    i ++;
                else {
                    items[index] = items[i];
                    items[index].popupIndex = index;
                    index ++;
                    i ++;
                }
            }
            items.resize(index);
            dirty = false;
        }
        
        // Объектов больше нет:
        if (items.length == 0) {
            if (intervalID > 0) {
                Browser.window.clearInterval(intervalID);
                intervalID = 0;
            }
            return;
        }

        // Следующий вызов:
        if (current == null && stamp + delay < NativeJS.stamp()) {
            current = items[0];
            current.show();
        }
    }

    /**
     * Получить текстовое представление объекта.
     * @return Возвращает текстовое представление этого экземпляра.
     */
    @:keep
    @:noCompletion
    public function toString():String {
        return "[PopupManager]";
    }
}