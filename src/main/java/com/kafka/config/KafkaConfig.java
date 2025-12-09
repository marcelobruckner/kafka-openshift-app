package com.kafka.config;

import org.apache.kafka.clients.admin.NewTopic;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.TopicBuilder;

@Configuration
public class KafkaConfig {

    @Value("${kafka.topic.mensagens}")
    private String topicMensagens;

    @Bean
    public NewTopic mensagensTopic() {
        return TopicBuilder.name(topicMensagens)
                .partitions(3)
                .replicas(1)
                .build();
    }
}