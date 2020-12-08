package;

import js.Browser;
import js.lib.Error;

class Server 
{
    // VK
    static private inline var VK_USER       = "626124000";
    static private inline var VK_SERVICE    = "****";
    // OK
    static private inline var OK_USER       = "577631278162";
    static private inline var OK_SERVICE    = "****";
    // FB
    static private inline var FB_USER       = "****";
    static private inline var FB_SERVICE    = "****";

    private static var server:social.network.INetworkServer;
    static function main() {
        #if VK
        server = new social.target.vk.VKontakteServer();
        server.serviceKey = VK_SERVICE;
        #elseif OK
        server = new social.target.ok.OdnoklassnikiServer();
        server.serviceKey = OK_SERVICE;
        #elseif FB
        server = new social.target.fb.FacebookServer();
        server.serviceKey = FB_SERVICE;
        #else
        throw new Error("Реализация интерфейса не указана");
        #end

        //server.setLevel(VK_USER, 9, function(task){ trace(task); });
        //server.setScores(VK_USER, 1, function(task){ trace(task); });
    }
}