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
#create the connector/topic outside the KSQL CLI session, details see src/statements.sql
./sendStmtToRest.sh
```

### 4. Build and start consumer springboot service
```
mvn clean package
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar target/converter-0.0.1-SNAPSHOT.jar 
```

### 5. Mimic postgres new record insertion 
```
docker-compose exec postgres bash 
```
```
#add 2-3 amendments records per batch, 2s interval between each batch
for i in {0..2}; do psql -U postgres -f data/insert${i}.sql; sleep 2; done
```

### 6. Observe the log from springboot service and clean up
you should see message coming in and will be process in 5s, then continue processing message.
```
docker-compose down
```

## Other
If you also want existing records in topic, in applicaiton.yml change `auto-offset-reset` to `earliest`.

Here is an older version of [dockerfile](https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/), where it has a dedicated container for kafka connect, which I can make REST call to. 


## Reference
Query based ingest  
https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/

Create Conector/Topic and message construction aka SMT(single message tranfrom)  
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
