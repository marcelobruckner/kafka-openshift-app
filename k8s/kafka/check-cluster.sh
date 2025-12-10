#!/bin/bash

echo "=== Status do Cluster Kafka ==="

echo "1. Status do recurso Kafka:"
oc get kafka my-cluster -n kafka-infra -o jsonpath='{.status.conditions}' | jq .

echo ""
echo "2. Logs do operator (últimas 50 linhas):"
oc logs -n openshift-operators deployment/amq-streams-cluster-operator-v3.0.1-7 --tail=50

echo ""
echo "3. Eventos no namespace kafka-infra:"
oc get events -n kafka-infra --sort-by='.lastTimestamp' | tail -20

echo ""
echo "4. Describe do cluster:"
oc describe kafka my-cluster -n kafka-infra | tail -30