#!/bin/bash
timestamp=$(date -d "today" +"%Y%m%d%H%M%S")
label=make-kernel
win_user=$1
kernel_type=$2
kernel_feature=$3
config_file=${4}
filename="$label${kernel_type:+-$kernel_type}${kernel_feature:+-$kernel_feature}-$timestamp"

while [ "$win_user" = "" ] || [ ! -d "/mnt/c/users/$win_user" ]; do
    echo "


    install to which Windows home directory?

        C:\\users\\__________

        choose from:
    " 
    ls -da /mnt/c/users/*/ | tail -n +4 | sed -r -e 's/^\/mnt\/c\/users\/([ A-Za-z0-9]*)*\/+$/\t\1/g'
    read -r -p "
" win_user
done

# log save location 
mkdir -p logs
tee "logs/$filename.sh" >/dev/null <<'TXT'
#!/bin/bash
set -x
win_user=${1}
kernel_type=${2:-basic}
kernel_feature=${3}
config_file=${4}
build_cache=${4:+' --no-cache'}
timestamp=${5}
#               _________________________________________________                 #
#                |||| |           Executing ...           | ||||                  #
#              ---------------------------------------------------                #
#
                    docker buildx build ${build_cache} \
                    --target dvlp_kernel-kache \
                    --output type=local,dest=/mnt/c/users/"${win_user}"/kache \
                    --build-arg KERNEL_TYPE="${kernel_type}" \
                    --build-arg KERNEL_FEATURE="${kernel_feature}" \
                    --build-arg WIN_USER="${win_user}" \
                    --build-arg CONFIG_FILE="${config_file}" \
                    --build-arg DOCKER_BUILD_TIMESTAMP="${timestamp}" \
                    --progress=plain \
                    . 2>&1 || exit<<'comment'
                    echo 'docker failed to start'
                    # --no-cache-filter=dvlp_repo-build \
                    # --no-cache-filter=dvlp_repo-build-kernel \
comment
# 
#                -----------------------------------------------                   #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                  #
#              ___________________________________________________                 #
TXT

# copy the command to the log first
eval cat "logs/$filename.sh" 2>&1 | tee --append "logs/$filename.log" && \
# execute .sh file && log all output
bash "logs/${filename}.sh" "${win_user}" "${kernel_type}" "${kernel_feature}" "${config_file}" "${timestamp}"  2>&1 | tee --append "logs/${filename}.log" && \
# prompt to install newly built kernel
bash ../../kernels/linux/install-kernel.sh "$win_user" "latest" 2>&1 | tee --append "logs/$filename.log" || exit