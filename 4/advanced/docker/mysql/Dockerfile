FROM ubuntu:16.04

MAINTAINER Mikhail Bakulin <bakulin_m@tass.ru>

ARG DEBIAN_FRONTEND=noninteractive

COPY files /

RUN echo 'Europe/Moscow' | tee /etc/timezone

RUN apt-get update -y \
    && apt-get install -yq mysql-server \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld

# Comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf
RUN echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]
