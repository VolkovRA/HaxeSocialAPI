package social.vk;

import social.Utils;
import social.vk.IFrameParams;

/**
 * Парсер данных VK.
 */
class Parser 
{
    /**
     * Создать парсер VK.
     */
    public function new() {
    }

    /**
     * Распарсить параметры запроса iframe.
     * Считывает строку и возвращает данные, которые передал VK.
     * @param str Строка запроса с параметрами от VK. (То, что после символа "?" в URL)
     * @return Объект параметров VK.
     */
    public function readIFrameParams(str:String):IFrameParams {
        if (str == null)
            return {};

        var arr = str.split("&");

        str = null; // <-- Go to GC

        var len = arr.length;
        var map:Dynamic = {};
        while (len-- != 0) {
            var index = arr[len].indexOf("=");
            if (index == -1)
                untyped map[Utils.decodeURI(arr[len])] = null;
            else
                untyped map[Utils.decodeURI(arr[len].substring(0, index))] = Utils.decodeURI(arr[len].substring(index + 1));
        }
        arr = null; // <-- Go to GC

        var data:IFrameParams = {};

        // Максимально эффективный JavaScript
        // String:
        if (map.api_url != null)        data.api_url = map.api_url;
        if (map.sid != null)            data.sid = map.sid;
        if (map.secret != null)         data.secret = map.secret;
        if (map.access_token != null)   data.access_token = map.access_token;
        if (map.auth_key != null)       data.auth_key = map.auth_key;
        if (map.api_result != null)     data.api_result = map.api_result;
        if (map.referrer != null)       data.referrer = map.referrer;
        if (map.hash != null)           data.hash = map.hash;
        if (map.lc_name != null)        data.lc_name = map.lc_name;
        if (map.ads_app_id != null)     data.ads_app_id = map.ads_app_id;

        // Int:
        if (map.api_id != null          && map.api_id != "")            untyped data.api_id             = Utils.parseInt(map.api_id);
        if (map.api_settings != null    && map.api_settings != "")      untyped data.api_settings       = Utils.parseInt(map.api_settings);
        if (map.viewer_id != null       && map.viewer_id != "")         untyped data.viewer_id          = Utils.parseInt(map.viewer_id);
        if (map.viewer_type != null     && map.viewer_type != "")       untyped data.viewer_type        = Utils.parseInt(map.viewer_type);
        if (map.user_id != null         && map.user_id != "")           untyped data.user_id            = Utils.parseInt(map.user_id);
        if (map.group_id != null        && map.group_id != "")          untyped data.group_id           = Utils.parseInt(map.group_id);
        if (map.is_app_user != null     && map.is_app_user != "")       untyped data.is_app_user        = Utils.parseInt(map.is_app_user);
        if (map.language != null        && map.language != "")          untyped data.language           = Utils.parseInt(map.language);
        if (map.parent_language != null && map.parent_language != "")   untyped data.parent_language    = Utils.parseInt(map.parent_language);
        if (map.is_secure != null       && map.is_secure != "")         untyped data.is_secure          = Utils.parseInt(map.is_secure);

        return data;
    }
}