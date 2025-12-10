#!/bin/bash

echo "=== Debug detalhado do Operator ==="

echo "1. CSV completo:"
oc get csv amqstreams.v3.0.1-7 -n kafka-infra -o yaml | grep -A 20 "status:"

echo ""
echo "2. Deployments no namespace:"
oc get deployments -n kafka-infra

echo ""
echo "3. ReplicaSets no namespace:"
oc get replicasets -n kafka-infra

echo ""
echo "4. Eventos do namespace:"
oc get events -n kafka-infra --sort-by='.lastTimestamp'

echo ""
echo "5. Describe do CSV:"
oc describe csv amqstreams.v3.0.1-7 -n kafka-infra | tail -30
