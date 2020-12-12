package;

import js.Browser;
import js.lib.Error;

class Client 
{
    static private inline var VK_USER   = "626124000";

    private static var client:social.network.INetworkClient;
    static function main() {
        #if VK
        client = new social.target.vk.VKontakteClient();
        #elseif OK
        client = new social.target.ok.OdnoklassnikiClient();
        #elseif FB
        client = new social.target.fb.FacebookClient();
        #else
        throw new Error("Реализация интерфейса не указана");
        #end

        client.init({
            callback: onBrowserInit,
            sdk: true, // <-- Инициализировать SDK.
            iframe: true, // <-- Чтение параметров из iframe.
        });
    }
    static private function onBrowserInit(error:Error):Void {
        if (error != null)
            throw error;

        #if VK
        buildUI_VK();
        #elseif OK
        buildUI_OK();
        #elseif FB
        buildUI_FB();
        #end
    }
    static private function buildUI_VK():Void {
        var bt1 = Browser.document.createButtonElement();
        bt1.textContent = "Получить список друзей";
        bt1.onclick = function(){
            client.getFriends(client.user, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Friends:");
                trace(task.result);
            }, 10);
        };

        var bt2 = Browser.document.createButtonElement();
        bt2.textContent = "Получить данные юзеров";
        bt2.onclick = function(){
            client.getUsers([
                { id:"98" },            // Удалённый
                { id:"1718726" },       // Закрытый (Приватный)
                { id:"551229537" },     // Забаненный
                { id:"1" },             // Павел Дуров
                { id:"5513242495" },    // Несуществующий
            ], null, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Users:");
                trace(task.users);
            });
        };

        var bt3 = Browser.document.createButtonElement();
        bt3.textContent = "Пригласить друга";
        bt3.onclick = function(){
            client.invite(null, "Присоединяйся!", function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Приглашение завершено:", task.result, task.resultUsers);
            });
        };

        var bt4 = Browser.document.createButtonElement();
        bt4.textContent = "Поделиться";
        bt4.onclick = function(){
            client.post("Только посмотрите на это!", "photo-192978621_457239019", "https://vk.com/app7359309", function(task){
                if (task.error != null) {
                    trace(task.error);
                    return;
                }    
                trace("Пост завершён:", task.result, task.resultPostID);
            });
        };

        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt1); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt2); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt3); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt4); Browser.document.body.appendChild(Browser.document.createBRElement());
    }
    static private function buildUI_OK():Void {
        var bt1 = Browser.document.createButtonElement();
        bt1.textContent = "Получить список друзей";
        bt1.onclick = function(){
            client.getFriends(client.user, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Friends:");
                trace(task.result);
            }, 10);
        };

        var bt2 = Browser.document.createButtonElement();
        bt2.textContent = "Получить данные юзеров";
        bt2.onclick = function(){
            client.getUsers([
                { id:"98" },            // Удалённый
                { id:"1718726" },       // Закрытый (Приватный)
                { id:"551229537" },     // Забаненный
                { id:"1" },             // Павел Дуров
                { id:"5513242495" },    // Несуществующий
            ], null, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Users:");
                trace(task.users);
            });
        };

        var bt3 = Browser.document.createButtonElement();
        bt3.textContent = "Пригласить друга";
        bt3.onclick = function(){
            client.invite(null, "Присоединяйся!", function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Приглашение завершено:", task.result, task.resultUsers);
            });
        };

        var bt4 = Browser.document.createButtonElement();
        bt4.textContent = "Поделиться";
        bt4.onclick = function(){ client.post("Заходите играть!", "", "https://vk.com/app7359309", function(task){ trace("Post closed"); trace(task); }); };
        bt4.onclick = function(){
            client.post("Только посмотрите на это!", "https://i.pinimg.com/originals/f4/d2/96/f4d2961b652880be432fb9580891ed62.png", "https://www.google.com", function(task){
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Пост завершён:", task.result, task.resultPostID);
            });
        };

        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt1); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt2); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt3); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt4); Browser.document.body.appendChild(Browser.document.createBRElement());
    }
}