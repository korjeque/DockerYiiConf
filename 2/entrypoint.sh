#!/usr/bin/env bash

set -e

PG_PASSWORD=${PG_PASSWORD:-$(pwgen -c -n -1 16)}

if [ ! -d "$PG_DATA" ]; then

    echo "${PG_PASSWORD}" > ${PG_PASSWORD_FILE}
    chmod 600 ${PG_PASSWORD_FILE}

    ${PG_BINDIR}/initdb --locale ${LANG} --pgdata=${PG_DATA} --pwfile=${PG_PASSWORD_FILE} \
        --username=postgres --encoding=UTF8 --auth=trust

    echo "*************************************************************************"
    echo " PostgreSQL password is ${PG_PASSWORD}"
    echo "*************************************************************************"

    unset PG_PASSWORD
fi

exec "$@"