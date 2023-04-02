timestamp=$(date +"%Y%m%d-%H%M%S")
label=rc-wsl-zfs-kernel-builder
filename="$label-$timestamp.log"
user_name=$(wslvar USERNAME)
command_string=sudo docker buildx build \
--target dvlp_kernel-output \
--output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar \
--build-arg KERNEL_TYPE=latest-rc-wsl-zfs \
--build-arg REFRESH_REPO=yes \
--build-arg CONFIG_FILE= \
 . 2>&1 | sudo tee $filename
echo $command_string | sudo tee $filename
echo $($command_string)

 
# | sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log 



# sudo docker buildx build --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/n8kin/kindtek-wsl-zfs-linux-kernel-$timestamp.tar --build-arg KERNEL_TYPE=latest-rc-wsl-zfs --build-arg REFRESH_REPO=true --build-arg CONFIG_FILE=  --no-cache .  2>&1 |     sudo tee rc-wsl-zfs-kernel-builder"$timestamp".log  