#!/bin/bash
timestamp=$(date +"%Y%m%d-%H%M%S")
label=build-fs
filename="$label-$timestamp"
user_name=$(wslvar USERNAME)

docker_vols=$(docker volume ls -q)
sudo tee $filename.sh >/dev/null <<'TXT'
#               ___________________________________________________                 #
#               ||||               Executing ...               ||||                 #
#               -------------------------------------------------                   #
                    docker compose down                                 
                    docker volume rm $docker_vols 
                    docker compose build gui-kernel                                        
                    # docker compose build --no-cache gui-kernel                  
                    # docker compose up gui-kernel                      
#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
TXT
# copy the command to the log first
cat $filename.sh 2>&1 | sudo tee --append $filename.log
# execute .sh file && log all output
sudo sh $filename.sh | sudo tee --append $filename.log

# docker builder prune -af --volumes
# docker system prune -af --volumes
