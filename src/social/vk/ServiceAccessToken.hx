package social.vk;

/**
 * Сервисный ключ доступа.
 * Сервисный ключ нужен для запросов, которые не требуют авторизации пользователя или сообщества.
 * Это такие методы, как secure.sendNotification для отправки уведомлений от приложения, или secure.addAppEvent для добавления информации о достижениях, а также, начиная с апреля 2017 года, открытые методы, например, users.get.
 * 
 * Документация: <i>https://vk.com/dev/access_token?f=3.%20%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81%D0%BD%D1%8B%D0%B9%20%D0%BA%D0%BB%D1%8E%D1%87%20%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0</i>
 * @author VolkovRA
 */
typedef ServiceAccessToken = AccessToken;