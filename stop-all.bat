@echo off

echo.
echo ###########################################################
echo Eliminando contenedores del sistema
echo ###########################################################

docker compose -f 01-kafka-server.yml -f 02-postgres.yml -f 03-auth-profile.yml -f 04-appointment-management.yml -p appointment-app down

echo.
echo ###########################################################
echo Forzando eliminacion de contenedores si quedaron activos
echo ###########################################################

docker rm -f api-appointment-management-v1 api-auth-profile-v1 pg-appointments kafka-broker-1 zookeeper schema-registry control-center 2>nul

echo.
echo ###########################################################
echo Limpiando datos de ZooKeeper
echo ###########################################################

rmdir /s /q .\zoo\data 2>nul
rmdir /s /q .\zoo\log 2>nul

mkdir .\zoo\data
mkdir .\zoo\log

echo.
echo ###########################################################
echo Eliminando red appointment-net
echo ###########################################################

docker network rm appointment-net 2>nul

echo.
echo Sistema detenido y limpio
pause