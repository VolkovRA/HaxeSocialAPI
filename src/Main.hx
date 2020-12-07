package;

import js.Browser;
import js.lib.Error;
import social.network.INetwork;
import social.network.INetworkClient;
import social.network.INetworkServer;
import social.user.User;

class Main 
{
    // VK
    static private inline var TEST_USER_VK = "626124000";
    static private inline var CLIENT_TOKEN_VK = "****";
    static private inline var SERVICE_KEY_VK = "****";
    // OK
    static private inline var TEST_USER_OK = "577631278162";
    static private inline var CLIENT_TOKEN_OK = "****";
    static private inline var SERVICE_KEY_OK = "****";
    // FB
    static private inline var TEST_USER_FB = "****";
    static private inline var CLIENT_TOKEN_FB  = "****";
    static private inline var SERVICE_KEY_FB = "****";

    private static var client:INetworkClient;
    private static var server:INetworkServer;

    /**
     * Точка входа.
     */
    static function main() {
        #if nodejs
        testServer();
        #else
        testClient();
        #end
    }

    /**
     * Тесты для NodeJS.
     */
    static private function testServer():Void {
        #if VK
        server = new social.target.vk.VKontakteServer();
        server.serviceKey = SERVICE_KEY_VK;
        #elseif OK
        server = new social.target.ok.OdnoklassnikiServer();
        server.serviceKey = SERVICE_KEY_OK;
        #elseif FB
        server = new social.target.fb.FacebookServer();
        server.serviceKey = SERVICE_KEY_FB;
        #else
        throw new Error("Реализация интерфейса не указана");
        #end

        //server.setLevel(TEST_USER, 9, function(task){ trace(task); });
        //server.setScores(TEST_USER, 1, function(task){ trace(task); });
    }

    /**
     * Тесты для браузера.
     */
    static private function testClient():Void {
        #if VK
        client = new social.target.vk.VKontakteClient();
        client.token = CLIENT_TOKEN_VK;
        #elseif OK
        client = new social.target.ok.OdnoklassnikiClient();
        client.token = CLIENT_TOKEN_OK;
        #elseif FB
        client = new social.target.fb.FacebookClient();
        client.token = CLIENT_TOKEN_FB;
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
            client.getFriends(TEST_USER_VK, function(task) {
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
        bt3.onclick = function(){ client.invite(null, "Го играть!", function(task){ trace("Invite closed"); }); };

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
            client.getFriends(TEST_USER_OK, function(task) {
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
        bt3.onclick = function(){ client.invite(null, "Го играть!", function(task){ trace("Invite closed"); }); };

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