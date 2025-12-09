package com.kafka.producer;

import com.kafka.model.Mensagem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class KafkaProducerService {

    private static final Logger logger = LoggerFactory.getLogger(KafkaProducerService.class);

    @Autowired
    private KafkaTemplate<String, Mensagem> kafkaTemplate;

    @Value("${kafka.topic.mensagens}")
    private String topicMensagens;

    public void enviarMensagem(Mensagem mensagem) {
        logger.info("Enviando mensagem: {}", mensagem);
        
        CompletableFuture<SendResult<String, Mensagem>> future = 
            kafkaTemplate.send(topicMensagens, mensagem.getId(), mensagem);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                logger.info("Mensagem enviada com sucesso: offset={}", 
                    result.getRecordMetadata().offset());
            } else {
                logger.error("Erro ao enviar mensagem: {}", ex.getMessage());
            }
        });
    }
}