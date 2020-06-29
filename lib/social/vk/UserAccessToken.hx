package social.vk;

/**
 * Ключ доступа пользователя.
 * 
 * Такой ключ требуется для работы со всеми методами нашего API,
 * за исключением методов секции secure. Ключ доступа — своего
 * рода «подпись» пользователя в Вашем приложении. Он сообщает
 * серверу, от имени какого пользователя осуществляются запросы,
 * и какие права доступа он выдал Вашему приложению.
 * 
 * @see Документация: https://vk.com/dev/access_token?f=1.%20%D0%9A%D0%BB%D1%8E%D1%87%20%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0%20%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8F
 */
typedef UserAccessToken = AccessToken;