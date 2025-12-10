#!/bin/bash

PROJECT_NAME="kafka-app"

# Criar project no OpenShift
echo "Criando project ${PROJECT_NAME}..."
oc new-project ${PROJECT_NAME} || oc project ${PROJECT_NAME}

# Verificar se a imagem existe
echo "Verificando imagem..."
oc get is kafka-app 2>/dev/null || {
  echo "❌ Imagem não encontrada! Execute primeiro:"
  echo "   cd .. && ./build-and-deploy.sh"
  exit 1
}

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
