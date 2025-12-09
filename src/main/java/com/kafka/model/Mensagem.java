package com.kafka.model;

import java.time.LocalDateTime;

public class Mensagem {
    private String id;
    private String conteudo;
    private LocalDateTime timestamp;

    public Mensagem() {
        this.timestamp = LocalDateTime.now();
    }

    public Mensagem(String id, String conteudo) {
        this.id = id;
        this.conteudo = conteudo;
        this.timestamp = LocalDateTime.now();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getConteudo() {
        return conteudo;
    }

    public void setConteudo(String conteudo) {
        this.conteudo = conteudo;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "Mensagem{id='" + id + "', conteudo='" + conteudo + "', timestamp=" + timestamp + "}";
    }
}