#!/bin/bash
timestamp=$(date +"%Y%m%d-%H%M%S")
label=make-kernel
filename="$label-${1:-$timestamp}"
username=${2}
# docker_vols=$(docker volume ls -q)
tee "$filename.sh" >/dev/null <<'TXT'
#!/bin/bash
timestamp=${1}
label=make-kernel
filename="$label-${1:-timestamp}"
username=${2}
docker_vols=$(docker volume ls -q)
#               ___________________________________________________                 #
#               ||||               Executing ...               ||||                 #
#                -------------------------------------------------                   #
# docker buildx build --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/"${username:-$2}"/k-cache/kernels/linux --build-arg KERNEL_TYPE=basic --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= . 2>&1
# no-cache
docker buildx build --no-cache --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/"${username:-$2}"/k-cache/kernels/linux --build-arg KERNEL_TYPE=basic --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= . 2>&1
cp -fv /mnt/c/users/$username/k-cache/kernels/linux/$(../../kernels/linux/build-import-kernel.sh basic get-package).tar.gz /mnt/c/users/$username/k-cache
cd /mnt/c/users/$username/k-cache || exit
tar -xvzf $(kernels/linux/build-import-kernel.sh basic get-package).tar.gz
# 
#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
TXT
# copy the command to the log first
eval cat "$filename.sh" 2>&1 | tee --append "$filename.log"
# execute .sh file && log all output
sh "$filename.sh" "$timestamp" "$username" | tee --append "$filename.log"

# bash "$filename.sh" "$username" | tee --append "$filename.log"

# timestamp=$(date +"%Y%m%d-%H%M%S")
# label=rc-wsl-zfs-kernel-builder
# filename="$label-$timestamp.log"
# username=$(wslvar USERNAME)
# command_string=sudo docker buildx build \
# --target dvlp_kernel-output \
# --output type=local,dest=/mnt/c/users/${username:-default}/$filename.tar \
# --build-arg KERNEL_TYPE=latest-rc-wsl-zfs \
# --build-arg REFRESH_REPO=yes \
# --build-arg CONFIG_FILE= \
#  . 2>&1 | sudo tee --append $filename
# cd /home/dvl/dvlw/dvlp/docker/ubuntu
# echo $($command_string) | sudo tee --append $filename
# echo $command_string | sudo tee --append $filename

# | sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log

# sudo docker buildx build --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/n8kin/kindtek-wsl-zfs-linux-kernel-$timestamp.tar --build-arg KERNEL_TYPE=latest-rc-wsl-zfs --build-arg REFRESH_REPO=true --build-arg CONFIG_FILE=  --no-cache .  2>&1 |     sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log
