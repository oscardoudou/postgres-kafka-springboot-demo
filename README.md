postgres-kafka-springboot-min-demo
===============
#### 1. Spin up kakfa
```
cd confluent-platform
docker-compose up -d
```

#### 2. Create topic
```
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
```

```
CREATE SOURCE CONNECTOR JDBC_SOURCE_POSTGRES_01 WITH (
    'connector.class'= 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url'= 'jdbc:postgresql://postgres:5432/postgres',
    'connection.user'= 'postgres',
    'connection.password'= 'postgres',
    'mode'= 'incrementing',
    'incrementing.column.name'= 'city_id',
    'topic.prefix'= 'postgres_',
    'transforms'= 'copyFieldToKey,extractKeyFromStruct,removeKeyFromValue',
    'transforms.copyFieldToKey.type'= 'org.apache.kafka.connect.transforms.ValueToKey',
    'transforms.copyFieldToKey.fields'= 'city_id',
    'transforms.extractKeyFromStruct.type'= 'org.apache.kafka.connect.transforms.ExtractField$Key',
    'transforms.extractKeyFromStruct.field'= 'city_id',
    'transforms.removeKeyFromValue.type'= 'org.apache.kafka.connect.transforms.ReplaceField$Value',
    'transforms.removeKeyFromValue.blacklist'= 'city_id',
    'key.converter' = 'org.apache.kafka.connect.converters.IntegerConverter'
);
SHOW CONNECTORS;
DESCRIBE CONNECTOR JDBC_SOURCE_POSTGRES_01
```

#### 3. Build and start consumer springboot service
```
mvn clean package
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar target/converter-0.0.1-SNAPSHOT.jar 
```

#### 4. Mimic postgres new data coming
```
docker exec -it postgres bash -c 'psql -U postgres'
INSERT INTO cities (city_id, name, state) VALUES (7, 'Chapel Hill', 'NC');
INSERT INTO cities (city_id, name, state) VALUES (8, 'Las Vegas', 'NV');
INSERT INTO cities (city_id, name, state) VALUES (9, 'New York', 'NY');
```

 if you also want existing records in topic, in applicaiton.yml change `auto-offset-reset` to `earliest`.

Here is an older version of [dockerfile](https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/), where it has a dedicated container for kafka connect, which I can make REST call to. 


#### Reference
https://kafka-tutorials.confluent.io/connect-add-key-to-source/ksql.html#declare-the-topic-as-a-ksqldb-table
https://www.confluent.io/blog/apache-kafka-spring-boot-application/
https://developer.confluent.io/learn-kafka/spring/hands-on-consume-messages/
https://spring.io/projects/spring-kafka#overview


