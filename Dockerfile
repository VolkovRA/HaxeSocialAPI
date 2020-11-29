FROM nginx:alpine

# Информация:
LABEL maintainer="VolkovRA"
LABEL description="The static server for tests"

# Создание директории приложения
WORKDIR /usr/src/app

# Порты:
EXPOSE 80/tcp
EXPOSE 443/tcp

# Копируем файлы приложения:
COPY ./bin/nginx.conf /etc/nginx/nginx.conf
COPY ./bin/ssl ./ssl
COPY ./bin/www ./www

# SSL Сертификаты:
VOLUME /etc/nginx
VOLUME $PWD/ssl
