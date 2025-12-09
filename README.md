# Aplicação Java com Kafka no OpenShift

Aplicação Spring Boot que produz e consome mensagens do Kafka rodando no OpenShift.

## Estrutura

```
kafka-openshift-app/
├── src/main/java/com/kafka/
│   ├── config/          # Configuração do Kafka
│   ├── controller/      # REST API
│   ├── producer/        # Producer Kafka
│   ├── consumer/        # Consumer Kafka
│   └── model/           # Modelos de dados
├── k8s/                 # Manifests OpenShift
└── Dockerfile
```

## Como usar

### 1. Build local

```bash
mvn clean package
java -jar target/kafka-openshift-app-1.0.0.jar
```

### 2. Build Docker

```bash
docker build -t kafka-openshift-app:latest .
```

### 3. Deploy no OpenShift

```bash
# Criar recursos
oc apply -f k8s/configmap.yaml
oc apply -f k8s/secret.yaml
oc apply -f k8s/deployment.yaml
oc apply -f k8s/service.yaml
oc apply -f k8s/route.yaml

# Verificar
oc get pods
oc logs -f deployment/kafka-app
```

### 4. Testar a aplicação

```bash
# Enviar mensagem
curl -X POST http://kafka-app-route-default.apps.cluster.com/api/mensagens \
  -H "Content-Type: application/json" \
  -d '{"conteudo": "Minha primeira mensagem"}'

# Health check
curl http://kafka-app-route-default.apps.cluster.com/api/mensagens/health
```

## Configuração do Kafka

Edite o `k8s/configmap.yaml` com os dados do seu cluster Kafka:

- **KAFKA_BOOTSTRAP_SERVERS**: Endereço do Kafka (ex: my-cluster-kafka-bootstrap:9093)
- **KAFKA_CONSUMER_GROUP**: Nome do grupo de consumidores
- **KAFKA_SECURITY_PROTOCOL**: SASL_SSL ou PLAINTEXT
- **KAFKA_SASL_MECHANISM**: SCRAM-SHA-512 ou PLAIN

Edite o `k8s/secret.yaml` com suas credenciais:

- **username**: Usuário do Kafka
- **password**: Senha do Kafka

## Endpoints

- `POST /api/mensagens` - Envia mensagem para o Kafka
- `GET /api/mensagens/health` - Health check
- `GET /actuator/health` - Health do Spring Boot

## Logs

```bash
# Ver logs da aplicação
oc logs -f deployment/kafka-app

# Ver logs do Kafka
oc logs -f my-cluster-kafka-0
```