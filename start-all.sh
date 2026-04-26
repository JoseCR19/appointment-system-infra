#!/bin/bash

echo ""
echo "########################################################################"
echo "Creando red appointment-net"
echo "########################################################################"

docker network create appointment-net 2>/dev/null || true

echo ""
echo "###########################################################"
echo "Levantando infraestructura"
echo "###########################################################"

docker compose -f 01-kafka-server.yml -f 02-postgres.yml -f 03-auth-profile.yml -f 04-appointment-management.yml -p appointment-app up -d

echo ""
echo "Esperando Kafka..."
sleep 15

echo ""
echo "###########################################################"
echo "Creando topic Kafka"
echo "###########################################################"

docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:19092 --if-not-exists --create --topic appointment-events --partitions 1 --replication-factor 1

echo ""
echo "###########################################################"
echo "Topics disponibles"
echo "###########################################################"

docker exec kafka-broker-1 kafka-topics --bootstrap-server localhost:19092 --list

echo ""
echo "Sistema levantado correctamente"
echo ""
echo "Swagger Auth:        http://localhost:8081/q/swagger-ui"
echo "Swagger Appointment: http://localhost:8082/q/swagger-ui"
echo "Kafka Control:       http://localhost:9021"
echo "Schema Registry:     http://localhost:8085"