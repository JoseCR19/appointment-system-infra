#!/bin/bash

echo ""
echo "###########################################################"
echo "Deteniendo sistema"
echo "###########################################################"

docker compose -f 01-kafka-server.yml -f 02-postgres.yml -f 03-auth-profile.yml -f 04-appointment-management.yml -p appointment-app down

echo ""
echo "###########################################################"
echo "Forzando eliminacion de contenedores si quedaron activos"
echo "###########################################################"

docker rm -f api-appointment-management-v1 api-auth-profile-v1 pg-appointments kafka-broker-1 zookeeper schema-registry control-center 2>/dev/null || true

echo ""
echo "###########################################################"
echo "Limpiando datos de ZooKeeper"
echo "###########################################################"

rm -rf ./zoo/data
rm -rf ./zoo/log

mkdir -p ./zoo/data
mkdir -p ./zoo/log

echo ""
echo "###########################################################"
echo "Eliminando red appointment-net"
echo "###########################################################"

docker network rm appointment-net 2>/dev/null || true

echo ""
echo "Sistema detenido y limpio"