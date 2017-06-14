FROM ubuntu:16.04

MAINTAINER Mikhail Bakulin <bakulin_m@tass.ru>

ENV TZ 'Europe/Moscow'
RUN apt-get update -y

# Install Nginx
RUN apt-get install -y curl && \
    curl -O "http://nginx.org/keys/nginx_signing.key"
RUN rpm --import nginx_signing.key
RUN apt-get install -y nginx

CMD ["nginx"]

RUN usermod -u 1000 www-data

EXPOSE 80
EXPOSE 443