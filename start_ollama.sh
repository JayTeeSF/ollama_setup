#!/bin/sh

# Start the Ollama service in the background
ollama serve &

# Wait for the server to start
echo "Waiting for Ollama server to start..."
until curl -s http://ollama:11434/ > /dev/null; do
  sleep 1
done

# Check if the model exists before pulling
echo "Checking if model $OLLAMA_MODEL is already available..."
if ! ollama list | grep -q "$OLLAMA_MODEL"; then
  echo "Model not found locally, pulling $OLLAMA_MODEL..."
  ollama pull "$OLLAMA_MODEL"
else
  echo "Model $OLLAMA_MODEL is already available, skipping pull."
fi

# Keep the script running to prevent the container from exiting
wait
