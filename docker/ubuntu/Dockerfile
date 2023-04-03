#syntax=docker/dockerfile:experimental
# to build and run an individual service with args (ie git):
## `docker compose build git --build-arg REFRESH_REPO=true && docker compose up git`
# to build everything:
## `docker compose build && docker compose up`
# to remove all volumes:
## docker compose down && docker volume rm $(docker volume ls -q)
ARG CONFIG_FILE=${CONFIG_FILE}
ARG KERNEL_TYPE=${KERNEL_TYPE:-basic-wsl}
ARG DEBIAN_FRONTEND=noninteractive
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ARG DOCKER_BUILDKIT=1
ARG _AGL_USR=${_AGL_USR:-agl}
ARG _DVL_USR=${_DVL_USR:-dvl}



# dvl permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_devel
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /hell
RUN mkdir -pv /home/dvl && mkdir -pv /hel && mkdir -pv /hell && mkdir -pv ${mnt_data}/bak/dvl && \
    chmod 753 ${mnt_data}/bak/dvl && \
    ln -fsv ${mnt_data}/bak/dvl /home/dvl/bak 
# RUN install --verbose  -d /home/dvl && \
# install --verbose  -d /hel && \
# install --verbose  -d /hell && \
# install --verbose  -m 753 -d ${mnt_data}/bak/dvl && \
# ln -fsv ${mnt_data}/bak/dvl /home/dvl/bak 
WORKDIR /

# agl permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_angel
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /halo
RUN mkdir -pv /home/agl && mkdir -pv /halo && mkdir -pv /hal/halo && mkdir -pv ${mnt_data}/bak/agl && \
    chmod 753 ${mnt_data}/bak/agl
# RUN install --verbose -d /home/agl && \
#     install --verbose -d /halo  && \
#     install --verbose -d /hal/halo  && \
#     install --verbose -m 753 -d ${mnt_data}/bak/agl && \
#     ln -fsv ${mnt_data}/bak/agl /home/agl/bak


# good permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_good
USER root
WORKDIR /rootg
ARG mnt_data=${mnt_data:-/mnt/data}
RUN mkdir -pv /home/good && mkdir -pv /rootg && mkdir -pv /dls && mkdir -pv /fs
# RUN install --verbose -d /root && \
#     install --verbose -d /home/good && \
#     install --verbose -d /rootg && \
#     install --verbose -d /dls && \
#     install --verbose -d /fs
# && \
# install -o agl -g halo -d halo && \
# install -o dvl -g hell -d hell 
# && \
#     ln -sv /home/good/bak /mnt/data/bak 

FROM ubuntu:latest AS dvlp_base-fs_devel-lite
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /hel
# RUN install -o dvl -g hell -d /home/dvl /hel /hell && \
# ln -fsv /home/dvl /hel && \
# ln -fsv /home/dvl /hell && \
# ln -sfv /home/dvl /home/dvl && \
RUN mkdir -pv /hel && ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

FROM ubuntu:latest AS dvlp_base-fs_angel-lite
WORKDIR /hal
RUN mkdir -pv /hal && ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /
# ln -fsv /home/agl /halo && \

FROM ubuntu:latest AS dvlp_base-fs_good-lite
WORKDIR /rootg
RUN mkdir -pv /rootg && ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /


# FROM scratch AS dvlp_base-fs_permissions
# #COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./hel ./hel
# COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./hell ./hell
# COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./home ./home
# COPY --from=dvlp_base-fs_devel --chown=agl:hell ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel --chown=agl:halo ./hal ./hal
# COPY --from=dvlp_base-fs_angel --chown=agl:halo ./halo ./halo
# COPY --from=dvlp_base-fs_angel --chown=agl:halo ./home ./home
# COPY --from=dvlp_base-fs_angel --chown=agl:halo ./mnt ./mnt

# COPY --from=dvlp_base-fs_good --chown=good:rootg ./home ./home
# # COPY --from=dvlp_base-fs_good --chown=good:rootg ./root/root ./root/root
# COPY --from=dvlp_base-fs_good --chown=good:rootg ./rootg ./rootg
# COPY --from=dvlp_base-fs_good --chown=good:rootg ./fs ./fs

# FROM scratch AS dvlp_base-fs_permissions-lite
# COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./hel ./hel
# # COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./hell ./hell
# COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./home ./home
# COPY --from=dvlp_base-fs_devel-lite --chown=agl:hell ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./hal ./hal
# # COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./halo ./halo
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./home ./home
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./mnt ./mnt

# COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./home ./home
# # COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./root/root ./root/root
# COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./rootg ./rootg
# # COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./fs ./fs


############################## BASE ####################################
#############
# dvlp_base-fs_fs #
#############
FROM ubuntu:latest AS dvlp_base-fs-lite
ARG CONFIG_FILE
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    # sudo add-apt-repository ppa:apt-fast/stable && \
    rm -rf /etc/skel && \
    apt-get update -y && \
    apt-get upgrade -y && \
    #   apt-get -y install sudo apt-fast
    addgroup --gid 4321 rootg && \
    addgroup --gid 777 halo && \
    addgroup --gid 666 hell && \
    # add just good and agl for now 
    # adduser --home /home/good --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS good && \
    # adduser --home /home/agl --ingroup halo --shell /bin/bash --uid 777 --disabled-password --gecos GECOS agl && \
    # adduser --home /home/dvl --ingroup hell --shell /bin/bash --uid 666 --disabled-password --gecos GECOS dvl && \
    adduser --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS --no-create-home good && \
    adduser --ingroup halo --shell /bin/bash --uid 777  --disabled-password --gecos GECOS --no-create-home agl && \
    adduser --ingroup hell --shell /bin/bash --uid 666  --disabled-password --gecos GECOS --no-create-home dvl && \
    rm -rf /root && \
    # rm -rf /home/good* && rm -rf /root/* && \
    # rm -rf /home/dvl/* && rm -rf /home/agl/* && \
    # add good and agl to the sudo list
    usermod -aG rootg good && \
    # add good to both groups
    usermod -aG halo good && \
    usermod -aG hell good && \
    # ensure no passwords
    passwd -d good && \
    passwd -d agl && \
    passwd -d dvl && \
    passwd -l root && \
    # make dvl default wsl user 
    echo "[user] \
    default=dvl" >> /etc/wsl.conf && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    # apt-get -y install sudo debootstrap && \
    # sudo debootstrap sid chroot && \
    usermod -aG sudo agl && \
    usermod -aG sudo good
# COPY --from=dvlp_base-fs_permissions ./ ./
COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./hel ./hel
COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./hell ./hell
COPY --from=dvlp_base-fs_devel --chown=dvl:hell ./home ./home
COPY --from=dvlp_base-fs_devel --chown=agl:hell ./mnt ./mnt
##############################################################
COPY --from=dvlp_base-fs_angel --chown=agl:halo ./hal ./hal
COPY --from=dvlp_base-fs_angel --chown=agl:halo ./halo ./halo
COPY --from=dvlp_base-fs_angel --chown=agl:halo ./home ./home
COPY --from=dvlp_base-fs_angel --chown=agl:halo ./mnt ./mnt
##############################################################
COPY --from=dvlp_base-fs_good --chown=good:rootg ./home ./home
# COPY --from=dvlp_base-fs_good --chown=good:rootg ./root/root ./root/root
COPY --from=dvlp_base-fs_good --chown=good:rootg ./rootg ./rootg
COPY --from=dvlp_base-fs_good --chown=good:rootg ./fs ./fs
##############################################################
RUN usermod -d /hal agl && \
    usermod -d /hel dvl && \
    mkdir -pv /root/root && chown -R good:rootg /root && \
    usermod -d /root/root good && chown -R good:rootg /root/root

FROM dvlp_base-fs-lite AS dvlp_base-fs
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./hel ./hel
# COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./hell ./hell
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:hell ./home ./home
COPY --from=dvlp_base-fs_devel-lite --chown=agl:hell ./mnt ./mnt

COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./hal ./hal
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./halo ./halo
COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./home ./home
COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo ./mnt ./mnt

COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./home ./home
# COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./root/root ./root/root
COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./rootg ./rootg
# COPY --from=dvlp_base-fs_good-lite --chown=good:rootg ./fs ./fs
# build aliases
# FROM dvlp_base-fs_angel AS dvlp_auser

# FROM dvlp_base-fs_devel AS dvlp_duser

################################### REPO ####################################
#############
# dvlp_repo #
#############
FROM dvlp_base-fs AS dvlp_repo-build
ARG mnt_data=${mnt_data:-/mnt/data}
ARG REFRESH_REPO=${REFRESH_REPO:-no}
USER root
WORKDIR /root
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && apt-get -y install git 
# USER dvl
WORKDIR /hel
# add git cache directory
RUN mkdir -p /tmp/git/cache && \
    chown -R dvl:hell /tmp/git/cache
# add safe directories
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    # if [ "$fresh_repo" != no ]; then rm -rf /tmp/git/cache/dvlw; fi && \
    git config --global --add safe.directory /home/dvl && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /tmp/git/cache && \
    # clone fresh repos and give dvl ownership
    # git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
    git clone https://github.com/kindtek/devels-workshop --filter=blob:limit=1024000 --depth=1 --single-branch --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/dvl/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /hel/dvlw
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --depth=2 --progress || git pull \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/dvl/dvlw/dvlp)
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak
# WORKDIR /hell/dvlw/dvlp
# RUN if [ "$REFRESH_REPO" != no ]; then git pull; fi    
USER dvl
WORKDIR /

FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./hel/dvlw/ ./hel/dvlw/

############################## SKELETON ###################################
########################
# dvlp_skel-build-lite #
########################
FROM dvlp_base-fs-lite AS dvlp_skel-build-lite
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
# COPY --from=dvlp_base-fs ./etc/passwd ./etc/passwd
# COPY --from=dvlp_base-fs ./etc/group ./etc/group
# COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# COPY --from=dvlp_base-fs_devel-lite  --chown=dvl:hell    ./home/dvl/     ./home/dvl/
# COPY --from=dvlp_base-fs_angel-lite  --chown=agl:halo    ./home/agl/     ./home/agl/
# COPY --from=dvlp_base-fs_good-lite   --chown=good:rootg  ./home/good/    ./home/good/
# COPY --from=dvlp_base-fs_devel-lite --chown=agl:halo   .${mnt_data}    .${mnt_data}
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:halo   .${mnt_data}    .${mnt_data}
COPY --from=dvlp_repo               --chown=dvl:hell    ./hel/dvlw/dvlp/mnt/home/  ./hel/
COPY --from=dvlp_repo               --chown=agl:halo    ./hel/dvlw/dvlp/mnt/home/  ./hal/
COPY --from=dvlp_repo               --chown=good:rootg  ./hel/dvlw/dvlp/mnt/home/  ./rootg/
# COPY --from=dvlp_base-fs_devel      --chown=agl:halo    .${mnt_data}/                   .${mnt_data}/
# COPY --from=dvlp_base-fs_angel      --chown=agl:halo    .${mnt_data}/                   .${mnt_data}/
COPY --from=dvlp_repo               --chown=good:halo   ./hel/dvlw/dvlp/mnt/       .${mnt_data}/
# COPY --from=dvlp_repo               --chown=agl:halo    .${mnt_data}/                   .${mnt_data}/
# COPY --from=dvlp_base-fs_devel      --chown=good:rootg   ./ ./fs/
# COPY --from=dvlp_base-fs_devel      --chown=dvl:hell    ./home/dvl/                     ./home/dvl/
# COPY --from=dvlp_base-fs_angel      --chown=agl:halo    ./home/agl/                     ./home/agl/
# COPY --from=dvlp_base-fs_devel    --chown=agl:halo     ./home/dvl/                     ./home/agl/
# COPY --from=dvlp_base-fs_good       --chown=good:rootg  ./home/good/                    ./home/good/
# COPY --from=dvlp_base-fs_devel    --chown=good:rootg  ./home/dvl/                     ./home/good/
# USER root
# WORKDIR /hell
# # SHELL ["/bin/bash", "-c"]
# # RUN chroot --userspec=dvl:hell /hell
# USER dvl
# WORKDIR /hell
###################
# dvlp_skel-build #
###################
FROM dvlp_base-fs AS dvlp_skel-build
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
COPY --from=dvlp_skel-build-lite --chown=good:halo      .${mnt_data}/   .${mnt_data}/
COPY --from=dvlp_skel-build-lite --chown=good:halo      .${mnt_data}/bak   .${mnt_data}/bak
COPY --from=dvlp_skel-build-lite --chown=dvl:hell       ./hel/     ./hel/
COPY --from=dvlp_skel-build-lite --chown=agl:halo       ./hal/     ./hal/
COPY --from=dvlp_skel-build-lite --chown=good:rootg     ./rootg/    ./rootg/
# COPY --from=dvlp_base-fs ./etc/passwd ./etc/passwd
# COPY --from=dvlp_base-fs ./etc/group ./etc/group
# # COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu

# # COPY --from=dvlp_base-fs_devel  --chown=dvl:hell    ./home/dvl/     ./home/dvl/
# # COPY --from=dvlp_base-fs_angel  --chown=agl:halo    ./home/agl/     ./home/agl/
# # COPY --from=dvlp_base-fs_good   --chown=good:rootg  ./home/good/    ./home/good/
# # # COPY --from=dvlp_base-fs_devel --chown=dvl:hell   .${mnt_data}    .${mnt_data}
# # # COPY --from=dvlp_base-fs_angel --chown=agl:halo   .${mnt_data}    .${mnt_data}
# COPY --from=dvlp_repo           --chown=dvl:hell    ./home/dvl/dvlw/dvlp/mnt/home/  ./home/dvl/
# COPY --from=dvlp_repo           --chown=agl:halo    ./home/dvl/dvlw/dvlp/mnt/home/  ./home/agl/
# COPY --from=dvlp_repo           --chown=good:rootg  ./home/dvl/dvlw/dvlp/mnt/home/  ./home/good/
# # COPY --from=dvlp_base-fs_devel  --chown=agl:halo    .${mnt_data}/                   .${mnt_data}/
# # COPY --from=dvlp_base-fs_angel  --chown=agl:halo    .${mnt_data}/                   .${mnt_data}/
# COPY --from=dvlp_repo           --chown=good:halo   ./home/dvl/dvlw/dvlp/mnt/       .${mnt_data}/
# # COPY --from=dvlp_repo           --chown=agl:halo    .${mnt_data}                    .${mnt_data}
COPY --from=dvlp_base-fs --chown=good:rootg   ./ ./fs/
# COPY --from=dvlp_base-fs_devel  --chown=dvl:hell    ./home/dvl/                     ./home/dvl/
# COPY --from=dvlp_base-fs_angel  --chown=agl:halo    ./home/agl/                     ./home/agl/
# COPY --from=dvlp_base-fs_good   --chown=good:rootg  ./home/good/                    ./home/good/
# COPY --from=dvlp_base-fs_devel --chown=good:rootg ./home/dvl/                     ./home/good/
# COPY --from=dvlp_base-fs_devel --chown=agl:halo   ./home/dvl/                     ./home/agl/
# USER root
# WORKDIR /hell
# # SHELL ["/bin/bash", "-c"]
# # RUN chroot --userspec=dvl:hell /hell
# USER dvl
# WORKDIR /hell

#############
# dvlp_skel #
#############
FROM dvlp_skel-build AS dvlp_skel
# ARG REFRESH_REPO=${REFRESH_REPO:-no}
# WORKDIR /
# RUN with agl ownership
# USER root
# COPY --from=dvlp_base-fs ./ ./
# # COPY --from=dvlp_base-fs ./etc/passwd/ ./etc/passwd/
# # COPY --from=dvlp_base-fs ./etc/group/ ./etc/group/
# # COPY --from=dvlp_base-fs ./etc/apt/ ./etc/apt/
# COPY --from=dvlp_base-fs ./etc/ ./etc/
# COPY --from=dvlp_base-fs ./lib/ ./lib/
# COPY --from=dvlp_base-fs ./lib64/ ./lib64/
# COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# COPY --from=dvlp_base-fs ./bin/ ./bin/
# COPY --from=dvlp_base-fs ./sbin/ ./sbin/
# COPY --from=dvlp_base-fs ./usr/ ./usr/
# COPY --from=dvlp_base-fs ./var/lib/ ./var/lib/
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install apt-transport-https curl gh git gnupg2 libssl-dev nvi wget
# RUN \
#     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
#     sudo apt-get -y update && \
# sudo add-apt-repository ppa:saiarcot895/myppa && \
# sudo apt-get -y install apt-fast aria2 

# FROM dvlp_skel-build-lite AS dvlp_skel-lite
# ARG REFRESH_REPO=${REFRESH_REPO:-no}
# WORKDIR /
# # COPY --from=dvlp_base-fs ./etc/passwd ./etc/passwd
# # COPY --from=dvlp_base-fs ./etc/group ./etc/group
# # COPY --from=dvlp_base-fs ./etc/ ./etc/
# # COPY --from=dvlp_base-fs ./lib/ ./lib/
# # COPY --from=dvlp_base-fs ./lib64/ ./lib64/
# # COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# # COPY --from=dvlp_base-fs ./bin/ ./bin/
# # COPY --from=dvlp_base-fs ./sbin/ ./sbin/
# # COPY --from=dvlp_base-fs ./usr/ ./usr/
# # COPY --from=dvlp_base-fs ./var/lib/ ./var/lib/
# # COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# # COPY --from=dvlp_base-fs ./ ./
# # COPY --from=dvlp_skel-build-lite  ./ ./
# # COPY --from=dvlp_skel-build-lite --chown=good:rootg ./ ./fs/
# # USER agl
# # WORKDIR /halo
# # RUN chown good:rootg /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal agl && chown -R agl:halo /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel dvl && chown -R dvl:hell /hell
# # WORKDIR /root/root
# # RUN usermod -d /root/root good && chown -R good:rootg /root/root

# # lock down volumes, permissions
# FROM dvlp_skel-install AS dvlp_skel
# ARG REFRESH_REPO=${REFRESH_REPO:-no}
# WORKDIR /
# # COPY --from=dvlp_skel-build                       ./            ./
# COPY --from=dvlp_skel-install                     ./            ./
# # COPY --from=dvlp_skel-build    --chown=good:rootg ./            ./fs/
# COPY --from=dvlp_skel-install  --chown=good:rootg ./            ./fs/
# # COPY --from=dvlp_base-fs_devel --chown=dvl:hell   ./home/dvl/   ./home/dvl/
# # COPY --from=dvlp_base-fs_angel --chown=agl:halo   ./home/agl/   ./home/agl/
# # COPY --from=dvlp_base-fs_good  --chown=good:rootg ./home/good/  ./home/good/
# # USER agl
# # WORKDIR /halo
# # RUN chown good:rootg /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal agl && chown -R agl:halo /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel dvl && chown -R dvl:hell /hell && chown -R dvl:hell /hell 
# # WORKDIR /root/root
# # RUN usermod -d /root/root good && chown -R good:rootg /root/root

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_skel-build-lite AS dvlp_bare
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-build-lite ./ ./
# COPY --from=dvlp_repo --chown=dvl:hell  ./hel/dvlw/ ./home/dvl/dvlw/
WORKDIR /hel
USER dvl

################################### GIT #########################################
#################
# dvlp_git_lite #
#################
FROM dvlp_skel-build-lite AS dvlp_git-lite
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-lite ./ ./
# COPY --from=dvlp_repo --chown=dvl:hell  ./hel/dvlw/ ./home/dvl/dvlw/
COPY --from=dvlp_repo ./ ./
# RUN chown -R good:rootg /root

WORKDIR /hel
USER dvl

############
# dvlp_git #
############
FROM dvlp_skel AS dvlp_git
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
COPY --from=dvlp_repo ./ ./
WORKDIR /hel
USER dvl

################################# PYTHON ########################################
#####################
# dvlp_python-build #
#####################
FROM dvlp_base-fs AS dvlp_python-build
USER root
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev  libpython3-dev pkg-config python3-pip python3-venv
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps 
##########################
# dvlp_python-build-lite #
##########################
FROM dvlp_skel-build-lite AS dvlp_python-build-lite
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y install jq python3-pip python3-venv
USER agl
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
USER good
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
RUN sudo chown -R dvl:hell /hel || sudo chown -R dvl:hell /hel/.local
USER dvl
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user

####################
# dvlp_python-lite #
####################
FROM dvlp_git AS dvlp_python-lite
WORKDIR / 
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER dvl

###############
# dvlp_python #
###############
FROM dvlp_git AS dvlp_python
WORKDIR / 
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER dvl

############################# POWERHELL #########################################
#########################
# dvlp_msdot-build-lite #
#########################
FROM dvlp_base-fs AS dvlp_msdot-build-lite
USER root
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install lsb-release wget && \
    sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    sudo mv packages-microsoft-prod.deb /var/cache/apt/archives && \
    sudo dpkg -i /var/cache/apt/archives/packages-microsoft-prod.deb && \
    sudo apt-get -y update && \
    sudo apt-get -y install powershell wslu
# now lives with other apt archives
# RUN sudo apt-get -y remove lsb_release
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

####################
# dvlp_msdot-build #
####################
FROM dvlp_msdot-build-lite AS dvlp_msdot-build
USER root
RUN sudo apt-get -y update && \
    sudo apt-get -y install dotnet-sdk-7.0 
USER dvl

###################
# dvlp_msdot-lite #
###################
FROM dvlp_base-fs AS dvlp_msdot-lite
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
WORKDIR /hel
USER dvl

##############
# dvlp_msdot #
##############
FROM dvlp_base-fs AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
WORKDIR /hel
USER dvl

########################## DOCKER IN DOCKER ######################################
###################
# dvlp_dind-build #
###################
FROM dvlp_base-fs AS dvlp_dind-build
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install curl lsb-release gpg
RUN sudo mkdir -pv /etc/apt/keyrings
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io 
# sudo apt-get remove -y lsb-release && \
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

##################
# dvlp_dind-lite #
##################
FROM dvlp_base-fs AS dvlp_dind-lite
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /hel
USER dvl

#############
# dvlp_dind #
#############
FROM dvlp_base-fs AS dvlp_dind
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
USER dvl

############################### KERNEL #########################################
#####################
# dvlp_kernel-build #
#####################
FROM dvlp_base-fs AS dvlp_kernel-build
USER agl
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install alien autoconf bison build-essential dbus-user-session daemonize dwarves fakeroot \ 
    flex fontconfig gawk kmod libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev \
    python3-dev python3-setuptools python3-cffi net-tools snapd systemd-sysv sysvinit-utils uuid-dev
# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER agl
WORKDIR /hel
USER dvl

########################################################
###  dvlp_basic-wsl-kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_base-fs AS dvlp_kernel-builder
ARG CONFIG_FILE=${CONFIG_FILE}
ARG KERNEL_TYPE=${KERNEL_TYPE:-basic-wsl}
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /hel
USER dvl

########################################################
###  dvlp_basic-wsl-kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_skel-build-lite AS dvlp_kernel-make
ARG CONFIG_FILE=${CONFIG_FILE}
ARG KERNEL_TYPE=${KERNEL_TYPE:-basic-wsl}
WORKDIR /
# COPY --from=dvlp_base-fs ./ ./
COPY --from=dvlp_skel-build ./ ./
COPY --from=dvlp_repo ./ ./
USER root
WORKDIR /hel/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN sudo ln -al && sudo chmod +x build-basic-wsl-kernel.sh
# RUN bash make-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" agl
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /hel
USER dvl

#################################### GUI ######################################
#################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_base-fs AS dvlp_gui-lite
USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /hel
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install curl
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN \
    --mount=type=cache,target=/var/cache/curl \
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get install -y brave-browser dolphin vlc x11-apps  
# change last line of this file - fix for brave-browser displaying empty windows
RUN sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null
COPY --from=dvlp_repo --chown=good:rootg /hel/dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
USER dvl

############
# dvlp_gui #
############
# wsl2 required
FROM dvlp_gui-lite AS dvlp_gui
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
USER root
RUN sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get install -y locales && \    
    update-locale LANGUAGE="C" && \
    update-locale LANG="C" && \
    update-locale LC_ALL="C" && \
    sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime  
# RUN sudo apt-get install -y locales && \
#     sudo dpkg-reconfigure --frontend noninteractive locales && \
#     echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager && \
#     sudo locale-gen && sudo update-locale 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get install -y xrdp xfce4 xfce4-goodies && \
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
    sudo apt-get install -y lightdm
RUN \
    --mount=type=cache,target=/var/cache/debconf \
    # echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
    sudo apt-get install --no-install-recommends -y kubuntu-desktop
COPY --from=dvlp_repo --chown=good:rootg /hel/dvlw/dvlp/mnt/etc/* /etc/

# RUN sudo aptitude safe-upgrade
# RUN \
#     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
#     sudo apt-get install -y xfce4
# sudo apt-get install -y locales brave-browser gimp gedit nautilus vlc x11-apps xfce4
# RUN sudo update-locale && \
#     echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.gen && \
#     sudo locale-gen && \
# # # sudo apt-get clean all && \
# # # sudo apt-get autoremove --purge
# # RUN \
# # --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
# # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo apt-get -y install lightdm gnome-session
# # RUN \
# # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo dpkg-reconfigure lightdm
# # RUN \
# #     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
# #     sudo dpkg-reconfigure --frontend noninteractive locales && \
# #     echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager 
# # RUN echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
USER dvl

#################
# dvlp_gui-plus #
#################
FROM dvlp_kernel-builder AS dvlp_gui-plus
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
# COPY --from=dvlp_basic-wsl-kernel-builder ./ ./
COPY --from=dvlp_gui ./ ./
WORKDIR /hel
USER dvl

############################## CUDA ###############################
#############
# dvlp_cuda #
#############
FROM dvlp_base-fs AS dvlp_cuda
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
# COPY --from=dvlp_kernel-lite ./ ./
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y --no-install-recommends install nvidia-cuda-toolkit
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

##################
# dvlp_cuda-plus #
##################
FROM dvlp_base-fs AS dvlp_cuda-plus
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_basic-wsl-kernel-builder ./ ./
COPY --from=dvlp_cuda ./ ./
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y install nvidia-cuda-toolkit
WORKDIR /hel
USER dvl

########################### OUTPUT ################################
#################
# KERNEL OUTPUT #
#################

FROM scratch AS dvlp_kernel-output
ARG CONFIG_FILE
WORKDIR /
COPY --from=dvlp_kernel-make ./built-kernel.tar.gz ./built-kernel.tar.gz


# docker buildx build --target=built-kernels --output type=local,dest=$(pwd)/out/ .
# docker buildx build -t dvlp_latest-rc-wsl-zfs-kernel-builder --output type=tar,dest=kubuntu22-plus-wsl-zfs-linux-kernel-6-28.tar  --build-arg CONFIG_FILE="https://raw.githubusercontent.com/kindtek/devels-playground/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0" .  2>&1 | tee latest-rc-wsl-zfs-kernel-builder-"$(date)".log
