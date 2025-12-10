#!/bin/bash

echo "=== Corrigindo instalação do Operator ==="

# Verificar CSV (ClusterServiceVersion)
echo "1. Verificando CSV do operator..."
oc get csv -n kafka-infra

echo ""
echo "2. Verificando InstallPlan..."
oc get installplan -n kafka-infra

echo ""
echo "3. Verificando todos os pods..."
oc get pods -n kafka-infra

echo ""
echo "4. Recriando operator..."
oc delete subscription amq-streams -n kafka-infra 2>/dev/null
oc delete operatorgroup kafka-infra-operator-group -n kafka-infra 2>/dev/null
oc delete csv amqstreams.v3.0.1-7 -n kafka-infra 2>/dev/null
sleep 5
oc apply -f $(dirname $0)/amq-streams-operator.yaml
echo "Aguardando 60 segundos..."
sleep 60
oc get pods -n kafka-infra
