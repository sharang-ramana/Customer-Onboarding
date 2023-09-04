package org.confluent.customeronboarding.service;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.KafkaException;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

@Service
@PropertySource("classpath:/cc-config.properties")
public class KafkaProducerService {

    private final Properties props;

    public KafkaProducerService() {
        props = loadProperties();
    }

    public <T> void sendMessage(String key, T message, String topic) {
        Producer<String, T> producer = new KafkaProducer<>(props);
        ProducerRecord<String, T> record = new ProducerRecord<>(topic, key, message);
        try {
            producer.send(record, new Callback() {
                @Override
                public void onCompletion(RecordMetadata metadata, Exception exception) {
                    if (exception != null) {
                        throw new KafkaException("Error while sending message to Kafka.", exception);
                    } else {
                        System.out.println("Message sent successfully to Kafka! topic=" + metadata.topic());
                        System.out.println("Partition: " + metadata.partition());
                        System.out.println("Offset: " + metadata.offset());
                    }
                }
            });

            producer.close();
        } catch (Exception e) {
            throw new KafkaException("Error while sending message to Kafka.", e);
        }
    }

    private Properties loadProperties() {
        Properties properties = new Properties();
        try (InputStream inputStream = new ClassPathResource("cc-config.properties").getInputStream()) {
            properties.load(inputStream);
        } catch (IOException e) {
            throw new RuntimeException("Error loading properties from cc-config.properties", e);
        }
        return properties;
    }
}
