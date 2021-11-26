#!/usr/bin/env bash

docker-compose exec adhoc /entrypoint.sh sql --environment /opt/flink/conf/flink-sql.yaml