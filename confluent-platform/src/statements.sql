CREATE SOURCE CONNECTOR JDBC_SOURCE_POSTGRES_10 WITH (
'connector.class'= 'io.confluent.connect.jdbc.JdbcSourceConnector',
'connection.url'= 'jdbc:postgresql://postgres:5432/postgres',
'connection.user'= 'postgres',
'connection.password'= 'postgres',
'mode'= 'incrementing',
'incrementing.column.name'= 'ocean_contract_amendment_id',
'topic.prefix'= 'postgres_',
'query'= 'SELECT ocean_contract_group_id, ocean_contract_amendment_id, amendment_name, amendment_status, administrator, date_added from cs_ocean_contract_amendment',
'transforms' = 'copyFieldToKey, extractKeyFromStruct',
'transforms.copyFieldToKey.type'= 'org.apache.kafka.connect.transforms.ValueToKey',
'transforms.copyFieldToKey.fields'= 'ocean_contract_amendment_id',
'transforms.extractKeyFromStruct.type'= 'org.apache.kafka.connect.transforms.ExtractField$Key',
'transforms.extractKeyFromStruct.field'= 'ocean_contract_amendment_id',
'key.converter' = 'org.apache.kafka.connect.converters.IntegerConverter'
);
