#!/bin/bash

echo "=== Verificando instalação do Kafka ==="
echo ""

echo "1. Operator instalado?"
oc get subscription amq-streams -n kafka-infra 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Subscription não encontrada"
else
    echo "✓ Subscription encontrada"
fi
echo ""

echo "2. Operator rodando?"
oc get pods -n kafka-infra -l name=amq-streams-cluster-operator 2>/dev/null
echo ""

echo "3. Cluster Kafka criado?"
oc get kafka my-cluster -n kafka-infra 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Cluster não encontrado"
else
    echo "✓ Cluster encontrado"
fi
echo ""

echo "4. Pods do Kafka:"
oc get pods -n kafka-infra | grep -E "my-cluster|NAME"
echo ""

echo "5. Logs do operator (últimas 20 linhas):"
oc logs -n kafka-infra -l name=amq-streams-cluster-operator --tail=20 2>/dev/null
echo ""

echo "6. Eventos recentes:"
oc get events -n kafka-infra --sort-by='.lastTimestamp' | tail -10
