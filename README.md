# 🏗️ Appointment System Infra

Repositorio de infraestructura encargado de levantar todo el ecosistema del sistema de citas de fisioterapia basado en microservicios.

Incluye:

- Kafka + Zookeeper
- Schema Registry
- Kafka Control Center
- PostgreSQL
- Auth Service
- Appointment Service

---

## ▶️ Ejecución del sistema

Este proyecto cuenta con scripts automatizados para levantar y detener toda la infraestructura con un solo comando.

---

## 🚀 Levantar sistema

### Windows

Ejecutar:

    start-all.bat

### Linux / Mac

Dar permisos y ejecutar:

    chmod +x start-all.sh
    ./start-all.sh

---

## 🛑 Detener sistema

### Windows

Ejecutar:

    stop-all.bat

### Linux / Mac

Dar permisos y ejecutar:

    chmod +x stop-all.sh
    ./stop-all.sh

---

## 🔧 ¿Qué hace cada script?

### start-all

- Crea la red Docker `appointment-net`.
- Levanta todos los servicios:
  - Kafka + Zookeeper
  - PostgreSQL
  - Auth Service
  - Appointment Service
- Espera la inicialización de Kafka.
- Crea automáticamente el topic `appointment-events`.

### stop-all

- Detiene todos los contenedores.
- Elimina los contenedores creados.
- Limpia los datos de ZooKeeper para prevenir errores de Kafka.
- Elimina la red Docker `appointment-net`.

---

## ⚙️ Requisitos

- Docker instalado
- Docker Compose habilitado

Puertos necesarios:

- 8081 → Auth Service
- 8082 → Appointment Service
- 9021 → Kafka Control Center
- 19092 → Kafka Broker
- 8085 → Schema Registry

---

## 🌐 Accesos del sistema

Una vez levantado el sistema:

- Auth Service: http://localhost:8081/q/swagger-ui
- Appointment Service: http://localhost:8082/q/swagger-ui
- Kafka Control Center: http://localhost:9021
- Schema Registry: http://localhost:8085

---

## 🔄 Flujo del sistema

    Paciente → Auth Service (login)
             → Appointment Service
             → Kafka (appointment-events)
             → Procesamiento de eventos

---

## 🧠 Notas importantes

- Se utiliza una red Docker llamada `appointment-net`.
- El topic Kafka se crea automáticamente.
- Los scripts `.bat` son para Windows.
- Los scripts `.sh` son para Linux/Mac.
- Ambos scripts realizan exactamente las mismas acciones.
- Se limpia ZooKeeper para evitar conflictos en Kafka.

---

## 👨‍💻 Autor

Proyecto desarrollado como parte de una arquitectura de microservicios orientada a eventos utilizando Kafka, Avro y Quarkus.
