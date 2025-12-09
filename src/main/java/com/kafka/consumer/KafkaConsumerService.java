package com.kafka.consumer;

import com.kafka.model.Mensagem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;

@Service
public class KafkaConsumerService {

    private static final Logger logger = LoggerFactory.getLogger(KafkaConsumerService.class);

    @KafkaListener(topics = "${kafka.topic.mensagens}", groupId = "${spring.kafka.consumer.group-id}")
    public void consumirMensagem(
            @Payload Mensagem mensagem,
            @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
            @Header(KafkaHeaders.OFFSET) long offset) {
        
        logger.info("Mensagem recebida: {} | Partition: {} | Offset: {}", 
            mensagem, partition, offset);
        
        // Processar a mensagem aqui
        processarMensagem(mensagem);
    }

    private void processarMensagem(Mensagem mensagem) {
        logger.info("Processando mensagem ID: {} - Conteúdo: {}", 
            mensagem.getId(), mensagem.getConteudo());
    }
}