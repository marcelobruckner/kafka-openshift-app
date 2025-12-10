# Como funciona o Kafka - Explicação Simples

## O que é o Kafka?
O Kafka é como um **correio eletrônico** para aplicações. Ele recebe mensagens de quem quer enviar (Producer) e entrega para quem quer receber (Consumer).

## Componentes da nossa aplicação:

### 1. **Producer** (Quem envia)
- Quando você faz `POST /api/mensagens`
- A aplicação pega sua mensagem e envia para o Kafka
- É como colocar uma carta no correio

### 2. **Kafka Broker** (O correio)
- Recebe e armazena as mensagens
- Organiza em "tópicos" (como caixas postais)
- Nosso tópico se chama `mensagens-topic`

### 3. **Consumer** (Quem recebe)
- Fica "escutando" o tópico
- Quando chega uma mensagem nova, processa automaticamente
- É como verificar a caixa de correio constantemente

## Fluxo completo:

```
Você → POST /api/mensagens → Producer → Kafka → Consumer → Logs
```

## Para testar:

1. Execute: `./test-kafka.sh`
2. Veja os logs em tempo real: `oc logs -f deployment/kafka-app`
3. Envie várias mensagens e observe o comportamento

## Vantagens do Kafka:

- **Assíncrono**: Producer e Consumer não precisam estar online ao mesmo tempo
- **Durável**: Mensagens ficam armazenadas mesmo se a aplicação cair
- **Escalável**: Pode processar milhões de mensagens por segundo
- **Distribuído**: Funciona em múltiplos servidores

## Casos de uso reais:

- Logs de aplicação
- Eventos de e-commerce (compra realizada, pagamento processado)
- Streaming de dados (IoT, métricas)
- Integração entre microserviços