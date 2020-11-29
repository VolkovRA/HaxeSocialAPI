package;

import js.Browser;
import js.lib.Error;
import social.network.INetwork;
import social.network.INetworkClient;
import social.user.User;

/**
 * Пример.
 */
class Main 
{
    private static var social:INetworkClient;

    static function main() {

        #if VK
        social = new social.target.vk.VKontakteClient();
        #elseif OK
        social = new social.target.ok.OdnoklassnikiClient();
        #elseif FB
        social = new social.target.fb.FacebookClient();
        #end

        social.token = "4664b0a8889e4a876c7fa6326aa973721fd54c80cf44aeb2debaa2d61cadef9223be12f6c69d734ee595f";
        social.init({
            callback: onInit,
            sdk: true, // <-- Требуется запуск внутри iframe на социальной сети.
        });
    }
    static private function onInit(error:Error):Void {
        buildUI_VK();
    }
    static private function buildUI_VK():Void {
        var bt1 = Browser.document.createButtonElement();
        bt1.textContent = "Получить список друзей";
        bt1.onclick = function(){
            social.getFriends("94", function(task) {
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
            social.getUsers([
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
        bt3.onclick = function(){ social.invite(null, "Го играть!", function(task){ trace("Invite closed"); }); };

        var bt4 = Browser.document.createButtonElement();
        bt4.textContent = "Поделиться";
        bt4.onclick = function(){ social.post("Заходите играть!\n\rhttps://vk.com/app7359309", "photo-192978621_457239019", "https://vk.com/app7359309", function(task){ trace("Post closed"); trace(task); }); };

        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt1); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt2); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt3); Browser.document.body.appendChild(Browser.document.createBRElement());
        Browser.document.body.appendChild(bt4); Browser.document.body.appendChild(Browser.document.createBRElement());
    }
}