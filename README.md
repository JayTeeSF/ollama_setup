# ollama_setup

if you have docker and docker-compose on your (unix-based) system (you don't have to use Docker Desktop either, you can use lots of alternatives: podman, etc)
then you can simply type:
./run.sh


# fix password auth issues:
./connect_to_open_web.sh 

sqlite3 data/webui.db

DELETE FROM auth;
.exit

./stop_containers.sh 
./run.sh 
# wait till status moves from:
# Up 2 seconds (health: starting) 
# to
# Up 3 minutes (healthy) 

