package social.target.vk.objects;

import social.target.vk.enums.ErrorCode;

/**
 * Ошибка запроса к API VK.  
 * @see Репозиторий типов: https://github.com/VKCOM/vk-api-schema
 */
typedef BaseError = 
{
    /**
     * Код ошибки.
     */
    var error_code:ErrorCode;

    /**
     * Описание ошибки.
     */
    var error_msg:String;

    /**
     * Параметры, переданные в запрос к API.
     */
    var request_params:Array<Dynamic>;
}