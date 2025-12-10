#!/bin/bash

ROUTE=$(oc get route kafka-app -o jsonpath='{.spec.host}')
echo "=== Testando Aplicação Kafka ==="
echo "URL da aplicação: http://$ROUTE"
echo ""

echo "1. Verificando se a aplicação está funcionando..."
curl -s http://$ROUTE/actuator/health | jq .
echo ""

echo "2. Enviando mensagem para o Kafka..."
RESPONSE=$(curl -s -X POST http://$ROUTE/api/mensagens \
  -H "Content-Type: application/json" \
  -d '{"conteudo": "Olá Kafka! Esta é uma mensagem de teste."}')
echo "Resposta: $RESPONSE"
echo ""

echo "3. Aguardando 3 segundos para processar..."
sleep 3

echo "4. Verificando logs da aplicação (últimas 20 linhas):"
echo "--- LOGS DO PRODUCER (quem envia) ---"
oc logs deployment/kafka-app --tail=20 | grep -E "(Sending|Produced|mensagem)"
echo ""

echo "--- LOGS DO CONSUMER (quem recebe) ---"
oc logs deployment/kafka-app --tail=20 | grep -E "(Received|Consumed|Consumer)"
echo ""

echo "5. Status do tópico Kafka:"
oc get kafkatopic mensagens-topic -n kafka-infra -o jsonpath='{.status.conditions[0].message}' 2>/dev/null || echo "Tópico não encontrado"
echo ""

echo "=== Como funciona ==="
echo "1. Você envia POST /api/mensagens -> Producer envia para Kafka"
echo "2. Kafka armazena a mensagem no tópico 'mensagens-topic'"
echo "3. Consumer lê automaticamente e processa a mensagem"
echo "4. Tudo acontece de forma assíncrona!"