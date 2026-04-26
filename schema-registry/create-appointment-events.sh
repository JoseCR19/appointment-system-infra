#!/bin/bash

SCHEMA_REGISTRY_URL="http://localhost:8085"
TOPIC_NAME="appointment-events"
SUBJECT_NAME="${TOPIC_NAME}-value"
SCHEMA_FILE="AppointmentEvent.avsc"

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "❌ Error: No se encontró el archivo $SCHEMA_FILE"
  exit 1
fi

echo "📤 Registrando esquema para '$SUBJECT_NAME' en $SCHEMA_REGISTRY_URL..."

SCHEMA_CONTENT=$(python -c "import json; print(json.dumps(open('$SCHEMA_FILE').read()))")

curl -X POST "${SCHEMA_REGISTRY_URL}/subjects/${SUBJECT_NAME}/versions" \
  -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  -d "{\"schema\":$SCHEMA_CONTENT}"

echo -e "\n✅ Registro completado."