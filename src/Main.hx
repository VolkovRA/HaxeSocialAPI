package;

import js.lib.Error;
import social.ISocialNetworkClient;
import social.SocialUser;

/**
 * Пример.
 */
class Main 
{
    private static var social:ISocialNetworkClient;

    static function main() {
        #if VK
        trace("Test social API VK");
        social = new social.vk.VKontakteClient();
        #elseif OK
        trace("Test social API OK");
        social = new social.ok.OdnoklassnikiClient();
        #elseif FB
        trace("Test social API FB");
        social = new social.fb.FacebookClient();
        #end

        social.token = "118ddb9c6f269ec68c117f75b5f5ad14729ce19285ae967e3425facb5ca9ae2b03b942a8935320eecb9d9";
        social.init(onInit);
    }

    static function onInit(err:Error):Void {
        trace(social.title, "is init!", err);

        social.getFriends("94", function(task) {
            if (task.error != null) {
                trace(task.error);
                return;
            }

            trace("Friends:");
            trace(task.users);
        }, 10);

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
    }
}