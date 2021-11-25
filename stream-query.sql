
SET table.dynamic-table-options.enabled=true;
SET execution.type = streaming ;
SET execution.result-mode=changelog;

CREATE CATALOG demo WITH (
  'type'='iceberg',
  'catalog-type'='hadoop',
  'warehouse'='file:///tmp/iceberg/warehouse',
  'property-version'='1'
);

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


SELECT * FROM iceberg_upsert /*+ OPTIONS('streaming'='true', 'monitor-interval'='1s') */ ;