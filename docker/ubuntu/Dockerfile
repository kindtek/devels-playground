#syntax=docker/dockerfile:experimental
# to build and run an individual service with args (ie git):
## `docker compose build git --build-arg REFRESH_REPO=true && docker compose up git`
# to build everything:
## `docker compose build && docker compose up`
# to remove all volumes:
## docker compose down && docker volume rm $(docker volume ls -q)
ARG BUILD_TARGET=${INTERNAL_BUILD:+INTERNAL}
ARG BUILD_TARGET=${BUILD_TARGET:-EXTERNAL}
ARG INTERNAL_BUILD
ARG CONFIG_FILE=${CONFIG_FILE}
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKER_BUILDKIT=1
ARG KERNEL_TYPE=${KERNEL_TYPE:-basic-wsl}
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ARG _AGL_USR=${_AGL:-agl}
ARG _DVL_USR=${_DVL:-dvl}
ARG _MNT=${_MNT:-/mnt/data}
ARG WORLDS=gui

################################### REPO ####################################
#############
# dvlp_repo #
#############
FROM ubuntu:latest AS dvlp_repo-build-prep
ARG _MNT
ARG REFRESH_REPO
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
WORKDIR /
# RUN mkdir -pv /tmp/git/cache && \
# chown -R r00t:r00t /tmp/git/cache && \
#     mkdir -pv /dvlw && \
#     chown -R r00t:r00t /dvlw
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && apt-get -y install git 
# add git cache directory

# add safe directories
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    # if [ "$fresh_repo" != no ]; then rm -rf /tmp/git/cache/dvlw; fi && \
    git config --global --add safe.directory /home/${_DVL} && \
    git config --global --add safe.directory /home/${_AGL} && \
    git config --global --add safe.directory /hal && \
    git config --global --add safe.directory /hal/dvlw && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /hel/dvlw && \
    git config --global --add safe.directory / && \
    git config --global --add safe.directory /root && \
    git config --global --add safe.directory /r00t && \
    git config --global --add safe.directory /dvlw/ && \
    git config --global --add safe.directory /tmp/git/cache

FROM dvlp_repo-build-prep AS dvlp_repo-build-lite
WORKDIR /
# COPY --from=dvlp_base-devel-dirs --chown=${_DVL}:${_DVL} ./hell/ ./hell/

# clone fresh repos and give ${_DVL} ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw-lite || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /dvlw-lite
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    ((git submodule init -- dvlp && git submodule update --init --remote --depth=1 --progress -- dvlp )|| git pull dvlp) && \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak

FROM dvlp_repo-build-lite AS dvlp_repo-build
WORKDIR /
# # # COPY --from=dvlp_base-fs ./home/ ./home/
# # # COPY --from=dvlp_base-fs ./mnt/ ./mnt/
# # # COPY --from=dvlp_base-fs ./hel/ ./hel/
# # # COPY --from=dvlp_base-fs ./hal/ ./hal/
# # # COPY --from=dvlp_base-fs ./r00t/ ./r00t/
# clone fresh repos and give ${_DVL} ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    git clone https://github.com/kindtek/devels-workshop --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /dvlw
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --progress -- dvlp || git pull && \
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak
WORKDIR /dvlw/dvlp
# # RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    ( git submodule update --init --progress || git submodule update --init --progress --force --rebase -- kernels ) 
# (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)


# RUN if [ "$REFRESH_REPO" != no ]; then git pull; fi    

FROM scratch AS dvlp_repo-lite
COPY --from=dvlp_repo-build-lite ./dvlw-lite/ ./dvlw/
FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./dvlw/ ./dvlw/

################################### BASE ####################################
#############
# dvlp_base-devel-dirs-lite #
#############
# ${_DVL} permissions/volume builder
FROM ubuntu:latest AS dvlp_base-devel-dirs-lite
ARG _MNT
ARG _DVL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hel
RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    mkdir -pv ${_MNT}/bak/${_DVL} && \
    chmod 753 ${_MNT}/bak/${_DVL} && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_DVL} && \
    cp -rv * /home/${_DVL}
WORKDIR ${_MNT}
RUN mkdir -pv bak/${_DVL} && \
    chmod 753 bak/${_DVL} && \
    ln -fsv bak/${_DVL} /home/${_DVL}/bak && \
    ln -fsv bak/${_DVL} /hel/bak 
WORKDIR /

FROM dvlp_base-devel-dirs-lite AS dvlp_base-devel-dirs
ARG _MNT
ARG _DVL
WORKDIR /hel
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv /hel && \
    mkdir -pv /hel/built-kernels && \
    mkdir -pv /home/${_DVL}}/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels
WORKDIR /home/${_DVL}
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels
WORKDIR /

# agl permissions/volume builder
FROM ubuntu:latest AS dvlp_base-angel-dirs-lite
ARG _MNT
ARG _AGL_USR
ENV _AGL=${_AGL_USR:-agl}
WORKDIR /hal
RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_AGL} && \
    cp -rv * /home/${_AGL} 
WORKDIR ${_MNT}
RUN mkdir -pv bak/${_AGL} && \
    chmod 753 bak/${_AGL}
WORKDIR /

FROM dvlp_base-angel-dirs-lite AS dvlp_base-angel-dirs
ARG _MNT
ARG _AGL
WORKDIR /hal
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv built-kernels && \
    mkdir -pv /home/${_AGL}/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
WORKDIR /home/${_AGL}
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels
WORKDIR /

# r00t permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_r00t-lite
ARG _MNT
WORKDIR /r00t
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/    ./
RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/r00t && \
    cp -rv * /home/r00t
WORKDIR ${_MNT}
RUN mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv etc && \
    mkdir -pv home && \
    mkdir -pv opt
WORKDIR /

FROM dvlp_base-fs_r00t-lite AS dvlp_base-fs_r00t
ARG _MNT
WORKDIR /r00t
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/    ./
RUN mkdir -pv built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    mkdir -pv /home/r00t && \
    cp -rv * /home/r00t
WORKDIR /

# r00t permissions/volume builder
FROM ubuntu:latest AS dvlp_base-r00t-dirs
ARG _MNT
ARG _ADMIN
WORKDIR /admin
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/    ./
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/         ./mnt/

RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker 
WORKDIR /mnt
RUN mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv etc && \
    mkdir -pv home && \
    mkdir -pv opt
WORKDIR /

FROM dvlp_base-r00t-dirs AS dvlp_base-r00t-dirs-kernel
ARG _MNT
ARG _ADMIN
WORKDIR /admin
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
WORKDIR /


# FROM scratch AS dvlp_base-fs_permissions
# #COPY --from=dvlp_base-devel-dirs --chown=${_DVL}:${_DVL} ./hel ./hel
# COPY --from=dvlp_base-devel-dirs --chown=${_DVL}:${_DVL} ./hell ./hell
# COPY --from=dvlp_base-devel-dirs --chown=${_DVL}:${_DVL} ./home ./home
# COPY --from=dvlp_base-devel-dirs --chown=${_AGL}:${_DVL} ./mnt ./mnt

# COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:${_AGL} ./hal ./hal
# COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:${_AGL} ./halo ./halo
# COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:${_AGL} ./home ./home
# COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:${_AGL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./home ./home
# # COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./r00t ./r00t
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./r00t ./r00t
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./fs ./fs

# FROM scratch AS dvlp_base-fs_permissions-lite
# COPY --from=dvlp_base-devel-dirs-lite --chown=${_DVL}:${_DVL} ./hel ./hel
# # COPY --from=dvlp_base-devel-dirs-lite --chown=${_DVL}:${_DVL} ./hell ./hell
# COPY --from=dvlp_base-devel-dirs-lite --chown=${_DVL}:${_DVL} ./home ./home
# COPY --from=dvlp_base-devel-dirs-lite --chown=${_AGL}:${_DVL} ./mnt ./mnt

# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL} ./hal ./hal
# # COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL} ./halo ./halo
# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL} ./home ./home
# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./home ./home
# # COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./r00t ./r00t
# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./root ./root
# # COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./fs ./fs


############################## BASE ####################################
#############
# dvlp_base-fs #
#############
FROM ubuntu:latest AS dvlp_base-fs
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG CONFIG_FILE
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./etc/skel/

RUN chmod -R -x /etc/skel
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    # add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && \
    apt-get upgrade -y 
#   apt-get -y install apt-fast
# adduser --home /home/r00t --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS r00t && \
RUN addgroup --gid 4321 r00t && \
    addgroup --gid 777 ${_AGL} && \
    addgroup --gid 666 ${_DVL} 
RUN useradd -s /bin/bash  -u 0 -o -g root -G r00t,$_AGL,$_DVL -d /r00t r00t
RUN useradd -s /bin/bash  -u 666 -g ${_DVL} -d /hel ${_DVL} 
RUN useradd -s /bin/bash  -u 777 -g ${_AGL} -d /hal ${_AGL}  
RUN chown -R r00t:r00t /root && \
    # usermod -g 0 -u 0 -o r00t  && \
    # usermod -d /r00t r00t && \
    passwd -d r00t && \
    passwd -d root && \
    passwd -l root && \
    # passwd -d ${_AGL} && \
    # passwd -d ${_DVL} && \
    echo "[user] \
    default=${_DVL}" >> /etc/wsl.conf && \
    rm -rf /home/r00t/* && \
    rm -rf /r00t/* && \
    rm -rf /home/agl/* && \
    rm -rf /hal/* && \
    rm -rf /home/dvl/* && \
    rm -rf /hel/* 
USER r00t
# COPY --from=dvlp_base-devel-dirs-lite --chown=${_DVL}:${_DVL}     ./hel/                  ./hel/
# COPY --from=dvlp_base-devel-dirs-lite --chown=${_DVL}:${_DVL}     ./home/${_DVL}/         ./home/${_DVL}/
# ##############################################################
# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL}     ./hal/                  ./hal/
# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL}     ./home/${_AGL}/         ./home/${_AGL}/
# COPY --from=dvlp_base-angel-dirs-lite --chown=${_AGL}:${_AGL}     .${_MNT}/bak/           .${_MNT}/bak/
# ##############################################################
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           ./root/                 ./root/
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           ./home/r00t/            ./home/r00t/
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           ./mnt/                  ./mnt/
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           .${_MNT}/etc/           .${_MNT}/etc/
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           .${_MNT}/home/          .${_MNT}/home/
# COPY --from=dvlp_base-fs_r00t-lite  --chown=r00t:r00t           .${_MNT}/opt/           .${_MNT}/opt/
##############################################################
#############
WORKDIR /
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./root/                 ./root/
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./home/r00t/            ./home/r00t/
COPY --from=dvlp_base-devel-dirs-lite     --chown=${_DVL}:${_DVL}     ./hel/                  ./hel/
COPY --from=dvlp_base-devel-dirs-lite     --chown=${_DVL}:${_DVL}     ./home/${_DVL}/         ./home/${_DVL}/
COPY --from=dvlp_base-devel-dirs-lite     --chown=${_DVL}:${_DVL}     ./mnt/                  ./mnt/
COPY --from=dvlp_base-angel-dirs-lite     --chown=${_AGL}:${_AGL}     ./hal/                  ./hal/
COPY --from=dvlp_base-angel-dirs-lite     --chown=${_AGL}:${_AGL}     ./home/${_AGL}/         ./home/${_AGL}/ 
COPY --from=dvlp_base-angel-dirs-lite     --chown=${_AGL}:${_AGL}     ./mnt/                  ./mnt/
COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./r00t/                 ./r00t/
COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./home/r00t/            ./home/r00t/
COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./mnt/                  ./mnt/
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           ./mnt/dls/              ./mnt/dls/
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           .${_MNT}/etc/           .${_MNT}/etc/
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           .${_MNT}/home/          .${_MNT}/home/
# COPY --from=dvlp_base-fs_r00t-lite      --chown=r00t:r00t           .${_MNT}/opt/           .${_MNT}/opt/
##############################################################
# COPY --from=dvlp_base-r00t-dirs-kernel  --chown=r00t:r00t           ./admin/                ./r00t/ 
# COPY --from=dvlp_base-r00t-dirs-kernel                              ./admin/                ./home/r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel                              ./mnt/                  ./${_MNT}/
# COPY --from=dvlp_repo-lite                                       ./dvlw/dvlp/mnt/home/    ./home/r00t/
# COPY --from=dvlp_repo-lite                                          ./dvlw/dvlp/mnt/home/   ./hal/
# COPY --from=dvlp_repo-lite                                          ./dvlw/dvlp/mnt/home/   ./home/${_AGL}/
# COPY --from=dvlp_repo-lite                                          ./dvlw/dvlp/mnt/home/   ./hel/
# COPY --from=dvlp_repo-lite                                          ./dvlw/dvlp/mnt/home/   ./home/${_DVL}/
RUN passwd -d ${_AGL}  && \
    passwd -d ${_DVL} 
RUN apt-get -y install sudo && \
    usermod -aG sudo ${_AGL} 
    # cp /hal/.sudo_as_admin_successful /home/hal/.sudo_as_admin_successful 

############################## SKELETON ###################################
########################
# dvlp_skel-build-lite #
########################
FROM ubuntu:latest AS dvlp_skel-build-lite
ARG REFRESH_REPO
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_repo-lite          --chown=${_DVL}:${_DVL}     ./dvlw/dvlp/mnt/home/    ./hel/
COPY --from=dvlp_repo-lite          --chown=${_AGL}:${_AGL}     ./dvlw/dvlp/mnt/home/    ./hal/
COPY --from=dvlp_repo-lite          --chown=r00t:r00t           ./dvlw/dvlp/mnt/home/    ./r00t/
COPY --from=dvlp_repo-lite          --chown=r00t:${_AGL}        ./dvlw/dvlp/mnt/         .${_MNT}/
COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./home/r00t/dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./r00t/dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./home/agl/dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./hal/dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./home/dvl/dvlw/
# COPY --from=dvlp_repo-lite                                      ./dvlw/                  ./hel/dvlw/

## WORKDIR /hell
###################
# dvlp_skel-build #
###################
FROM ubuntu:latest AS dvlp_skel-build
ARG REFRESH_REPO
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_base-r00t-dirs-kernel  --chown=r00t:r00t           ./admin/                ./r00t/ 
COPY --from=dvlp_base-r00t-dirs-kernel                              ./admin/                ./home/r00t/
COPY --from=dvlp_base-r00t-dirs-kernel                              ./mnt/                  ./${_MNT}/
COPY --from=dvlp_repo                   --chown=${_DVL}:${_DVL}     ./dvlw/dvlp/mnt/home/   ./hel/
COPY --from=dvlp_repo                   --chown=${_AGL}:${_AGL}     ./dvlw/dvlp/mnt/home/   ./hal/
COPY --from=dvlp_repo                   --chown=r00t:r00t           ./dvlw/dvlp/mnt/home/   ./r00t/
COPY --from=dvlp_repo                   --chown=r00t:${_AGL}        ./dvlw/dvlp/mnt/        .${_MNT}/
# COPY --from=dvlp_base-devel-dirs      --chown=${_DVL}:${_DVL}     ./hel/                  ./hel/
# COPY --from=dvlp_base-angel-dirs      --chown=${_AGL}:${_AGL}     ./hal/                  ./hal/
# COPY --from=dvlp_base-fs_r00t       --chown=r00t:r00t           ./root/                 ./root/
COPY --from=dvlp_repo                                               ./dvlw/                 ./dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./home/r00t/dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./r00t/dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./home/agl/dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./hal/dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./home/dvl/dvlw/
# COPY --from=dvlp_repo                                           ./dvlw/                 ./hel/dvlw/

#############
# dvlp_skel #
#############
FROM dvlp_skel-build AS dvlp_skel
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install apt-transport-https curl gh git gnupg2 libssl-dev nvi wget

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_skel-build-lite AS dvlp_bare
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
# USER r00t
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-build-lite ./ ./
# COPY --from=dvlp_repo --chown=${_DVL}:${_DVL}  ./dvlw/ ./home/${_DVL}/dvlw/
WORKDIR /hel
USER ${_DVL}

################################### GIT #########################################
#################
# dvlp_git_lite #
#################
FROM dvlp_skel-build AS dvlp_git-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hel
USER ${_DVL}

############
# dvlp_git #
############
FROM dvlp_skel AS dvlp_git
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hel
USER ${_DVL}

################################# PYTHON ########################################
#####################
# dvlp_python-build #
#####################
FROM dvlp_base-fs AS dvlp_python-build
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
USER r00t
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev  libpython3-dev pkg-config python3-pip python3-venv
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps 
##########################
# dvlp_python-build-lite #
##########################
FROM dvlp_skel-build-lite AS dvlp_python-build-lite
USER r00t
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y install jq python3-pip python3-venv
RUN chown -R ${_AGL}:${_AGL} /hal || chown -R ${_AGL}:${_AGL} /hel/.local
USER ${_AGL}
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
USER r00t
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
RUN chown -R ${_DVL}:${_DVL} /hel || chown -R ${_DVL}:${_DVL} /hel/.local
USER ${_DVL}
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user

####################
# dvlp_python-lite #
####################
FROM dvlp_git-lite AS dvlp_python-lite
USER r00t
WORKDIR / 
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

###############
# dvlp_python #
###############
FROM dvlp_git-lite AS dvlp_python
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR / 
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

############################# POWERHELL #########################################
#########################
# dvlp_msdot-build-lite #
#########################
FROM dvlp_base-fs AS dvlp_msdot-build-lite
USER r00t
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install lsb-release wget && \
    wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    mv packages-microsoft-prod.deb /var/cache/apt/archives && \
    dpkg -i /var/cache/apt/archives/packages-microsoft-prod.deb && \
    apt-get -y update && \
    apt-get -y install powershell wslu
# now lives with other apt archives
# RUN apt-get -y remove lsb_release
# apt-get clean all && \
# apt-get autoremove --purge
WORKDIR /hel
USER ${_DVL}

####################
# dvlp_msdot-build #
####################
FROM dvlp_msdot-build-lite AS dvlp_msdot-build
USER r00t
RUN apt-get -y update && \
    apt-get -y install dotnet-sdk-7.0 
WORKDIR /hel
USER ${_DVL}

###################
# dvlp_msdot-lite #
###################
FROM dvlp_git-lite AS dvlp_msdot-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

##############
# dvlp_msdot #
##############
FROM dvlp_git-lite AS dvlp_msdot
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
WORKDIR /hel
USER ${_DVL}

########################## DOCKER IN DOCKER ######################################
###################
# dvlp_dind-build #
###################
FROM dvlp_base-fs AS dvlp_dind-build
USER r00t
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install curl lsb-release gpg
RUN mkdir -pv /etc/apt/keyrings
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io 
WORKDIR /hel
USER ${_DVL}

##################
# dvlp_dind-lite #
##################
FROM dvlp_git-lite AS dvlp_dind-lite
USER r00t
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /hel
USER ${_DVL}

#############
# dvlp_dind #
#############
FROM dvlp_git-lite AS dvlp_dind
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /hel
USER ${_DVL}

############################### KERNEL #########################################
#####################
# dvlp_kernel-build #
#####################
FROM dvlp_base-fs AS dvlp_kernel-build
USER r00t
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install alien autoconf bison build-essential dbus-user-session daemonize dwarves fakeroot \ 
    flex fontconfig gawk kmod libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev \
    python3-dev python3-setuptools python3-cffi net-tools snapd systemd-sysv sysvinit-utils uuid-dev
# RUN apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
WORKDIR /hel
USER ${_DVL}

########################################################
###  dvlp_kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_git AS dvlp_kernel-builder
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER r00t
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hel
USER ${_DVL}

########################################################
###  dvlp_kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_kernel-builder AS dvlp_kernel-make
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER r00t
WORKDIR /
# COPY --from=dvlp_base-fs ./ ./
WORKDIR /hel/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN chmod +x build-basic-wsl-kernel.sh
RUN bash build-${KERNEL_TYPE}-kernel.sh
# RUN bash make-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" ${_AGL}
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hel
USER ${_DVL}

#################################### GUI ######################################
#################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_git-lite AS dvlp_gui-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install curl
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN \
    --mount=type=cache,target=/var/cache/curl \
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get install -y brave-browser dolphin vlc x11-apps  
# change last line of this file - fix for brave-browser displaying empty windows
RUN cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | tee --append /opt/brave.com/brave/brave-browser > /dev/null
COPY --from=dvlp_repo --chown=r00t:r00t /dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/${_DVL} && \
WORKDIR /hel
USER ${_DVL}

############
# dvlp_gui #
############
# wsl2 required
FROM dvlp_gui-lite AS dvlp_gui
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
USER r00t
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y locales && \    
    update-locale LANGUAGE="C" && \
    update-locale LANG="C" && \
    update-locale LC_ALL="C" && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime  
# RUN apt-get install -y locales && \
#     dpkg-reconfigure --frontend noninteractive locales && \
#     echo "/usr/sbin/lightdm" | tee /etc/X11/default-display-manager && \
#     locale-gen && update-locale 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get install -y xrdp xfce4 xfce4-goodies && \
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
    apt-get install -y lightdm
RUN \
    --mount=type=cache,target=/var/cache/debconf \
    # echo "set shared/default-x-display-manager lightdm" | debconf-communicate && \
    apt-get install --no-install-recommends -y kubuntu-desktop
COPY --from=dvlp_repo --chown=r00t:r00t /dvlw/dvlp/mnt/etc/* /etc/

# RUN aptitude safe-upgrade
# RUN \
#     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
#     apt-get install -y xfce4
# apt-get install -y locales brave-browser gimp gedit nautilus vlc x11-apps xfce4
# RUN update-locale && \
#     echo "LANG=en_US.UTF-8" | tee -a /etc/locale.gen && \
#     locale-gen && \
# # # apt-get clean all && \
# # # apt-get autoremove --purge
# # RUN \
# # --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
# # DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get -y install lightdm gnome-session
# # RUN \
# # DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure lightdm
# # RUN \
# #     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
# #     dpkg-reconfigure --frontend noninteractive locales && \
# #     echo "/usr/sbin/lightdm" | tee /etc/X11/default-display-manager 
# # RUN echo "set shared/default-x-display-manager lightdm" | debconf-communicate && \
USER ${_DVL}

#################
# dvlp_gui-plus #
#################
FROM dvlp_kernel-builder AS dvlp_gui-plus
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /
COPY --from=dvlp_gui ./ ./
WORKDIR /hel
USER ${_DVL}

############################## CUDA ###############################
#############
# dvlp_cuda #
#############
FROM dvlp_git-lite AS dvlp_cuda
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
# COPY --from=dvlp_kernel-lite ./ ./
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y --no-install-recommends install nvidia-cuda-toolkit
# apt-get clean all && \
# apt-get autoremove --purge
WORKDIR /hel
USER ${_DVL}

##################
# dvlp_cuda-plus #
##################
FROM dvlp_git AS dvlp_cuda-plus
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-builder ./ ./
COPY --from=dvlp_cuda ./ ./
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y install nvidia-cuda-toolkit
WORKDIR /hel
USER ${_DVL}

########################### OUTPUT ################################
#################
# KERNEL OUTPUT #
#################

FROM scratch AS dvlp_kernel-output
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG CONFIG_FILE
WORKDIR /
COPY --from=dvlp_kernel-make ./built-kernel.tar.gz ./built-kernel.tar.gz

# FROM dvlp_dind-lite AS docker-build-docker
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _ADM_USR
# ENV _AGL=$_AGL_USR
# ENV _DVL=$_DVL_USR
# ENV _ADM=$_ADM_USR
# WORKDIR /dvlw/dvlp/docker/ubuntu
# RUN docker compose build gui-plus && \
#     IMAGE_ID=$(docker compose build up --build --attach gui-plus 2>/dev/null | awk '/Successfully built/{print $NF}')

# docker buildx build --target=built-kernels --output type=local,dest=$(pwd)/out/ .
# docker buildx build -t dvlp_latest-rc-wsl-zfs-kernel-builder --output type=tar,dest=kubuntu22-plus-wsl-zfs-linux-kernel-6-28.tar  --build-arg CONFIG_FILE="https://raw.githubusercontent.com/kindtek/devels-playground/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0" .  2>&1 | tee latest-rc-wsl-zfs-kernel-builder-"$(date)".log


# FROM dvlp_base-fs AS dvlp_world
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _ADM_USR
# ENV _AGL=$_AGL_USR
# ENV _DVL=$_DVL_USR
# ENV _ADM=$_ADM_USR
# # COPY from=dvlp_bare	--chown=r00t:r00t       ./	./g0d/r00t/halo/
# USER r00t
# RUN \
#     # super super root user
#     addgroup --gid 4324 --force-badname g0d && \
#     addgroup --gid 4323 --force-badname g0d && \
#     addgroup --gid 4322 --force-badname r00t && \
#     addgroup --gid 4320 --force-badname w0rld && \
#     # usermod -l g0d root && \
#     # useradd -s /bin/bash -u 0 -o -g root -G g0d,r00t,w0rld -d / g0d && \
#     useradd -s /bin/bash -u 0 -o -g root -G g0d,g0d,r00t,w0rld -d /g0d g0d && \
#     useradd -s /bin/bash -u 0 -o -g root -G g0d,r00t,w0rld -d /g0d g0d
# # USER g0d
# COPY --from=dvlp_bare --chown=g0d:g0d               ./	        ./g0d/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./g0d/g0d/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./g0d/r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./g0d/hel/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./g0d/hal/

# COPY --from=dvlp_bare --chown=r00t:r00t             ./	        ./r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./r00t/g0d/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./r00t/r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./r00t/hel/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./r00t/hal/
# ####
# COPY --from=dvlp_bare --chown=${_DVL}:${_DVL}	    ./	        ./${_DVL}/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_DVL}/g0d/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_DVL}/r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_DVL}/hel/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_DVL}/hal/
# ####
# COPY --from=dvlp_bare	--chown=${_AGL}:${_AGL}	    ./	        ./${_AGL}/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_AGL}/g0d/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_AGL}/r00t/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_AGL}/hel/
# COPY --from=dvlp_base-r00t-dirs-kernel             ./admin/    ./${_AGL}/hal/
# # RUN mkdir -p /g0d/r00t/hell && \
# #     mkdir -p /g0d/r00t/halo && \
# #     mkdir -p /g0d/g0d/r00t/hell && \
# #     mkdir -p /g0d/g0d/r00t/halo && \
# #     mkdir -p /g0d/r00t/g0d/r00t/hell && \
# #     mkdir -p /g0d/r00t/g0d/r00t/halo && \
# #     mkdir -p /g0d/r00t/halo/g0d/r00t/hell && \
# #     mkdir -p /g0d/r00t/halo/g0d/r00t/halo && \
# #     mkdir -p /g0d/g0d/r00t/hell/g0d/r00t/hell && \
# #     mkdir -p /g0d/g0d/r00t/hell/g0d/r00t/halo && \
# RUN chown g0d:g0d /g0d && \
#     chown r00t:r00t /r00t && \
#     chown ${_DVL}:${_DVL} /${_DVL}
# # chown ${_AGL}:${_AGL} /g0d/r00t/halo
# # RUN \
# #     # super root user
# #     # useradd -s /bin/bash -u 0 -o -g root -G g0d,r00t,w0rld -d --root /g0d g0d && \
# #     # useradd -s /bin/bash -G root,r00t -d -U --root /g0d r00t
# # usermod -l g0d r00t && \
# # usermod -aG r00t,w0rld r00t

# FROM dvlp_world AS dvlp_worlds
# # USER g0d
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _ADM_USR
# ENV _AGL=$_AGL_USR
# ENV _DVL=$_DVL_USR
# ENV _ADM=$_ADM_USR
# # RUN useradd -s /bin/bash -G g0d,r00t,w0rld -d /g0d g0d
# # RUN useradd -s /bin/bash -G g0d,r00t,w0rld -d /g0d g0d
# COPY --from=dvlp_world  --chown=g0d:g0d	                ./r00t/	            ./
# COPY --from=dvlp_world	--chown=${_AGL}:${_AGL}	        ./${_AGL}/	        ./g0d/r00t/halo/
# COPY --from=dvlp_world	--chown=${_DVL}:${_DVL}	        ./${_DVL}/	        ./g0d/r00t/hell/
# COPY --from=dvlp_world	--chown=r00t:r00t	            ./r00t/     	    ./g0d/r00t/
# COPY --from=dvlp_world	--chown=g0d:g0d 	            ./r00t/	            ./g0d/
# #temp

# # RUN chown -R r00t:r00t /g0d/r00t

# # RUN passwd -l g0d root
# RUN \
#     chroot --userspec=root:root /g0d addgroup --gid 4323 --force-badname g0d 
# RUN \
#     chroot --userspec=root:root /g0d addgroup --gid 4322 --force-badname r00t 
# RUN \
#     chroot --userspec=root:root /g0d addgroup --gid 4320 --force-badname w0rld
# RUN \
#     useradd -s /bin/bash -u 0 -o -G g0d,r00t,w0rld -d /g0d --root /g0d g0d
# RUN \
#     useradd -s /bin/bash -g w0rld -m --root /g0d r00t
# RUN \
#     chroot --userspec=root:root /g0d usermod -aG sudo r00t 
# RUN \
#     chroot --userspec=root:root /g0d/r00t addgroup --gid 4323 --force-badname g0d && \
#     chroot --userspec=root:root /g0d/r00t addgroup --gid 4322 --force-badname r00t && \
#     chroot --userspec=root:root /g0d/r00t addgroup --gid 4320 --force-badname w0rld && \
#     useradd -s /bin/bash -u 0 -o -g r00t -G w0rld -d /g0d/r00t --root /g0d/r00t r00t && \
#     # useradd -s /bin/bash -G r00t,w0rld -m --root /g0d/r00t --root /g0d/r00t r00T && \
#     chroot --userspec=root:root /g0d/r00t usermod -aG sudo ${_AGL}

# # usermod -aG r00t,w0rld r00t
# RUN chroot --userspec=root:root /g0d/r00t/hell addgroup --gid 4323 --force-badname g0d && \
#     chroot --userspec=root:root /g0d/r00t/hell addgroup --gid 4322 --force-badname r00t && \
#     chroot --userspec=root:root /g0d/r00t/hell addgroup --gid 4320 --force-badname w0rld && \
#     # useradd -s /bin/bash -G w0rld -d /g0d/r00t/hell/hel --root /g0d/r00t/hell ${_DVL} && \
#     chroot --userspec=root:root /g0d/r00t/hell usermod -aG sudo ${_AGL_USR:-agl} && \
#     chroot --userspec=root:root /g0d/r00t/halo addgroup --gid 4323 --force-badname g0d && \
#     chroot --userspec=root:root /g0d/r00t/halo addgroup --gid 4322 --force-badname r00t && \
#     chroot --userspec=root:root /g0d/r00t/halo addgroup --gid 4320 --force-badname w0rld && \
#     # useradd -s /bin/bash -G w0rld -d /g0d/r00t/halo/hal --root /g0d/r00t/halo ${_AGL} && \
#     chroot --userspec=root:root /g0d/r00t/halo usermod -aG sudo ${_AGL_USR:-agl}  
# WORKDIR /g0d/r00t/hell
# # chroot --userspec=root:root /g0d usermod -aG sudo r00t

# # RUN chown r00t:r00t /g0d
# # COPY --from=dvlp_world	--chown=r00t:r00t	    ./r00t/     	    ./g0d/r00t/
# # COPY --from=dvlp_world	--chown=g0d:g0d	        ./r00t/	            ./g0d/
# # RUN chown g0d:g0d /g0d && \
# #     chown g0d:g0d /g0d *

FROM ubuntu:latest AS dvlp_worlds-skel
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
WORKDIR /
# COPY --from=dvlp_bare --chown=g0d:g0d               ./	        ./g0d/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./g0d/g0d/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./g0d/r00t/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./g0d/hel/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./g0d/hal/

# COPY --from=dvlp_bare --chown=r00t:r00t             ./	        ./r00t/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./r00t/g0d/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./r00t/r00t/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./r00t/hel/
# COPY --from=dvlp_base-r00t-dirs             ./admin/    ./r00t/hal/
####
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./hell/g0d/
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./hell/r00t/
COPY --from=dvlp_base-devel-dirs                    ./hel/      ./hell/hel/
COPY --from=dvlp_base-r00t-dirs                     ./mnt/      ./hell/${_MNT}/
####
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./halo/g0d/
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./halo/r00t/
COPY --from=dvlp_base-angel-dirs                    ./hal/      ./halo/hal/
COPY --from=dvlp_base-r00t-dirs                     ./mnt/      ./halo/${_MNT}/

FROM dvlp_worlds-skel AS dvlp_worlds
ARG _MNT
ARG WORLDS
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG CONFIG_FILE
ARG DEBIAN_FRONTEND=noninteractive
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
# copy over features
COPY --from=dvlp_bare	            	            ./	        ./halo/
COPY --from=dvlp_bare	            	            ./	        ./hell/
# COPY --from=dvlp_worlds-skel 	    ./	        ./hell/
# COPY --from=dvlp_worlds-skel 	    ./	        ./halo/\
# RUN passwd -l g0d root
# USER g0d
WORKDIR /
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./etc/skel/
# COPY --from=dvlp_base-r00t-dirs ./admin/ ./g0d/ 
# COPY --from=dvlp_base-r00t-dirs ./admin/ ./home/g0d/
# COPY --from=dvlp_base-r00t-dirs ./mnt/ ./${_MNT}/
# 
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./g0d/
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./r00t/

RUN chmod -R -x /etc/skel
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    # add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get -y install sudo
# adduser --home /home/g0d --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS r00t && \
RUN addgroup --gid 4325 g0d && \
    addgroup r00t && \
    addgroup w0rld
RUN useradd -s /bin/bash  -u 0 -o -g root -G g0d,r00t,w0rld -d /g0d g0d && \
# RUN useradd -s /bin/bash  -g r00t -G w0rld -d /r00t r00t && \
#     usermod -aG sudo r00t && \
# RUN useradd -s /bin/bash  -u 666 -g ${_DVL} -d /hel ${_DVL} 
# RUN useradd -s /bin/bash  -u 777 -g ${_AGL} -d /hal ${_AGL}  
# RUN chown -R g0d:g0d /root && \
    # usermod -g 0 -u 0 -o r00t  && \
    # usermod -d /r00t r00t && \
    passwd -d g0d && \
    passwd -d root && \
    passwd -l root && \
    groupadd devel --root /hell && \
    groupadd angel --root /halo && \
    groupadd w0rld --root /hell && \
    groupadd w0rld --root /halo


# # passwd -d ${_AGL} && \
# # passwd -d ${_DVL} && \
# echo "[user] \
# default=${_DVL}" >> /etc/wsl.conf 
# USER g0d
# add devel w/ root permissions in hell and angel w/ sudo
# RUN userdel --root /hell ${_DVL}
RUN useradd -s /bin/bash -u 0 -o -g root -G devel,w0rld -d /hell/hel --root /hell ${_DVL}
# RUN userdel --root /halo ${_AGL}
RUN useradd -s /bin/bash -g angel -G w0rld -d /halo/hal --root /halo ${_AGL} && \
    chroot --userspec=g0d:g0d /halo usermod -aG sudo ${_AGL}


# RUN useradd -s /bin/bash -G g0d,r00t,w0rld -d /g0d g0d
# # # COPY --from=dvlp_world-bare --chown=g0d:g0d	                ./r00t/	            ./
# COPY --from=dvlp_world-bare                                 ./halo/	        ./g0d/r00t/halo/
# # COPY --from=dvlp_world-bare	--chown=${_AGL}:${_AGL}	        ./${_AGL}/	        ./g0d/r00t/halo/
# COPY --from=dvlp_world-bare	--chown=${_DVL}:${_DVL}	        ./hell/	        ./g0d/r00t/hell/
# # # COPY --from=dvlp_world-bare	--chown=r00t:r00t	            ./r00t/     	    ./g0d/r00t/
# # # COPY --from=dvlp_world-bare	--chown=g0d:g0d 	            ./r00t/	            ./g0d/
#temp

# RUN \
#     chroot --userspec=g0d:g0d /g0d addgroup --gid 4320 --force-badname w0rld

# RUN \
#     chroot --userspec=g0d:g0d /g0d/r00t addgroup --gid 4323 --force-badname g0d && \
#     # chroot --userspec=g0d:g0d /g0d/r00t addgroup --gid 4322 --force-badname r00t && \
#     chroot --userspec=g0d:g0d /g0d/r00t addgroup --gid 4320 --force-badname w0rld && \
#     # useradd -s /bin/bash -u 0 -o -g r00t -G w0rld -d /g0d/r00t --root /g0d/r00t r00t && \
#     # useradd -s /bin/bash -G r00t,w0rld -m --root /g0d/r00t --root /g0d/r00t r00T && \
#     chroot --userspec=g0d:g0d /g0d/r00t usermod -aG sudo ${_AGL}

# RUN ln -s /r00t/hell /g0d/r00t/hell && \
#     ln -s /r00t/halo /g0d/r00t/halo
WORKDIR /