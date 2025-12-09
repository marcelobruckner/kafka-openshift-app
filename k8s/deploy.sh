#!/bin/bash

PROJECT_NAME="kafka-app"

# Criar project no OpenShift
echo "Criando project ${PROJECT_NAME}..."
oc new-project ${PROJECT_NAME} || oc project ${PROJECT_NAME}

# Aplicar manifestos
echo "Aplicando manifestos..."
oc apply -f configmap.yaml
oc apply -f secret.yaml
oc apply -f deployment.yaml
oc apply -f service.yaml
oc apply -f route.yaml

# Verificar status
echo "Verificando pods..."
oc get pods

echo "Deploy concluído!"
