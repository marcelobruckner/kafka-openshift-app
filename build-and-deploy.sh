#!/bin/bash

echo "=== Build e Deploy da Aplicação ==="

# 1. Criar projeto da aplicação
oc new-project kafka-app || oc project kafka-app

# 2. Criar build usando S2I Java
echo "Criando build S2I..."
oc new-build java:openjdk-17-ubi8~. --name=kafka-app --binary=true

# 3. Fazer build da aplicação
echo "Fazendo build..."
oc start-build kafka-app --from-dir=. --follow

# 4. Aplicar configurações
echo "Aplicando configurações..."
oc apply -f k8s/configmap.yaml
oc apply -f k8s/secret.yaml

# 5. Criar deployment
echo "Criando deployment..."
oc new-app kafka-app --name=kafka-app
oc patch deployment kafka-app --patch='{"spec":{"template":{"spec":{"containers":[{"name":"kafka-app","envFrom":[{"configMapRef":{"name":"kafka-app-config"}},{"secretRef":{"name":"kafka-app-secret"}}]}]}}}}'

# 6. Expor serviço
echo "Expondo serviço..."
oc expose service kafka-app

# 7. Verificar status
echo "Status:"
oc get pods
oc get route

echo "Build e deploy concluídos!"