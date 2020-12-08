package;

import js.Browser;
import js.lib.Error;

class Client 
{
    // VK
    static private inline var VK_USER   = "626124000";
    static private inline var VK_TOKEN  = "****";
    // OK
    static private inline var OK_USER   = "577631278162";
    static private inline var OK_TOKEN  = "****";
    // FB
    static private inline var FB_USER   = "****";
    static private inline var FB_TOKEN  = "****";

    private static var client:social.network.INetworkClient;
    static function main() {
        #if VK
        client = new social.target.vk.VKontakteClient();
        client.token = VK_TOKEN;
        #elseif OK
        client = new social.target.ok.OdnoklassnikiClient();
        client.token = OK_TOKEN;
        #elseif FB
        client = new social.target.fb.FacebookClient();
        client.token = FB_TOKEN;
        #else
        throw new Error("Реализация интерфейса не указана");
        #end

        client.init({
            callback: onBrowserInit,
            sdk: true, // <-- Требуется запуск внутри iframe на социальной сети.
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
            client.getFriends(VK_USER, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Friends:");
                trace(task.users);
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
            client.invite(null, "Го играть!1", function(task){ trace("Invite end", task.result, task.resultUsers); });
            client.invite([], "Го играть!2", function(task){ trace("Invite end", task.result, task.resultUsers); });
            client.invite([], "Го играть!3", function(task){ trace("Invite end", task.result, task.resultUsers); });
        };

        var bt4 = Browser.document.createButtonElement();
        bt4.textContent = "Поделиться";
        bt4.onclick = function(){ client.post("Заходите играть!\n\rhttps://vk.com/app7359309", "photo-192978621_457239019", "https://vk.com/app7359309", function(task){ trace("Post closed"); trace(task); }); };

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
            client.getFriends(VK_USER, function(task) {
                if (task.error != null) {
                    trace(task.error);
                    return;
                }
                trace("Friends:");
                trace(task.users);
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
            client.invite(null, "Го играть!1", function(task){ trace("Invite end", task.result, task.resultUsers); });
            client.invite([], "Го играть!2", function(task){ trace("Invite end", task.result, task.resultUsers); });
            client.invite([], "Го играть!3", function(task){ trace("Invite end", task.result, task.resultUsers); });
        };

        var bt4 = Browser.document.createButtonElement();
        bt4.textContent = "Поделиться";
        bt4.onclick = function(){ client.post("Заходите играть!\n\rhttps://vk.com/app7359309", "photo-192978621_457239019", "https://vk.com/app7359309", function(task){ trace("Post closed"); trace(task); }); };

        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt1); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt2); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt3); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt4); Browser.document.body.appendChild(Browser.document.createBRElement());
    }
}