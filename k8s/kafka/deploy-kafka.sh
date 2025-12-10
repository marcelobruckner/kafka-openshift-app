#!/bin/bash

echo "=== Instalando AMQ Streams Operator ==="

# 1. Criar namespace e instalar operator
echo "1. Criando namespace e instalando operator..."
oc apply -f amq-streams-operator.yaml

# 2. Aguardar operator estar pronto
echo "2. Aguardando operator ficar pronto (pode levar 2-3 minutos)..."
sleep 30
oc wait --for=condition=Ready pod -l name=amq-streams-cluster-operator -n kafka-infra --timeout=300s

# 3. Criar cluster Kafka
echo "3. Criando cluster Kafka..."
oc apply -f kafka-cluster.yaml

# 4. Aguardar cluster estar pronto
echo "4. Aguardando cluster Kafka ficar pronto (pode levar 5-10 minutos)..."
oc wait kafka/my-cluster --for=condition=Ready --timeout=600s -n kafka-infra

# 5. Criar usuário e tópico
echo "5. Criando usuário e tópico..."
oc apply -f kafka-user-topic.yaml

# 6. Aguardar recursos estarem prontos
echo "6. Aguardando recursos ficarem prontos..."
oc wait kafkauser/app-user --for=condition=Ready --timeout=120s -n kafka-infra
oc wait kafkatopic/mensagens-topic --for=condition=Ready --timeout=120s -n kafka-infra

echo ""
echo "=== Status Final ==="
oc get kafka,kafkauser,kafkatopic -n kafka-infra

echo ""
echo "=== Pods ==="
oc get pods -n kafka-infra

echo ""
echo "Deploy do Kafka concluído!"
