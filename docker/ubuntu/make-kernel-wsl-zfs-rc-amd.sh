sudo docker buildx build \
--target dvlp_kernel-output \
--output type=local,dest=/mnt/c/users/n8kin/kindtek-wsl-zfs-linux-kernel-$(date +"%Y%m%d-%H%M%S").tar \
--build-arg KERNEL_TYPE=latest-rc-wsl-zfs \
--build-arg REFRESH_REPO=yes" \
--build-arg CONFIG_FILE= \
 . 2>&1 | \
    sudo tee rc-wsl-zfs-kernel-builder"$(date)".log 

echo 'sudo docker buildx build -t dvlp_kernel-output --output type=local,dest=/mnt/c/users/n8kin/kindtek-wsl-zfs-linux-kernel-$(date +"%Y%m%d-%H%M%S").tar 
    --build-arg KERNEL_TYPE=latest-rc-wsl-zfs --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= | sudo tee rc-wsl-zfs-kernel-builder"$(date)".log' \
| sudo tee rc-wsl-zfs-kernel-builder"$(date)".log 