#!/bin/bash
timestamp=$(date +"%Y%m%d-%H%M%S")
label=make-kernel
filename="$label-${timestamp}"
username=$1
kernel_type=$2
kernel_feature=$3
build_cache=${4:+' --no-cache '}

while [ ! -d "/mnt/c/users/$username" ]; do
    echo " 


    install to which Windows home directory?

        C:\\users\\__________ 

        choose from:
    " 
    ls -da /mnt/c/users/*/ | tail -n +4 | sed -r -e 's/^\/mnt\/c\/users\/([ A-Za-z0-9]*)*\/+$/\t\1/g'
    read -r -p "
" username
done

# docker_vols=$(docker volume ls -q)
tee "$filename.sh" >/dev/null <<'TXT'
#!/bin/bash
timestamp=${1}
label=make-kernel
filename="$label-$timestamp"
username=${2}
echo "username = $username"
kernel_type=${3:-basic}
echo "kernel_type = $kernel_type"
kernel_feature=${4}
echo "kernel_feature = $kernel_feature"
cache=${5:+' --no-cache'}
echo "cache = $cache"
docker_vols=$(docker volume ls -q)
#               ___________________________________________________                 #
#               ||||               Executing ...               ||||                 #
#                -------------------------------------------------                  #
#
                    docker buildx build ${cache} \
                    --target dvlp_kernel-output \
                    --output type=local,dest=/mnt/c/users/"${username}"/k-cache \
                    --build-arg KERNEL_TYPE=${kernel_type} \
                    --build-arg KERNEL_FEATURE=${kernel_feature} \
                    --build-arg REFRESH_REPO=yes \
                    --build-arg CONFIG_FILE= \
                    . 2>&1
# 
#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
TXT
# copy the command to the log first
eval cat "$filename.sh" 2>&1 | tee --append "$filename.log"
# execute .sh file && log all output
bash "${filename}.sh" "${timestamp}" "${username}" "${kernel_type}" "${kernel_feature}" "${build_cache}" | tee --append "${filename}.log"
# prompt to install newly built kernel
# bash ../../kernels/linux/install-kernel.sh "$username" latest
