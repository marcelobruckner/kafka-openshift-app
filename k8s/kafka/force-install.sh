#!/bin/bash

echo "1. Status atual do CSV:"
oc get csv -n kafka-infra -o jsonpath='{.items[0].status.phase}'
echo ""

echo "2. Deletando tudo e reinstalando..."
oc delete subscription amq-streams -n kafka-infra
oc delete csv --all -n kafka-infra
oc delete operatorgroup --all -n kafka-infra
sleep 10

echo "3. Recriando com installPlanApproval manual..."
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: kafka-infra-operator-group
  namespace: kafka-infra
spec:
  targetNamespaces:
  - kafka-infra
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: amq-streams
  namespace: kafka-infra
spec:
  channel: stable
  name: amq-streams
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
  startingCSV: amqstreams.v3.0.1-7
EOF

echo ""
echo "4. Aguardando 30 segundos..."
sleep 30

echo "5. Verificando pods:"
oc get pods -n kafka-infra

echo ""
echo "6. Verificando CSV:"
oc get csv -n kafka-infra
