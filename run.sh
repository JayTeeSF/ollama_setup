OLLAMA_MODEL="$1"
# OLLAMA_MODEL="llama3.2" #deepseek-r1"
if [ -z "$OLLAMA_MODEL" ]; then
  OLLAMA_MODEL="llama3.2"
  echo "Usage: $0 <model: ${OLLAMA_MODEL} || deepseek-r1>"
  # exit 1
fi
export OLLAMA_MODEL
docker-compose -f docker-compose.ollama.yml -f docker-compose.open_web_ui.yml up -d
