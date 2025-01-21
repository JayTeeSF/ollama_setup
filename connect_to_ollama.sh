#!/bin/bash

# Services and compose files
SERVICE="ollama"
COMPOSE_FILES="-f docker-compose.ollama.yml -f docker-compose.open_web_ui.yml"

# Max retries and sleep duration
MAX_RETRIES=3
SLEEP_DURATION=10

# Check health status
check_health() {
  docker inspect -f '{{json .State.Health.Status}}' "${SERVICE}_setup-${SERVICE}-1" 2>/dev/null | grep -q '"healthy"'
}

# Retry logic
for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "Checking health status of the ${SERVICE} container (Attempt $i/$MAX_RETRIES)..."
  if check_health; then
    echo "${SERVICE} is healthy. Connecting..."
    docker-compose $COMPOSE_FILES exec "$SERVICE" /bin/bash
    exit 0
  fi
  echo "Container is not healthy. Retrying in $SLEEP_DURATION seconds..."
  sleep $SLEEP_DURATION
done

echo "Failed to connect: ${SERVICE} container is not healthy after $MAX_RETRIES attempts."
exit 1
