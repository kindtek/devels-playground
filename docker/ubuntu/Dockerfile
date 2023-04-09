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
ARG WORLDS=bare

################################### GITHUB REPO #####################################
########################
# dvlp_repo-build-prep #
########################
FROM ubuntu:latest AS dvlp_repo-build-prep
ARG _MNT
ARG REFRESH_REPO
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
USER root
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
    --mount=type=cache,target=/tmp/git/cache,sharing=locked  \
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

########################
# dvlp_repo-build-lite #
#######################
FROM dvlp_repo-build-prep AS dvlp_repo-build-lite
WORKDIR /
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked  \
    git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw-lite || (cd dvlw && git pull) 
WORKDIR /dvlw-lite
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    ((git submodule init -- dvlp && git submodule update --init --remote --depth=1 --progress -- dvlp )|| git pull dvlp) && \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak

###################
# dvlp_repo-build #
###################
FROM dvlp_repo-build-lite AS dvlp_repo-build
WORKDIR /
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git clone https://github.com/kindtek/devels-workshop --progress dvlw || (cd dvlw && git pull) 
WORKDIR /dvlw
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --progress -- dvlp || git pull && \
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak
WORKDIR /dvlw/dvlp
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    ( git submodule update --init --progress || git submodule update --init --progress --force --rebase -- kernels ) 
# (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)


########################
# dvlp_repo-build-lite #
#######################
FROM scratch AS dvlp_repo-lite
COPY --from=dvlp_repo-build-lite ./dvlw-lite/ ./dvlw/
FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./dvlw/ ./dvlw/

####################### BASE DIRS AND VOLUME MOUNT POINTS ####################################
########################
# dvlp_base-devel-dirs #
########################
FROM ubuntu:latest AS dvlp_base-devel-dirs
ARG _MNT
ARG _DVL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hel
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_DVL} && \
    cp -rv * /home/${_DVL}
WORKDIR ${_MNT}
RUN ln -fsv ${_MNT}/bak/${_DVL} bak
# ln -fsv ${_MNT}/bak/${_DVL} /home/${_DVL}/bak 
WORKDIR /

################################
#  dvlp_base-devel-kernel-dirs #
################################
FROM dvlp_base-devel-dirs AS dvlp_base-devel-kernel-dirs
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

#########################
#  dvlp_base-angel-dirs #
#########################
FROM ubuntu:latest AS dvlp_base-angel-dirs
ARG _MNT
ARG _AGL_USR
ENV _AGL=${_AGL_USR:-agl}
WORKDIR /hal
COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./
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

################################
#  dvlp_base-angel-kernel-dirs #
################################
FROM dvlp_base-angel-dirs AS dvlp_base-angel-kernel-dirs
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


########################
#  dvlp_base-r00t-dirs #
########################
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

###############################
#  dvlp_base-r00t-kernel-dirs #
###############################
FROM dvlp_base-r00t-dirs AS dvlp_base-r00t-kernel-dirs
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
COPY --from=dvlp_base-r00t-kernel-dirs  --chown=r00t:r00t           ./admin/                ./r00t/ 
COPY --from=dvlp_base-r00t-kernel-dirs                              ./admin/                ./home/r00t/
COPY --from=dvlp_base-r00t-kernel-dirs                              ./mnt/                  ./${_MNT}/
COPY --from=dvlp_repo                   --chown=${_DVL}:${_DVL}     ./dvlw/dvlp/mnt/home/   ./hel/
COPY --from=dvlp_repo                   --chown=${_AGL}:${_AGL}     ./dvlw/dvlp/mnt/home/   ./hal/
COPY --from=dvlp_repo                   --chown=r00t:r00t           ./dvlw/dvlp/mnt/home/   ./r00t/
COPY --from=dvlp_repo                   --chown=r00t:${_AGL}        ./dvlw/dvlp/mnt/        .${_MNT}/
COPY --from=dvlp_repo                                               ./dvlw/                 ./dvlw/

#############
# dvlp_skel #
#############
FROM dvlp_skel-build-lite AS dvlp_skel
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

FROM dvlp_skel-build-lite AS dvlp_skel-lite

#################################################################################
############################### IMAGE BASES #####################################
################################################################################

################################## BARE #########################################
############
# dvlp_base-bare #
############
FROM dvlp_skel-build-lite AS dvlp_base-bare
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hel
USER ${_DVL}

################################### GIT #########################################
#################
# dvlp_base-git_lite #
#################
FROM dvlp_skel-build-lite AS dvlp_base-git-lite
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
# dvlp_base-git #
############
FROM dvlp_skel AS dvlp_base-git
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
# dvlp_base-python-build #
#####################
FROM dvlp_skel-build-lite AS dvlp_base-python-build
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
USER root
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
###############################
# dvlp_base-python-build-lite #
###############################
FROM dvlp_skel-build-lite AS dvlp_base-python-build-lite
USER root
ARG angel_exists=true
ARG devel_exists=true
ARG r00t_exists=true
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install jq python3-pip python3-venv
RUN  ( $angel_exists && (chown -R ${_AGL}:${_AGL} /hal || chown -R ${_AGL}:${_AGL} /hel/.local || angel_exists=false )) 
# USER ${_AGL}
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps || angel_exists=false
#     pip3 install cdir --user || angel_exists=false
# USER r00t
# RUN \
#     --mount=type=cache,target=/var/cache/pip,sharing=private \
#     $r00t_exists && pip3 install pip --upgrade --no-warn-script-location --no-deps && \
#     pip3 install cdir --user || r00t_exists=false
RUN ( $devel_exists && (chown -R ${_DVL}:${_DVL} /hel || chown -R ${_DVL}:${_DVL} /hel/.local || devel_exists=false )) 
USER ${_DVL}
# RUN \
#     --mount=type=cache,target=/var/cache/pip,sharing=private \
#     $devel_exists && pip3 install pip --upgrade --no-warn-script-location --no-deps && \
#     pip3 install cdir --user || devel_exists=false

#########################
# dvlp_base-python-lite #
#########################
FROM dvlp_base-git-lite AS dvlp_base-python-lite
USER root
WORKDIR / 
COPY --from=dvlp_base-python-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

####################
# dvlp_base-python #
###################
FROM dvlp_base-git-lite AS dvlp_base-python
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
WORKDIR / 
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-python-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

############################# POWERHELL #########################################
##############################
# dvlp_base-msdot-build-lite #
#############################
FROM dvlp_skel-build-lite AS dvlp_base-msdot-build-lite
USER root
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

#########################
# dvlp_base-msdot-build #
#########################
FROM dvlp_base-msdot-build-lite AS dvlp_base-msdot-build
USER root
RUN apt-get -y update && \
    apt-get -y install dotnet-sdk-7.0 
WORKDIR /hel
USER ${_DVL}

########################
# dvlp_base-msdot-lite #
########################
FROM dvlp_base-git-lite AS dvlp_base-msdot-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
WORKDIR /hel
USER ${_DVL}

###################
# dvlp_base-msdot #
###################
FROM dvlp_base-git-lite AS dvlp_base-msdot
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
WORKDIR /hel
USER ${_DVL}

########################## DOCKER IN DOCKER ######################################
########################
# dvlp_base-dind-build #
########################
FROM dvlp_skel-build-lite AS dvlp_base-dind-build
USER root
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

#######################
# dvlp_base-dind-lite #
#######################
FROM dvlp_base-git-lite AS dvlp_base-dind-lite
USER root
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
WORKDIR /hel
USER ${_DVL}

##################
# dvlp_base-dind #
##################
FROM dvlp_base-git-lite AS dvlp_base-dind
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
COPY --from=dvlp_base-dind-build ./ ./
WORKDIR /hel
USER ${_DVL}

############################### KERNEL #########################################
##########################
# dvlp_base-kernel-build #
##########################
FROM dvlp_skel-build AS dvlp_base-kernel-build
USER root
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

######################################################################################
###################  dvlp_base-kernel-builder - KERNEL BUILDER  ######################
######################################################################################
FROM dvlp_base-git AS dvlp_base-kernel-builder
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER root
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
COPY --from=dvlp_base-kernel-build ./ ./
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hel
USER ${_DVL}

######################################################################################
########################  dvlp_kernel-make - KERNEL COMPILER  ########################
######################################################################################
FROM dvlp_base-kernel-builder AS dvlp_kernel-make
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER root
WORKDIR /
# COPY --from=dvlp_skel-build ./ ./
WORKDIR /hel/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN chmod +x build-basic-wsl-kernel.sh
RUN bash build-${KERNEL_TYPE}-kernel.sh
# RUN bash make-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" ${_AGL}
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hel
USER ${_DVL}

#################################### GUI ######################################
######################
# dvlp_base-gui-lite #
######################
# wsl2 required
FROM dvlp_base-git-lite AS dvlp_base-gui-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
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
COPY --from=dvlp_repo-lite --chown=r00t:r00t /dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/${_DVL} && \
WORKDIR /hel
USER ${_DVL}

#################
# dvlp_base-gui #
#################
# wsl2 required
FROM dvlp_base-gui-lite AS dvlp_base-gui
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
USER root
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
COPY --from=dvlp_repo-lite --chown=r00t:r00t /dvlw/dvlp/mnt/etc/* /etc/

USER ${_DVL}

######################
# dvlp_base-gui-plus #
#####################
FROM dvlp_base-kernel-builder AS dvlp_base-gui-plus
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /
COPY --from=dvlp_base-gui ./ ./
WORKDIR /hel
USER ${_DVL}

############################## CUDA ###############################
##################
# dvlp_base-cuda #
##################
FROM dvlp_base-git-lite AS dvlp_base-cuda
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
COPY --from=dvlp_base-kernel-build ./ ./
# COPY --from=dvlp_base-kernel-lite ./ ./
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

#######################
# dvlp_base-cuda-plus #
#######################
FROM dvlp_base-git AS dvlp_base-cuda-plus
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER root
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
COPY --from=dvlp_base-dind-build ./ ./
COPY --from=dvlp_base-kernel-builder ./ ./
COPY --from=dvlp_base-cuda ./ ./
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y install nvidia-cuda-toolkit
WORKDIR /hel
USER ${_DVL}

###################################################################
########################### OUTPUT ################################
###################################################################
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

########################### WORLDS ################################
#########################
# dvlp_worlds-skel-lite #
#########################
FROM ubuntu:latest AS dvlp_worlds-skel-lite
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
WORKDIR /

COPY --from=dvlp_base-r00t-dirs                         ./admin/    ./hell/g0d/
COPY --from=dvlp_base-r00t-dirs                         ./admin/    ./hell/r00t/
COPY --from=dvlp_base-devel-dirs                        ./hel/      ./hell/hel/
COPY --from=dvlp_base-r00t-dirs                         ./mnt/      ./hell/${_MNT}/
####
COPY --from=dvlp_base-r00t-dirs                         ./admin/    ./halo/g0d/
COPY --from=dvlp_base-r00t-dirs                         ./admin/    ./halo/r00t/
# COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:halo  ./hal/      ./halo/hal/
COPY --from=dvlp_base-r00t-dirs                         ./mnt/      ./halo/${_MNT}/

COPY --from=dvlp_skel-lite	            	            ./	        ./
COPY --from=dvlp_skel-lite              	            ./	        ./halo/
COPY --from=dvlp_base-angel-dirs --chown=${_AGL}:halo   ./hal/      ./halo/hal/
COPY --from=dvlp_skel-lite	            	            ./	        ./hell/

###############
# dvlp_worlds #
###############
FROM dvlp_worlds-skel-lite AS dvlp_worlds
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
WORKDIR /
# COPY --from=dvlp_repo-lite ./dvlw/dvlp/mnt/home/ ./etc/skel/
USER root
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections  && \
    # add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get -y install sudo
RUN groupadd            r00t && \        
    # && \
    # groupadd: cannot lock /etc/group; try again later.
    # RUN groupadd            r00t   --root /r00t 
    # && \
    groupadd            r00t   --root /halo && \
    groupadd            r00t   --root /hell && \
    groupadd            w0rld               && \
    groupadd            w0rld  --root /hell && \
    groupadd            w0rld  --root /halo && \
    groupadd            hell   --root /hell && \
    groupadd            halo   --root /halo && \
    groupadd --gid 4325 g0d                 && \
    useradd -s /bin/bash    -u 0   -o  -g root -G g0d,r00t,w0rld  -d /g0d                          g0d && \
    useradd -s /bin/bash    -u 0   -o  -g root -G r00t,w0rld      -d /r00t         --root /halo    r00t && \
    useradd -s /bin/bash    -u 0   -o  -g root -G hell,w0rld      -d /hell/hel     --root /hell    ${_DVL} && \
    useradd -s /bin/bash               -g halo -G w0rld           -d /halo/hal     --root /halo    ${_AGL} && \
    passwd -d g0d && \
    passwd -d root && \
    passwd -l root 
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./g0d/
COPY --from=dvlp_base-r00t-dirs                     ./admin/    ./r00t/
COPY --from=dvlp_base-devel-dirs                     ./hel/      ./hel/
COPY --from=dvlp_base-angel-dirs                     ./hal/      ./hal/
RUN chroot --userspec=g0d:g0d /halo usermod -aG sudo ${_AGL} 
WORKDIR /

####################
# dvlp_kernel-dirs #
####################
FROM dvlp_worlds AS dvlp_kernel-dirs
ARG _AGL
COPY --from=dvlp_skel-build	            	            ./	        ./
COPY --from=dvlp_skel-build	            	            ./	        ./halo/
COPY --from=dvlp_skel-build	            	            ./	        ./hell/
COPY --from=dvlp_base-devel-kernel-dirs                     ./hel/      ./hel/
COPY --from=dvlp_base-angel-kernel-dirs                     ./hal/      ./hal/
COPY --from=dvlp_base-r00t-kernel-dirs                     ./admin/    ./g0d/
COPY --from=dvlp_base-r00t-kernel-dirs                     ./admin/    ./r00t/
USER g0d
WORKDIR /

####################
# dvlp_worlds-plus #
###################
FROM ubuntu:latest AS dvlp_worlds-plus
# COPY --from=dvlp_worlds                                 ./          ./
# COPY --from=dvlp_base-python-build-lite                 ./          ./
# COPY --from=dvlp_base-python-build-lite                 ./          ./halo/
# COPY --from=dvlp_base-python-build-lite                 ./          ./hell/
COPY --from=dvlp_worlds                                 ./          ./
# RUN chroot --userspec=${_AGL}:halo  /halo pip install cdir --user
# RUN chroot --userspec=r00t:r00t     /halo pip install cdir --user
# RUN chroot --userspec=r00t:r00t     /hell pip install cdir --user
# RUN chroot --userspec=${_DVL}:hell  /hell pip install cdir --user

#########################
# dvlp_kernel-dirs-plus #
#########################
FROM dvlp_kernel-dirs AS dvlp_kernel-dirs-plus
# COPY --from=dvlp_base-python-build-lite                  ./          ./
# COPY --from=dvlp_base-python-build-lite                  ./          ./halo/
# COPY --from=dvlp_base-python-build-lite                  ./          ./hell/
COPY --from=dvlp_kernel-dirs                            ./          ./
COPY --from=dvlp_worlds-plus                            ./          ./
# RUN chroot --userspec=${_AGL}:halo  /halo pip install cdir && \
#     chroot --userspec=r00t:r00t     /halo pip install cdir && \
#     chroot --userspec=${_DVl}:hell  /hell pip install cdir

#################
# dvlp_gui-plus #
#################
FROM dvlp_worlds-skel-lite AS dvlp_gui-plus
COPY --from=dvlp_base-gui-plus                          ./          ./
COPY --from=dvlp_base-gui-plus	            	        ./	        ./halo/
COPY --from=dvlp_base-gui-plus	            	        ./	        ./hell/
COPY --from=dvlp_kernel-dirs-plus                       ./          ./
USER g0d

WORKDIR /

############
# dvlp_gui #
############
FROM dvlp_worlds-skel-lite AS dvlp_gui
COPY --from=dvlp_base-gui                               ./          ./
COPY --from=dvlp_base-gui	            	            ./	        ./halo/
COPY --from=dvlp_base-gui	            	            ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /

#################
# dvlp_gui-lite #
#################
FROM dvlp_worlds-skel-lite AS dvlp_gui-lite
COPY --from=dvlp_base-gui-lite                               ./          ./
COPY --from=dvlp_base-gui-lite	            	            ./	        ./halo/
COPY --from=dvlp_base-gui-lite	            	            ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /

###################
# dvlp_dind-lite #
##################
FROM dvlp_worlds-skel-lite AS dvlp_dind-lite
COPY --from=dvlp_base-dind-lite                         ./          ./
COPY --from=dvlp_base-dind-lite	            	        ./	        ./halo/
COPY --from=dvlp_base-dind-lite	            	        ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
WORKDIR /

############
# dvlp_git #
############
FROM dvlp_worlds-skel-lite AS dvlp_git
COPY --from=dvlp_base-git                               ./          ./
COPY --from=dvlp_base-git	            	            ./	        ./halo/
COPY --from=dvlp_base-git	            	            ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /
########################
# dvlp_git-lite #
########################
FROM dvlp_worlds-skel-lite AS dvlp_git-lite
COPY --from=dvlp_base-git-lite                          ./          ./
COPY --from=dvlp_base-git-lite	            	        ./	        ./halo/
COPY --from=dvlp_base-git-lite	            	        ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /

####################
# dvlp_ms-dot-lite #
####################
FROM dvlp_worlds-skel-lite AS dvlp_msdot-lite
COPY --from=dvlp_base-msdot-lite                       ./          ./
COPY --from=dvlp_base-msdot-lite	            	    ./	        ./halo/
COPY --from=dvlp_base-msdot-lite	            	    ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /


####################
# dvlp_python-lite #
####################
FROM dvlp_worlds-skel-lite AS dvlp_python-lite
COPY --from=dvlp_base-python-lite                       ./          ./
COPY --from=dvlp_base-python-lite	            	    ./	        ./halo/
COPY --from=dvlp_base-python-lite	            	    ./	        ./hell/
COPY --from=dvlp_worlds-plus                            ./          ./
USER g0d
WORKDIR /

#############
# dvlp_bare #
#############
FROM dvlp_worlds-skel-lite AS dvlp_bare
COPY --from=dvlp_base-bare                              ./          ./
COPY --from=dvlp_base-bare	            	            ./	        ./halo/
COPY --from=dvlp_base-bare	            	            ./	        ./hell/
COPY --from=dvlp_worlds                                 ./          ./
USER g0d
WORKDIR /

#############
# dvlp_cuda #
#############
FROM dvlp_worlds-skel-lite AS dvlp_cuda
COPY --from=dvlp_base-cuda                          ./          ./
COPY --from=dvlp_base-cuda	            	        ./	        ./halo/
COPY --from=dvlp_base-cuda	            	        ./	        ./hell/
COPY --from=dvlp_worlds-plus                             ./          ./
USER g0d
WORKDIR /

##################
# dvlp_cuda-plus #
##################
FROM dvlp_worlds-skel-lite AS dvlp_cuda-plus
COPY --from=dvlp_base-cuda-plus                          ./          ./
COPY --from=dvlp_base-cuda-plus	            	        ./	        ./halo/
COPY --from=dvlp_base-cuda-plus	            	        ./	        ./hell/
COPY --from=dvlp_worlds-plus                             ./          ./
USER g0d
WORKDIR /