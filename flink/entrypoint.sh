#!/usr/bin/env sh

export HADOOP_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)

case "$1" in
    adhoc)
        tail -f /dev/null
        ;;
    sql)
        shift
        exec /docker-entrypoint.sh ./bin/sql-client.sh embedded "$@"
        ;;
    *)
        exec /docker-entrypoint.sh "$@"
        ;;
esac