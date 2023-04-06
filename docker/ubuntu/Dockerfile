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
ARG _AGL_USR=${_AGL:-angel}
ARG _DVL_USR=${_DVL:-devel}
ARG _MNT=${_MNT:-/mnt/data}

# ${_DVL} permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_devel-lite
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hel
RUN mkdir -pv /home/${_DVL} && \
    # mkdir -pv /home/${_DVL}/dvlw && \
    mkdir -pv /home/${_DVL}/dls && \
    # mkdir -pv /fs && \
    mkdir -pv /hel && \
    mkdir -pv /hell && \
    mkdir -pv /hell/hel && \
    mkdir -pv /hell/dvlw && \
    mkdir -pv /hel/dls && \
    mkdir -pv /hell/dls && \
    # mkdir -pv /hell/hal && \
    mkdir -pv /hell/hel/dls && \
    mkdir -pv /hell/hel/dvlw && \
    mkdir -pv ${_MNT}/bak/${_DVL} && \
    chmod 753 ${_MNT}/bak/${_DVL} && \
    ln -fsv ${_MNT}/bak/${_DVL} /home/${_DVL}/bak && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose  -d /home/${_DVL} && \
# install --verbose  -d /hel && \
# install --verbose  -d /hell && \
# install --verbose  -m 753 -d ${_MNT}/bak/${_DVL} && \
# ln -fsv ${_MNT}/bak/${_DVL} /home/${_DVL}/bak 

# agl permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_angel-lite
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hal
RUN mkdir -pv /home/${_AGL} && \
    mkdir -pv /home/${_AGL}/dvlw && \
    mkdir -pv /home/${_AGL}/dls && \
    # mkdir -pv /fs && \
    mkdir -pv /hal && \
    mkdir -pv /halo && \
    mkdir -pv /halo/hal && \
    mkdir -pv /halo/dvlw && \
    mkdir -pv /hal/dls && \
    mkdir -pv /halo/dls && \
    # mkdir -pv /halo/hel && \
    mkdir -pv /halo/hal/dls && \
    mkdir -pv /halo/hal/dvlw && \
    mkdir -pv ${_MNT}/bak/${_AGL} && \
    chmod 753 ${_MNT}/bak/${_AGL} && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose -d /home/${_AGL} && \
#     install --verbose -d /halo  && \
#     install --verbose -d /halo/hal  && \
#     install --verbose -m 753 -d ${_MNT}/bak/${_AGL} && \
#     ln -fsv ${_MNT}/bak/${_AGL} /home/${_AGL}/bak


# r00t permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_r00t-lite
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
WORKDIR /root/r00t
RUN mkdir -pv /home/r00t && \
    mkdir -pv /home/r00t/dls && \
    mkdir -pv /home/r00t/dvlw && \
    mkdir -pv /root/r00t && \
    mkdir -pv /root/dls && \
    mkdir -pv ${_MNT}/dls && \
    mkdir -pv ${_MNT}/bak && \
    mkdir -pv ${_MNT}/etc && \
    mkdir -pv ${_MNT}/home && \
    mkdir -pv ${_MNT}/opt && \
    mkdir -pv /root/dvlw && \
    mkdir -pv /root/r00t/dls && \
    mkdir -pv /root/r00t/dvlw && \
    mkdir -pv /dls && \
    # mkdir -pv /fs && \
    mkdir -pv /dvlw && \
    ln -fsv /root/r00t/halo /halo && \
    ln -fsv /root/r00t/hell /hell  && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose -d /root && \
#     install --verbose -d /home/r00t && \
#     install --verbose -d /root && \
#     install --verbose -d /dls && \
#     install --verbose -d /fs
# && \
# install -o ${_AGL} -g halo -d halo && \
# install -o ${_DVL} -g hell -d hell 
# && \
#     ln -sv /home/r00t/bak /mnt/data/bak 

FROM ubuntu:latest AS dvlp_base-fs_devel
ARG _MNT
WORKDIR /hel
# RUN install -o ${_DVL} -g hell -d /home/${_DVL} /hel /hell && \
# ln -fsv /home/${_DVL} /hel && \
# ln -fsv /home/${_DVL} /hell && \
# ln -sfv /home/${_DVL} /home/${_DVL} && \
RUN mkdir -pv /hel && ln -fsv dvlw devels-workshop && \
    mkdir -pv /hal/built-kernels && \
    mkdir -pv /halo/hal/built-kernels && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels
WORKDIR /


FROM ubuntu:latest AS dvlp_base-fs_angel
ARG _MNT
WORKDIR /hal
RUN mkdir -pv /hal && ln -fsv dvlw devels-workshop && \
    mkdir -pv /hal/built-kernels && \
    mkdir -pv /halo/hal/built-kernels && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
WORKDIR /

FROM ubuntu:latest AS dvlp_base-fs_r00t
ARG _MNT
WORKDIR /root/r00t
RUN mkdir -pv /root/r00t && ln -fsv dvlw devels-workshop && \
    mkdir -pv /root/r00t/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
WORKDIR /


# FROM scratch AS dvlp_base-fs_permissions
# #COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./hel ./hel
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./hell ./hell
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./home ./home
# COPY --from=dvlp_base-fs_devel --chown=${_AGL}:${_DVL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./hal ./hal
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./halo ./halo
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./home ./home
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./home ./home
# # COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./root/r00t ./root/r00t
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./root/r00t ./root/r00t
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./fs ./fs

# FROM scratch AS dvlp_base-fs_permissions-lite
# COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./hel ./hel
# # COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./hell ./hell
# COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./home ./home
# COPY --from=dvlp_base-fs_devel-lite --chown=${_AGL}:${_DVL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./hal ./hal
# # COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./halo ./halo
# COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./home ./home
# COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./mnt ./mnt

# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./home ./home
# # COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./root/r00t ./root/r00t
# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./root ./root
# # COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./fs ./fs


############################## BASE ####################################
#############
# dvlp_base-fs_fs #
#############
FROM ubuntu:latest AS dvlp_base-fs-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _MNT
ENV _AGL=${_AGL_USR:-angel}
ENV _DVL=${_DVL_USR:-devel}
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
    # add-apt-repository ppa:apt-fast/stable && \
    rm -rf /etc/skel && \
    apt-get update -y && \
    apt-get upgrade -y 
#   apt-get -y install apt-fast

# adduser --home /home/r00t --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS r00t && \
RUN addgroup --gid 4321 --force-badname r00t  && \
    addgroup --gid 777 ${_AGL} && \
    addgroup --gid 666 ${_DVL} && \
    useradd -s /bin/bash  -u 0 -o -g root -G r00t,${_AGL},${_DVL} -d /root/r00t r00t && \
    useradd -s /bin/bash  -u 0 -o -g root -G angel,devel -d /test test && \
    rm -rf /root && mkdir -pv /root/r00t && \
    # usermod -aG r00t r00t  && \
    # usermod -g 0 -u 0 -o r00t  && \
    chown -R r00t:r00t /root  && \
    # usermod -g 0 -u 0 -o r00t  && \
    # usermod -d /root/r00t r00t && \
    passwd -d r00t && \
    # passwd -d ${_AGL} && \
    # passwd -d ${_DVL} && \
    passwd -l r00t && \
    passwd -d root && \
    passwd -l test && \
    passwd -d test && \
    # passwd -d ${_AGL} && \
    # passwd -d ${_DVL} && \
    passwd -l root  && \
    echo "[user] \
    default=${_DVL}" >> /etc/wsl.conf 
USER r00t
# adduser --home /home/${_AGL} --ingroup halo --shell /bin/bash --uid ${_AGL} --disabled-password --gecos GECOS ${_AGL} && \
# adduser --home /home/${_DVL} --ingroup hell --shell /bin/bash --uid ${_DVL} --disabled-password --gecos GECOS ${_DVL} && \
#    RUN adduser --shell /bin/bash --uid 777 --gid 777  --disabled-password --gecos GECOS --no-create-home ${_AGL} && \
#     adduser --shell /bin/bash --uid 666 --gid 777 --disabled-password --gecos GECOS --no-create-home ${_DVL} 

# usermod -aG r00t && \
# rm -rf /home/r00t* && rm -rf /root/r00t* && \
# rm -rf /home/${_DVL}/* && rm -rf /home/${_AGL}/* && \
# add ${_AGL} to the list
# add r00t to both groups
# ensure no passwords
# make ${_DVL} default wsl user 
# run as r00t asap
# COPY --from=dvlp_base-fs_permissions ./ ./
WORKDIR /
COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./hel/      ./hel/
COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./hell/     ./hell/
COPY --from=dvlp_base-fs_devel-lite --chown=${_DVL}:${_DVL} ./home/${_DVL}/ ./home/${_DVL}/
##############################################################
COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./hal/      ./hal/
COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./halo/     ./halo/
COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} ./home/${_AGL}/ ./home/${_AGL}/
COPY --from=dvlp_base-fs_angel-lite --chown=${_AGL}:${_AGL} .${_MNT}/bak/   .${_MNT}/bak/
##############################################################
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        ./root/     ./root/
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        ./home/r00t/     ./home/r00t/
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        ./mnt/      ./mnt/
# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t ./ ./
# COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        ./mnt/dls/   ./mnt/dls/
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        .${_MNT}/etc/   .${_MNT}/etc/
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        .${_MNT}/home/  .${_MNT}/home/
COPY --from=dvlp_base-fs_r00t-lite --chown=r00t:r00t        .${_MNT}/opt/   .${_MNT}/opt/
##############################################################

RUN useradd -s /bin/bash  -u 666 -o -g ${_DVL} -d /hel ${_DVL} 
RUN useradd -s /bin/bash  -u 777 -o -g ${_AGL} -d /hal ${_AGL}  
RUN passwd -d ${_AGL}  && \
    passwd -d ${_DVL} 
RUN apt-get -y install sudo && \
    usermod -aG sudo ${_AGL}  
#     # chown r00t:r00t /fs && \
#     # cp -r /lib /usr /mnt /bin /opt /lib64 /tmp /sbin /media /etc /root /boot /var /fs && \
# # apt-get -y install debootstrap && \
# # debootstrap sid chroot && \
#     # # useradd -s /bin/bash  -u 0 -o -g root -G r00t,${_AGL},${_DVL} -d /root/r00t --root /fs god && \
#     # useradd -s /bin/bash  -u 0  -o -g root -G ${_DVL} -d /hel --root /fs ${_DVL} && \
#     # useradd -s /bin/bash  -u 777 -o -g root -G agl -d /hal --root /fs ${_AGL}     
# RUN chroot --userspec=r00t:r00t /fs usermod -aG sudo ${_AGL} && \
#     chroot --userspec=r00t:r00t /fs echo "[user] \
#     default=${_DVL}" >> /etc/wsl.conf && \
#     chroot --userspec=r00t:r00t /fs passwd -d ${_AGL} && \
#     chroot --userspec=r00t:r00t /fs passwd -d ${_DVL}
FROM dvlp_base-fs-lite AS dvlp_base-fs
ARG _AGL_USR
ARG _DVL_USR
ARG _MNT
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
USER r00t
WORKDIR /
COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./hel/ ./hel/
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./hell/ ./hell/
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./home/${_DVL}/ ./home/${_DVL}/
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./mnt/bak/dvl/ ./mnt/bak/dvl/

COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./hal/ ./hal/
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./halo/ ./halo/
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} ./home/${_AGL}/ ./home/${_AGL}/
# COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL} .${_MNT}/bak/   .${_MNT}/bak/

COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        ./root/          ./root/
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        ./home/r00t/     ./home/r00t/
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t ./ ./
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        .${_MNT}/dls/   .${_MNT}/dls/
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        .${_MNT}/etc/   .${_MNT}/etc/
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        .${_MNT}/home/  .${_MNT}/home/
# COPY --from=dvlp_base-fs_r00t --chown=r00t:r00t        .${_MNT}/opt/   .${_MNT}/opt/

################################### REPO ####################################
#############
# dvlp_repo #
#############
FROM dvlp_base-fs-lite AS dvlp_repo-build-prep
ARG _MNT
ARG REFRESH_REPO
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
USER r00t
WORKDIR /
# RUN mkdir -p /tmp/git/cache && \
# chown -R r00t:r00t /tmp/git/cache && \
#     mkdir -p /dvlw && \
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
    git config --global --add safe.directory /hal && \
    git config --global --add safe.directory /hal/dvlw && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /hel/dvlw && \
    git config --global --add safe.directory / && \
    git config --global --add safe.directory /root && \
    git config --global --add safe.directory /root/r00t && \
    git config --global --add safe.directory /dvlw/ && \
    git config --global --add safe.directory /tmp/git/cache

FROM dvlp_repo-build-prep AS dvlp_repo-build-lite
USER r00t
WORKDIR /
# COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL} ./hell/ ./hell/

# clone fresh repos and give ${_DVL} ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /dvlw
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --progress -- dvlp || git pull \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak

FROM dvlp_repo-build-lite AS dvlp_repo-build
USER r00t
WORKDIR /
COPY --from=dvlp_base-fs ./home/ ./home/
COPY --from=dvlp_base-fs ./mnt/ ./mnt/
COPY --from=dvlp_base-fs ./hel/ ./hel/
COPY --from=dvlp_base-fs ./hal/ ./hal/
COPY --from=dvlp_base-fs ./root/r00t/ ./root/r00t/
# clone fresh repos and give ${_DVL} ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
# RUN \
#     --mount=type=cache,target=/tmp/git/cache \
#     git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
# WORKDIR /dvlw
# # RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
# RUN \
#     --mount=type=cache,target=/tmp/git/cache,sharing=locked \
#     git submodule update --init --remote --progress || git pull 
# WORKDIR /dvlw/dvlp
# # RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
# RUN \
#     --mount=type=cache,target=/tmp/git/cache,sharing=locked \
#     ( git submodule update --init --progress ||     git submodule update --init --progress --force --rebase -- kernels ) && \
#     # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)
#     chmod -R +x mnt/home && \
#     chmod -R +x mnt/bak

# RUN if [ "$REFRESH_REPO" != no ]; then git pull; fi    

FROM scratch AS dvlp_repo-lite
COPY --from=dvlp_repo-build-lite ./dvlw/ ./dvlw/
FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./dvlw/ ./dvlw/

############################## SKELETON ###################################
########################
# dvlp_skel-build-lite #
########################
FROM dvlp_repo-build-lite AS dvlp_skel-build-lite
ARG REFRESH_REPO
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /

COPY --from=dvlp_repo-lite               --chown=${_DVL}:${_DVL}    ./dvlw/dvlp/mnt/home/  ./hel/
COPY --from=dvlp_repo-lite               --chown=${_AGL}:${_AGL}    ./dvlw/dvlp/mnt/home/  ./hal/
COPY --from=dvlp_repo-lite               --chown=r00t:r00t          ./dvlw/dvlp/mnt/home/  ./root/r00t/
COPY --from=dvlp_repo-lite               --chown=r00t:${_AGL}       ./dvlw/dvlp/mnt/       .${_MNT}/

## WORKDIR /hell
###################
# dvlp_skel-build #
###################
FROM dvlp_repo-build-lite AS dvlp_skel-build
ARG _MNT
ARG REFRESH_REPO
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_repo                --chown=${_DVL}:${_DVL}    ./dvlw/dvlp/mnt/home/  ./hel/
COPY --from=dvlp_repo                --chown=${_AGL}:${_AGL}    ./dvlw/dvlp/mnt/home/  ./hal/
COPY --from=dvlp_repo                --chown=r00t:r00t          ./dvlw/dvlp/mnt/home/  ./root/r00t/
COPY --from=dvlp_repo                --chown=r00t:${_AGL}       ./dvlw/dvlp/mnt/       .${_MNT}/

# COPY --from=dvlp_skel-build-lite --chown=r00t:${_AGL}      .${_MNT}/   .${_MNT}/
# COPY --from=dvlp_skel-build-lite --chown=${_AGL}:${_AGL}      .${_MNT}/bak .${_MNT}/bak
# COPY --from=dvlp_skel-build-lite --chown=${_DVL}:${_DVL}       ./hel/          ./hel/
# COPY --from=dvlp_skel-build-lite --chown=${_AGL}:${_AGL}       ./hal/          ./hal/
# COPY --from=dvlp_skel-build-lite --chown=r00t:r00t     ./root/r00t/    ./root/r00t/

# COPY --from=dvlp_base-fs ./etc/passwd ./etc/passwd
# COPY --from=dvlp_base-fs ./etc/group ./etc/group
# # COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# # COPY --from=dvlp_base-fs_devel  --chown=${_DVL}:${_DVL}    ./home/${_DVL}/     ./home/${_DVL}/
# # COPY --from=dvlp_base-fs_angel  --chown=${_AGL}:${_AGL}    ./home/${_AGL}/     ./home/${_AGL}/
# # COPY --from=dvlp_base-fs_r00t   --chown=r00t:r00t  ./home/r00t/    ./home/r00t/
# # # COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL}   .${_MNT}    .${_MNT}
# # # COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL}   .${_MNT}    .${_MNT}
# COPY --from=dvlp_repo           --chown=${_DVL}:${_DVL}    ./home/${_DVL}/dvlw/dvlp/mnt/home/  ./home/${_DVL}/
# COPY --from=dvlp_repo           --chown=${_AGL}:${_AGL}    ./home/${_DVL}/dvlw/dvlp/mnt/home/  ./home/${_AGL}/
# COPY --from=dvlp_repo           --chown=r00t:r00t  ./home/${_DVL}/dvlw/dvlp/mnt/home/  ./home/r00t/
# # COPY --from=dvlp_base-fs_devel  --chown=${_AGL}:${_AGL}    .${_MNT}/                   .${_MNT}/
# # COPY --from=dvlp_base-fs_angel  --chown=${_AGL}:${_AGL}    .${_MNT}/                   .${_MNT}/
# COPY --from=dvlp_repo           --chown=r00t:${_AGL}   ./home/${_DVL}/dvlw/dvlp/mnt/       .${_MNT}/
# # COPY --from=dvlp_repo           --chown=${_AGL}:${_AGL}    .${_MNT}                    .${_MNT}
# COPY --from=dvlp_base-fs_devel  --chown=${_DVL}:${_DVL}    ./home/${_DVL}/                     ./home/${_DVL}/
# COPY --from=dvlp_base-fs_angel  --chown=${_AGL}:${_AGL}    ./home/${_AGL}/                     ./home/${_AGL}/
# COPY --from=dvlp_base-fs_r00t   --chown=r00t:r00t  ./home/r00t/                    ./home/r00t/
# COPY --from=dvlp_base-fs_devel --chown=r00t:r00t ./home/${_DVL}/                     ./home/r00t/
# COPY --from=dvlp_base-fs_devel --chown=${_AGL}:${_AGL}   ./home/${_DVL}/                     ./home/${_AGL}/
# USER r00t
# WORKDIR /hell
# # SHELL ["/bin/bash", "-c"]
# USER devel
# WORKDIR /hell
# # # FROM dvlp_base-fs AS dvlp_base-fs2
# # # COPY --from=dvlp_skel-build --chown=r00t:r00t   ./ ./
#############
# dvlp_skel #
#############
FROM dvlp_skel-build AS dvlp_skel
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install apt-transport-https curl gh git gnupg2 libssl-dev nvi wget

# FROM dvlp_skel-prep AS dvlp_skel2
# # # RUN  cp -r /lib /usr /mnt /bin /opt /lib64 /tmp /home /sbin /media /etc /root /boot /var /fs
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./lib/ ./lib/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./usr/ ./usr/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./mnt/ ./mnt/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./bin/ ./bin/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./opt/ ./opt/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./lib64/ ./tmp/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./home/ ./home/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./sbin/ ./sbin/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./media/ ./media/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./etc/ ./etc/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./root/ ./root/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./boot/ ./boot/
# COPY --from=dvlp_skel-build --chown=r00t:r00t ./var/ ./var/

# RUN \
#     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
#     apt-get -y update && \
# add-apt-repository ppa:saiarcot895/myppa && \
# apt-get -y install apt-fast aria2 

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
# # COPY --from=dvlp_skel-build-lite --chown=r00t:r00t ./ ./
# # USER r00t
# # WORKDIR /halo
# # RUN chown r00t:r00t /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal ${_AGL} && chown -R ${_AGL}:${_AGL} /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel ${_DVL} && chown -R ${_DVL}:${_DVL} /hell
# # WORKDIR /root/r00t
# # RUN usermod -d /root/r00t r00t && chown -R r00t:r00t /root/r00t

# # lock down volumes, permissions
# FROM dvlp_skel-install AS dvlp_skel
# ARG REFRESH_REPO=${REFRESH_REPO:-no}
# WORKDIR /
# # COPY --from=dvlp_skel-build                       ./            ./
# COPY --from=dvlp_skel-install                     ./            ./
# # COPY --from=dvlp_skel-build    --chown=r00t:r00t ./            ./
# COPY --from=dvlp_skel-install  --chown=r00t:r00t ./            ./
# # COPY --from=dvlp_base-fs_devel --chown=${_DVL}:${_DVL}   ./home/${_DVL}/   ./home/${_DVL}/
# # COPY --from=dvlp_base-fs_angel --chown=${_AGL}:${_AGL}   ./home/${_AGL}/   ./home/${_AGL}/
# # COPY --from=dvlp_base-fs_r00t  --chown=r00t:r00t ./home/r00t/  ./home/r00t/
# # USER r00t
# # WORKDIR /halo
# # RUN chown r00t:r00t /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal ${_AGL} && chown -R ${_AGL}:${_AGL} /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel ${_DVL} && chown -R ${_DVL}:${_DVL} /hell && chown -R ${_DVL}:${_DVL} /hell 
# # WORKDIR /root/r00t
# # RUN usermod -d /root/r00t r00t && chown -R r00t:r00t /root/r00t

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_skel-build-lite AS dvlp_bare
ARG REFRESH_REPO
USER r00t
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-build-lite ./ ./
# COPY --from=dvlp_repo --chown=${_DVL}:${_DVL}  ./dvlw/ ./home/${_DVL}/dvlw/
WORKDIR /hel
USER devel

################################### GIT #########################################
#################
# dvlp_git_lite #
#################
FROM dvlp_skel-build AS dvlp_git-lite
ARG REFRESH_REPO
WORKDIR /hel
USER devel

############
# dvlp_git #
############
FROM dvlp_skel AS dvlp_git
ARG REFRESH_REPO
WORKDIR /hel
USER devel

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
USER devel

###############
# dvlp_python #
###############
FROM dvlp_git AS dvlp_python
USER r00t
WORKDIR / 
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER devel

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
USER devel

####################
# dvlp_msdot-build #
####################
FROM dvlp_msdot-build-lite AS dvlp_msdot-build
USER r00t
RUN apt-get -y update && \
    apt-get -y install dotnet-sdk-7.0 
WORKDIR /hel
USER devel

###################
# dvlp_msdot-lite #
###################
FROM dvlp_git-lite AS dvlp_msdot-lite
USER r00t
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
WORKDIR /hel
USER devel

##############
# dvlp_msdot #
##############
FROM dvlp_git-lite AS dvlp_msdot
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
WORKDIR /hel
USER devel

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
USER devel

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
USER devel

#############
# dvlp_dind #
#############
FROM dvlp_git-lite AS dvlp_dind
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /hel
USER devel

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
USER devel

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
USER devel

########################################################
###  dvlp_kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_kernel-builder AS dvlp_kernel-make
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER r00t
WORKDIR /
# COPY --from=dvlp_base-fs ./ ./
COPY --from=dvlp_skel-build ./ ./
COPY --from=dvlp_repo ./ ./
WORKDIR /hel/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN chmod +x build-basic-wsl-kernel.sh
RUN bash build-${KERNEL_TYPE}-kernel.sh
# RUN bash make-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" ${_AGL}
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hel
USER devel

#################################### GUI ######################################
#################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_git-lite AS dvlp_gui-lite
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
USER devel

############
# dvlp_gui #
############
# wsl2 required
FROM dvlp_gui-lite AS dvlp_gui
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
USER devel

#################
# dvlp_gui-plus #
#################
FROM dvlp_kernel-builder AS dvlp_gui-plus
ARG REFRESH_REPO
WORKDIR /
COPY --from=dvlp_gui ./ ./
WORKDIR /hel
USER devel

############################## CUDA ###############################
#############
# dvlp_cuda #
#############
FROM dvlp_git AS dvlp_cuda
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
USER devel

##################
# dvlp_cuda-plus #
##################
FROM dvlp_git AS dvlp_cuda-plus
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
USER devel

########################### OUTPUT ################################
#################
# KERNEL OUTPUT #
#################

FROM scratch AS dvlp_kernel-output
ARG CONFIG_FILE
WORKDIR /
COPY --from=dvlp_kernel-make ./built-kernel.tar.gz ./built-kernel.tar.gz

FROM dvlp_dind-lite AS docker-build-docker
WORKDIR /dvlw/dvlp/docker/ubuntu
RUN docker compose build gui-plus && \
    IMAGE_ID=$(docker compose build up --build --attach gui-plus 2>/dev/null | awk '/Successfully built/{print $NF}')

# docker buildx build --target=built-kernels --output type=local,dest=$(pwd)/out/ .
# docker buildx build -t dvlp_latest-rc-wsl-zfs-kernel-builder --output type=tar,dest=kubuntu22-plus-wsl-zfs-linux-kernel-6-28.tar  --build-arg CONFIG_FILE="https://raw.githubusercontent.com/kindtek/devels-playground/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0" .  2>&1 | tee latest-rc-wsl-zfs-kernel-builder-"$(date)".log
