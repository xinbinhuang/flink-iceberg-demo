
SET table.dynamic-table-options.enabled=true;
SET execution.type = streaming ;
SET 'sql-client.execution.result-mode' = 'changelog';

CREATE CATALOG demo WITH (
  'type'='iceberg',
  'catalog-type'='hadoop',
  'warehouse'='file:///tmp/iceberg/warehouse',
  'property-version'='1'
);

CREATE CATALOG hive_catalog WITH (
  'type'='iceberg',
  'catalog-type'='hive',
  'uri'='thrift://localhost:9083',
  'clients'='5',
  'property-version'='1',
  'warehouse'='hdfs://nn:8020/warehouse/path'
);


CREATE DATABASE iceberg_db;

USE iceberg_db;

CREATE TABLE iceberg_upsert(
    id   BIGINT,
    data STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector'='iceberg',
    'format-version' = '2',
    'catalog-name'='demo',
    'catalog-type'='hadoop',
    'warehouse'='file:///tmp/iceberg/warehouse',
    'write.upsert.enable'='true'
);

CREATE TABLE iceberg_upsert(
    id   BIGINT,
    data STRING,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector'='iceberg',
    'format-version' = '2',
    'catalog-name'='demo',
    'catalog-type'='hive',
    'warehouse'='file:///tmp/iceberg/warehouse',
    'write.upsert.enable'='true'
);


INSERT INTO iceberg_upsert VALUES(1,'qq');

INSERT INTO iceberg_upsert VALUES(2,'aa');

SELECT * FROM iceberg_upsert /*+ OPTIONS('streaming'='true', 'monitor-interval'='1s') */ ;