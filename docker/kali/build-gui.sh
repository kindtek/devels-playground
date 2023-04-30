#!/bin/bash
timestamp=$(date +"%Y%m%d-%H%M%S")
label=build-fs
filename="$label-$timestamp"
user_name=$1

docker_vols=$(docker volume ls -q)
sudo tee "$filename.sh" >/dev/null <<'TXT'
#               ___________________________________________________                 #
#               ||||               Executing ...               ||||                 #
#               -------------------------------------------------                   #
                    docker compose down                                 
                    docker volume rm $(docker volume ls -q) 
                    docker compose build gui                                        
                    # docker compose build --no-cache gui                  
                    # docker compose up gui --detach
                    # docker compose exec gui bash                      
#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
TXT
# copy the command to the log first
cat "$filename.sh" 2>&1 | sudo tee --append "$filename.log"
# execute .sh file && log all output
sudo sh "$filename.sh" | sudo tee --append "$filename.log"

# docker builder prune -af --volumes
# docker system prune -af --volumes
