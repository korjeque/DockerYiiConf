FROM ubuntu:16.04

RUN echo 'Europe/Moscow' | tee /etc/timezone \
    && apt-get update \
    && apt-get -yq install php7.0 \
        php7.0-common \
        php7.0-fpm \
        php7.0-cli \
    && mkdir -p /var/run/php

ADD files /

CMD ["php-fpm7.0", "-F"]

EXPOSE 9000