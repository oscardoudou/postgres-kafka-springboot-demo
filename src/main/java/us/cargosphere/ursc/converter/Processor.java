package us.cargosphere.ursc.converter;

import org.apache.avro.generic.GenericRecord;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class Processor {
    private final Logger logger = LoggerFactory.getLogger(Processor.class);
    @KafkaListener(topics = "${topic}", groupId = "group_id")
    public void convert(ConsumerRecord<String, GenericRecord> record) throws InterruptedException{
        String amendmentId = record.key();
        GenericRecord messageValue = record.value();
        logger.info("AmendmentId: " + amendmentId + ":" + messageValue.get("ocean_contract_group_id") + " received");
        Thread.sleep(5000);
        logger.info("AmendmentId: " + amendmentId + ":" + messageValue.get("administrator") + " get processed");
    }
}
