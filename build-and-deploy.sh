#!/bin/bash

echo "=== Build e Deploy da Aplicação ==="

# 1. Criar projeto da aplicação
oc new-project kafka-app || oc project kafka-app

# 2. Deletar build anterior se existir
oc delete bc kafka-app 2>/dev/null || true
oc delete is kafka-app 2>/dev/null || true

# 3. Criar build usando S2I Java
echo "Criando build S2I..."
oc new-build java:openjdk-17-ubi8 --name=kafka-app --binary=true

# 4. Fazer build da aplicação
echo "Fazendo build..."
oc start-build kafka-app --from-dir=. --follow

# 5. Aplicar configurações
echo "Aplicando configurações..."
oc apply -f k8s/configmap.yaml
oc apply -f k8s/secret.yaml

# 6. Aguardar build completar
echo "Aguardando build..."
sleep 30

# 7. Criar deployment
echo "Criando deployment..."
oc new-app kafka-app:latest --name=kafka-app
oc set env deployment/kafka-app --from=configmap/kafka-app-config
oc set env deployment/kafka-app --from=secret/kafka-app-secret

# 8. Expor serviço
echo "Expondo serviço..."
oc expose service kafka-app

# 9. Verificar status
echo "Status:"
oc get pods
oc get route

echo "Build e deploy concluídos!"