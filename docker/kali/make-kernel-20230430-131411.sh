#               ___________________________________________________                 #
#               ||||               Executing ...               ||||                 #
#               -------------------------------------------------                   #
# docker buildx build --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar.gz --build-arg KERNEL_TYPE=stable --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= .
docker buildx build --target dvlp_kernel-output --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar.gz --build-arg KERNEL_TYPE=stable --build-arg REFRESH_REPO=yes --build-arg CONFIG_FILE= .
# docker buildx build --target dvlp_kernel-output --no-cache --output type=local,dest=/mnt/c/users/${user_name:-default}/$filename.tar.gz --build-arg KERNEL_TYPE=stable --build-arg REFRESH_REPO=y --build-arg CONFIG_FILE= .
# docker buildx build --target dvlp_kernel-output --no-cache --output type=local --build-arg KERNEL_TYPE=stable --build-arg REFRESH_REPO=y --build-arg CONFIG_FILE= .

#                -----------------------------------------------                    #
#               |||||||||||||||||||||||||||||||||||||||||||||||||                   #
#               __________________________________________________                  #
