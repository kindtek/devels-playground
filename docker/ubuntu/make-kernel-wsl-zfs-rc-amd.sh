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
# sudo docker buildx build --target dvlp_kernel-kache --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar --build-arg KERNEL_TYPE=stable-wsl-zfs --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= .
sudo docker buildx build --target dvlp_kernel-kache --no-cache --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar --build-arg KERNEL_TYPE=stable-wsl-zfs --build-arg REFRESH_REPO=y --build-arg CONFIG_FILE= .

#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
TXT
# copy the command to the log first
cat $filename.sh 2>&1 | sudo tee --append $filename.log
# execute .sh file && log all output
sudo sh $filename.sh | sudo tee --append $filename.log

# timestamp=$(date +"%Y%m%d-%H%M%S")
# label=rc-wsl-zfs-kernel-builder
# filename="$label-$timestamp.log"
# user_name=$(wslvar USERNAME)
# command_string=sudo docker buildx build \
# --target dvlp_kernel-kache \
# --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar \
# --build-arg KERNEL_TYPE=latest-rc-wsl-zfs \
# --build-arg REFRESH_REPO=yes \
# --build-arg CONFIG_FILE= \
#  . 2>&1 | sudo tee --append $filename
# cd /home/dvl/dvlw/dvlp/docker/ubuntu
# echo $($command_string) | sudo tee --append $filename
# echo $command_string | sudo tee --append $filename

# | sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log

# sudo docker buildx build --target dvlp_kernel-kache --output type=local,dest=/mnt/c/users/n8kin/kindtek-wsl-zfs-linux-kernel-$timestamp.tar --build-arg KERNEL_TYPE=latest-rc-wsl-zfs --build-arg REFRESH_REPO=true --build-arg CONFIG_FILE=  --no-cache .  2>&1 |     sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log
