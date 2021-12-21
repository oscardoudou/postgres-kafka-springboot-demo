CREATE SOURCE CONNECTOR amendments_reader_decoderbufs WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'plugin.name' = 'decoderbufs',
    'database.hostname' = 'postgres',
    'database.port' = '5432',
    'database.user' = 'postgres',
    'database.password' = 'postgres',
    'database.dbname' = 'postgres',
    'database.server.name' = 'postgres',
    'table.whitelist' = 'public.cs_ocean_contract_amendment',
    'transforms' = 'unwrap',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite'
);
