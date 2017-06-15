FROM ubuntu:16.04

ENV LANG ru_RU.UTF-8
ENV PG_VERSION 9.6
ENV POSTGRES_DB yiiconf
# ENV PG_PASSWORD
ENV PG_BASE /var/lib/postgresql
ENV PG_PASSWORD_FILE ${PG_BASE}/pwfile
ENV PG_DATA ${PG_BASE}/${PG_VERSION}/main
ENV PG_CONFIG_DIR /etc/postgresql/${PG_VERSION}/main
ENV PG_CONFIG_FILE ${PG_CONFIG_DIR}/postgresql.conf
ENV PG_BINDIR /usr/lib/postgresql/${PG_VERSION}/bin

RUN echo 'Europe/Moscow' | tee /etc/timezone

RUN apt-get update \
    && apt-get install -yq software-properties-common python-software-properties wget \
    && add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -yq locales \
    && locale-gen $LANG && update-locale LANG=$LANG \
    && apt-get install -yq \
        postgresql-$PG_VERSION \
        postgresql-contrib-$PG_VERSION \
        pwgen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# ADD entrypoint.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

RUN rm -rf "$PG_BASE" && mkdir -p "$PG_BASE" && chown -R postgres:postgres "$PG_BASE" \
      && mkdir -p /var/run/postgresql/$PG_VERSION-main.pg_stat_tmp \
      && chown -R postgres:postgres /var/run/postgresql && chmod g+s /var/run/postgresql \
      && chmod +x /usr/local/bin/entrypoint.sh

RUN echo "host all  all    0.0.0.0/0  md5" >> $PG_CONFIG_DIR/pg_hba.conf \
  && echo "host all  all    ::/0  md5" >> $PG_CONFIG_DIR/pg_hba.conf \
  && echo "listen_addresses='*'" >> $PG_CONFIG_FILE

# No sudo in base images! Look at alternative https://github.com/tianon/gosu
USER postgres

VOLUME ["${PG_BASE}"]

EXPOSE 5432

ENTRYPOINT ["entrypoint.sh"]

CMD ${PG_BINDIR}/postgres -D ${PG_DATA} -c config_file=${PG_CONFIG_FILE}