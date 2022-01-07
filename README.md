postgres-kafka-springboot-min-demo
===============
### 1. Spin up kakfa
```
cd confluent-platform
docker-compose up -d
```

### 2. Verify everything is prepared
```
docker-compose exec postgres bash
#verify the table is there
psql -U postgres -c 'select * from cs_ocean_contract_amendment'
```
```
#wait a few seconds for ksqldb up and running, otherwise you may get error in ksql cli prompt
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
show topics;
```

### 3. Create connector/topic based on query
```
cd confluent-platform
#create the connector/topic outside the KSQL CLI session, details see src/jdbc_connector.sql src/debezium_connector.sql
# if you choose debezium
./sendStmtToRest.sh debezium
# if you choose jdbc
./sendStmtToRest.sh jdbc
```

### 4. Build and start consumer springboot service
```
mvn clean package
# if you choose debezium 
export TOPIC='postgres.public.cs_ocean_contract_amendment'
# if you choose jdbc
export TOPIC='postgres_'
# restart the applicatino without rebuild, hot load of application.yml
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar target/converter-0.0.1-SNAPSHOT.jar --spring.config.location=src/main/resources/application.yml
```

### 5. Mimic postgres new record insertion 
```
docker-compose exec postgres bash 
```
```
# add 2-3 amendments records per batch, 2s interval between each batch
for i in {0..2}; do psql -U postgres -f data/insert${i}.sql; sleep 2; done
# to observe data change other than insert, do similar update/delete instead(delete would cause null pointer as value is null)
```

### 6. Observe the log from springboot service and clean up
you should see message coming in and will be process in 5s, then continue processing message.
```
docker-compose down
```

## Other
1. If you also want existing records in topic, in applicaiton.yml change `auto-offset-reset` to `earliest`.

2. Here is an older version of [dockerfile](https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/), where it has a dedicated container for kafka connect, which I can make REST call to. 

3. To check postgres logical decoding pluin installed correctly  
    `docker-compose exec postgres bash -c 'ls /usr/lib/postgresql/13/lib/| grep decoderbufs.so`

    Supposedly, you need to install using `confluent-hub` command, which is not ideal if you just want use docker.   
    `confluent-hub install --component-dir confluent-hub-components --no-prompt debezium/debezium-connector-postgresql:1.1.0`  
    Notice the [bash script in ksqldb container](https://github.com/oscardoudou/postgres-kafka-springboot-demo/blob/master/confluent-platform/docker-compose.yml#L87) does the same thing, so adding one more step should add the debezium.  
    `/home/appuser/bin/confluent-hub install --no-prompt --component-dir confluent-hub-components/ debezium/debezium-connector-postgresql:1.1.0` 

4. To check kafka connect debezium plugin installed to correct location.  
    if kafka connect has its own container like the dockerfile^, login into dedicated kafka connect container, checkout `/usr/share/java/kafka-connect-jdbc` potentially for all kinds of jdbc connectors, but most likelly could be already there.   
    if kafka connect is embedded in ksqldb, login to ksqldb-server `docker-compose exec ksqldb-server bash`, checkout the `KSQL_CONNECT_PLUGIN_PATH` property in ksqldb container configuration part.   
    Further [reading](https://docs.ksqldb.io/en/0.11.0-ksqldb/tutorials/embedded-connect/#when-to-use-embedded-connect) regarding when to use embedded kafka connecet. 



## Reference

### 1. Jdbc connector
Query based ingest  
https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/

Create Conector/Topic and message construction aka SMT(single message transfrom)  
https://kafka-tutorials.confluent.io/connect-add-key-to-source/ksql.html#declare-the-topic-as-a-ksqldb-table

SpringBoot Annotation  
https://www.confluent.io/blog/apache-kafka-spring-boot-application/  
https://developer.confluent.io/learn-kafka/spring/hands-on-consume-messages/

Initial springboot skeleton(actually I just learn the kafka maven dependency from this)  
https://spring.io/projects/spring-kafka#overview

Maven dependency and application.yml  
https://www.confluent.io/blog/schema-registry-avro-in-spring-boot-application-tutorial/

Consumer Record and application.yml(you could tell from the line that set Properties object)  
https://docs.confluent.io/platform/current/schema-registry/serdes-develop/serdes-avro.html


### 2. Debezium connector  
Postgres supported logical decoding output plugins: wal2json, decoderbufs and pgoutput introduced in Debezium 0.10(now standard logical decoding output plugin in PostgreSQL 10+)    
https://debezium.io/documentation/reference/stable/connectors/postgresql.html

Debezium postgres docker image(this install both wal2json and decoderbufs)   
https://github.com/debezium/docker-images/tree/main/postgres/13

Debezium documentation   
Plugin installation and postgres configuration(this would be necessary when manuall install instead of docker)   
https://debezium.io/documentation/reference/stable/postgres-plugins.html   
Decoderbuf/protobu plugin spefic(important note under usage regarding not able to see `UPDATE` and `DELETE`)   
https://github.com/debezium/postgres-decoderbufs/blob/main/README.md
