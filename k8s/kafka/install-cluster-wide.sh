#!/bin/bash

echo "Limpando instalação anterior..."
oc delete subscription amq-streams -n kafka-infra 2>/dev/null
oc delete operatorgroup kafka-infra-operator-group -n kafka-infra 2>/dev/null
oc delete csv amqstreams.v3.0.1-7 -n kafka-infra 2>/dev/null

echo "Instalando operator cluster-wide..."
oc apply -f amq-streams-operator.yaml

echo "Aguardando operator..."
sleep 45

echo "Pods do operator:"
oc get pods -n openshift-operators | grep amq-streams

echo ""
echo "Criando cluster Kafka..."
oc apply -f kafka-cluster.yaml
oc apply -f kafka-user-topic.yaml

echo ""
echo "Aguardando cluster (5 min)..."
oc wait kafka/my-cluster --for=condition=Ready --timeout=600s -n kafka-infra 2>/dev/null || echo "Aguarde mais tempo..."

echo ""
oc get pods -n kafka-infra
