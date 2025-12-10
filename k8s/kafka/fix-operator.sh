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
echo "4. Se não houver pods, deletar e recriar subscription..."
read -p "Recriar subscription? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    oc delete subscription amq-streams -n kafka-infra
    oc delete csv -n kafka-infra --all
    sleep 5
    oc apply -f amq-streams-operator.yaml
    echo "Aguardando 60 segundos..."
    sleep 60
    oc get pods -n kafka-infra
fi
