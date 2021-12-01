package us.cargosphere.ursc.converter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class Processor {
    private final Logger logger = LoggerFactory.getLogger(Processor.class);
    @KafkaListener(topics = "postgres_cities", groupId = "group_id")
    public void convert(String amendmentId) throws InterruptedException{
        logger.info("AmendmentId: " + amendmentId + " received");
        Thread.sleep(5000);
        logger.info("AmendmentId: " + amendmentId + " get processed");
    }
}
