
SET table.dynamic-table-options.enabled=true;
SET execution.type = streaming ;
SET execution.result-mode = 'table';

CREATE CATALOG demo WITH (
  'type'='iceberg',
  'catalog-type'='hadoop',
  'warehouse'='file:///tmp/iceberg/warehouse',
  'property-version'='1'
);

CREATE CATALOG hive_catalog WITH (
  'type'='iceberg',
  'catalog-type'='hive',
  'uri'='thrift://hive:9083',
  'clients'='5',
  'property-version'='1',
  'warehouse'='file:///tmp/iceberg/warehouse/hive'
);


CREATE DATABASE iceberg_db;

USE iceberg_db;

CREATE TABLE iceberg_upsert(
    id   BIGINT,
    data STRING,
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
    data STRING
) WITH (
    'catalog-name'='hive-catalog',
    'catalog-db'='demo',
    'catalog-type'='hive',
    'format-version' = '2',
    'write.upsert.enable'='true'
);

CREATE TABLE iceberg_upsert (
    id   BIGINT,
    data STRING
) WITH (
    'connector'='iceberg',
    'catalog-name'='hive-catalog',
    'catalog-database'='local',
    'catalog-type'='hive',
    'format-version' = '2',
    'uri'='thrift://hive:9083',
    'warehouse'='file:///tmp/iceberg/warehouse/hive',
    'write.upsert.enable'='true'
);

CREATE TABLE demo (
    id   BIGINT,
    data STRING
) WITH (
    'format-version' = '2',
    'write.upsert.enable'='true'
);


INSERT INTO demo VALUES 
  (1, 'AAA'),
  (2, 'BBB'),
  (3, 'CCC'),
  (4, 'DDD'),
  (5, 'EEE'),
  (6, 'FFF')
;
INSERT OVERWRITE demo values (1, 'AAA'), (2, 'BBB'), (3, 'CCC');


/* streaming read query */
SELECT * FROM demo /*+ OPTIONS('streaming'='true', 'monitor-interval'='1s') */ ;



CREATE CATALOG mypg WITH(
    'type' = 'jdbc',
    'default-database' = 'metastore',
    'username' = 'hive',
    'password' = 'hive',
    'base-url' = 'jdbc:postgresql://hive:5432/'
);


CREATE TABLE charges (
     id INT,
     amount INT,
     create_time TIMESTAMP,
     updated_time TIMESTAMP,
     PRIMARY KEY(id) NOT ENFORCED
) WITH (
    'connector' = 'mysql-cdc',
    'hostname' = 'mysql',
    'port' = '3306',
    'username' = 'demo',
    'password' = 'demo',
    'database-name' = 'demo',
    'table-name' = 'charges'
);