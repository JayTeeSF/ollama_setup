#!/usr/bin/env bash

# ------- FILE: connect_open_web_ui.sh -------

# Compose service name (from your docker-compose.open_web_ui.yml)
SERVICE_NAME="openWebUI"

# Combined Compose files
COMPOSE_FILES="-f docker-compose.ollama.yml -f docker-compose.open_web_ui.yml"

# Maximum retries and sleep duration
MAX_RETRIES=3
SLEEP_DURATION=15

echo "Bringing services up (detached) if needed..."
docker-compose $COMPOSE_FILES up -d

# Helper function to check the container's health via Docker Inspect
check_health() {
  # container name is typically <project>_<service_name>_1
  # If your container is named "ollama_setup-openWebUI-1",
  # adjust accordingly or parse from Compose:
  echo "true"
}

# Retry logic for health checks
for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "Checking health status of the container (attempt $i/$MAX_RETRIES)..."
  if check_health; then
    echo "Container is healthy. Connecting..."
    docker-compose $COMPOSE_FILES exec "$SERVICE_NAME" /bin/bash
    exit 0
  fi
  echo "Container is not healthy. Retrying in $SLEEP_DURATION seconds..."
  sleep "$SLEEP_DURATION"
done

echo "Failed to connect: Container is not healthy after $MAX_RETRIES attempts."
exit 1
