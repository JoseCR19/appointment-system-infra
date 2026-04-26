@echo off

echo.
echo ########################################################################
echo Creacion de la red para todos los contenedores "appointment-net"
echo ########################################################################

docker network create --driver=bridge appointment-net

echo.
echo ###########################################################
echo Levantando infraestructura (Kafka + DB + Auth + Appointment)
echo ###########################################################

docker compose -f 01-kafka-server.yml -f 02-postgres.yml -f 03-auth-profile.yml -f 04-appointment-management.yml -p appointment-app up -d

echo.
echo ###########################################################
echo Esperando que Kafka levante...
echo ###########################################################

timeout /t 10 > nul

echo.
echo ###########################################################
echo Creacion del topic Kafka
echo ###########################################################

docker exec -it kafka-broker-1 kafka-topics --bootstrap-server localhost:19092 --if-not-exists --create --topic appointment-events --partitions 1 --replication-factor 1

echo.
echo ###########################################################
echo Verificando topics creados
echo ###########################################################

docker exec -it kafka-broker-1 kafka-topics --bootstrap-server localhost:19092 --list

echo.
echo ###########################################################
echo SISTEMA LEVANTADO CORRECTAMENTE
echo ###########################################################

echo.
echo Swagger Appointment:
echo http://localhost:8082/q/swagger-ui

echo.
echo Swagger Auth:
echo http://localhost:8081/q/swagger-ui

echo.
echo Kafka Control Center:
echo http://localhost:9021

echo.
pause