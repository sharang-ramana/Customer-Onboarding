package org.confluent.customeronboarding.service;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.KafkaException;
import org.springframework.stereotype.Service;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

@Service
public class KafkaProducerService {

    public <T> void sendMessage(String key, T message, String topic) throws IOException {

        final Properties props;
        try {
            props = loadConfig("/path/to/client.properties");
        } catch (IOException e) {
            throw new IOException("Error loading Kafka configuration.", e);
        }

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

    private Properties loadConfig(final String configFile) throws IOException {
        if (!Files.exists(Paths.get(configFile))) {
            throw new IOException(configFile + " not found.");
        }
        final Properties cfg = new Properties();
        try (InputStream inputStream = new FileInputStream(configFile)) {
            cfg.load(inputStream);
        }
        return cfg;
    }
}
