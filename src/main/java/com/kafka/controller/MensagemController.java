package com.kafka.controller;

import com.kafka.model.Mensagem;
import com.kafka.producer.KafkaProducerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/mensagens")
public class MensagemController {

    @Autowired
    private KafkaProducerService producerService;

    @PostMapping
    public ResponseEntity<String> enviarMensagem(@RequestBody Mensagem mensagem) {
        if (mensagem.getId() == null || mensagem.getId().isEmpty()) {
            mensagem.setId(UUID.randomUUID().toString());
        }
        
        producerService.enviarMensagem(mensagem);
        
        return ResponseEntity.ok("Mensagem enviada com sucesso! ID: " + mensagem.getId());
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Aplicação rodando!");
    }
}