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
ARG JACKET=bare

################################### GITHUB REPO #####################################
########################
# dvlp_repo-build-prep #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_repo-build-prep
ARG _MNT
ARG REFRESH_REPO
ARG _AGL_USR
ARG _DVL_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
# USER r00t
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
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get --reinstall -y install ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb 
# add git cache directory

# add safe directories
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked  \
    # if [ "$fresh_repo" != no ]; then rm -rf /tmp/git/cache/dvlw; fi && \
    # git config --global --add safe.directory /home/${_DVL} && \
    # git config --global --add safe.directory /home/${_AGL} && \
    git config --global --add safe.directory /hal && \
    git config --global --add safe.directory /hal/dvlw && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /hel/dvlw && \
    git config --global --add safe.directory / && \
    git config --global --add safe.directory /root && \
    git config --global --add safe.directory /r00t && \
    git config --global --add safe.directory /dvlw && \
    git config --global --add safe.directory /tmp/git/cache && \
    git config --global user.name 'Snail Mail' && \
    git config --global user.email '<>'

########################
# dvlp_repo-build #
#######################
FROM dvlp_repo-build-prep AS dvlp_repo-build
WORKDIR /
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked  \
    ( git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw-lite || git config pull.rebase false ) || \
    ( git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw-lite || git config pull.rebase true ) || \
    ( git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw-lite || git config pull.rebase false ) || \
    ( git clone https://github.com/kindtek/devels-workshop --depth=1 --progress dvlw-lite || git config pull.rebase true ) || \
    ( git clone https://github.com/kindtek/devels-workshop --depth=1 --progress dvlw-lite || git config pull.rebase false ) || \
    ( git clone https://github.com/kindtek/devels-workshop --progress dvlw-lite || git config pull.rebase true ) || \
    ( git clone https://github.com/kindtek/devels-workshop --progress dvlw-lite || git config pull.rebase false ) || \
    ( cd dvlw-lite && git pull -f https://github.com/kindtek/devels-workshop ) 
WORKDIR /dvlw-lite
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    # git submodule init dvlp && \
    (git pull --progress --depth=1 --prune https://github.com/kindtek/devels-playground ) || \
    ( git config pull.rebase false && git submodule update  --depth=1 --init --progress -- dvlp )  || \
    ( git config pull.rebase true &&  git submodule update --init --remote --progress -- dvlp ) || \
    (git config pull.rebase false && git submodule update --init --remote --progress -- dvlp ) || (git pull --progress --prune https://github.com/kindtek/devels-playground ) && \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)
    chmod -R 1770 dvlp/mnt/home && \
    chmod -R 1770 dvlp/mnt/bak

###################
# dvlp_repo-build-kernel #
###################
FROM dvlp_repo-build AS dvlp_repo-build-kernel
WORKDIR /
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git clone https://github.com/kindtek/devels-workshop --progress dvlw || (cd dvlw && git pull https://github.com/kindtek/devels-workshop) 
WORKDIR /dvlw
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --progress -- dvlp || git pull https://github.com/kindtek/devels-playground && \
    chmod -R 1770 dvlp/mnt/home && \
    chmod -R 1770 dvlp/mnt/bak
WORKDIR /dvlw/dvlp
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    ( git submodule update --init --progress || git submodule update --init --progress --force --rebase -- kernels ) 
# (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/${_DVL}/dvlw/dvlp)

########################
# dvlp_repo-build #
#######################
FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./dvlw-lite/ ./dvlw/
FROM scratch AS dvlp_repo-kernel
COPY --from=dvlp_repo-build-kernel ./dvlw/ ./dvlw/

####################### BASE DIRS AND VOLUME MOUNT POINTS ####################################
########################
# dvlp_base-devel-dirs #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-devel-dirs
ARG _MNT
ARG _DVL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hel
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv built-kernels && \
    mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_DVL} && \
    chmod -R 1770 /hel && \
    chmod -R 1770 /home/${_DVL} && \
    cp -prv * /home/${_DVL}
WORKDIR ${_MNT}
RUN ln -fsv ${_MNT}/bak/${_DVL} bak 
# && \
#     chmod -R 1770 ${_MNT}/bak/${_DVL}
# ln -fsv ${_MNT}/bak/${_DVL} /home/${_DVL}/bak 
WORKDIR /

################################
#  dvlp_base-devel-kernel-dirs #
################################
FROM dvlp_base-devel-dirs AS dvlp_base-devel-kernel-dirs
ARG _MNT
ARG _DVL
WORKDIR /hel
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv /hel && \
    mkdir -pv /hel/built-kernels && \
    mkdir -pv /home/${_DVL}/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    chmod -R 1770 /hel && \
    chmod -R 1770 /home/${_DVL} && \
    cp -prv * /home/${_DVL} 
# WORKDIR /home/${_DVL}
# RUN ln -fsv dvlw/dvlp dvlp && \
#     ln -fsv dvlw/dvlp/kernels/linux linux && \
#     ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
#     ln -fsv dvlw/dvlp/kernels kernels && \
WORKDIR /

#########################
#  dvlp_base-angel-dirs #
#########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-angel-dirs
ARG _MNT
ARG _AGL_USR
ENV _AGL=${_AGL_USR:-agl}
WORKDIR /hal
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv built-kernels && \
    mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_AGL} && \
    chmod -R 1770 /hal && \
    chmod -R 1770 /home/${_AGL} && \
    cp -prv * /home/${_AGL} 
WORKDIR ${_MNT}
RUN mkdir -pv bak/${_AGL} && \
    chmod -R 1770 bak/${_AGL}
WORKDIR /

################################
#  dvlp_base-angel-kernel-dirs #
################################
FROM dvlp_base-angel-dirs AS dvlp_base-angel-kernel-dirs
ARG _MNT
ARG _AGL
WORKDIR /hal
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./
# COPY --from=dvlp_repo ./dvlw/dvlp/mnt/      ./mnt/
RUN mkdir -pv dvlw && \
    mkdir -pv /hal && \
    mkdir -pv /hal/built-kernels && \
    mkdir -pv /home/${_AGL}/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels  && \
    chmod -R 1770 /hal && \
    chmod -R 1770 /home/${_AGL} && \
    cp -prv * /home/${_AGL}
# WORKDIR /home/${_AGL}
# RUN ln -fsv dvlw/dvlp dvlp && \
#     ln -fsv dvlw/dvlp/kernels/linux linux && \
#     ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
#     ln -fsv dvlw/dvlp/kernels kernels
WORKDIR /

########################
#  dvlp_base-r00t-dirs #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-r00t-dirs
ARG _MNT
ARG _ADMIN
WORKDIR /admin
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/    ./
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/         ./mnt/

RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker 
# && \
# chmod -R 1770 /admin
WORKDIR /mnt
RUN mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv etc && \
    mkdir -pv home && \
    mkdir -pv opt && \
    chmod -R 1770 dls && \
    chmod -R 1770 etc && \
    chmod -R 1770 /mnt 



WORKDIR /

###############################
#  dvlp_base-r00t-kernel-dirs #
###############################
FROM dvlp_base-r00t-dirs AS dvlp_base-r00t-kernel-dirs
ARG _MNT
ARG _ADMIN
WORKDIR /admin
COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./
RUN mkdir -pv /admin && mkdir -pv built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
#  && \
# chmod -R 1770 /admin && \
# cp -prv * /home/r00t
WORKDIR /

################################# BASE ### ###################################

###############
# dvlp_base #
###############
FROM kalilinux/kali-rolling:latest AS dvlp_base
ARG _MNT
ARG JACKET
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG CONFIG_FILE
ARG DEBIAN_FRONTEND=noninteractive
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
WORKDIR /
# COPY --from=dvlp_repo ./dvlw/dvlp/mnt/home/ ./etc/skel-kernel/
# USER r00t
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/tmp/cache/useradd,sharing=private \
    groupadd            r00t    && \
    groupadd            halo    && \
    groupadd            hell    && \
    groupadd            w0rld  && \
    useradd -s /bin/bash -u 0   -o  -g root     -G r00t,w0rld   -d /r00t    r00t && \
    useradd -s /bin/bash            -g hell     -G w0rld        -d /hel     ${_DVL} && \
    useradd -s /bin/bash            -g halo     -G w0rld        -d /hal     ${_AGL} && \
    passwd -d ${_DVL} && \
    passwd -d ${_AGL} && \
    passwd -d r00t && \
    passwd -d root && \
    passwd -l root 

RUN \
    --mount=type=cache,target=/var/cache/debconf,sharing=locked \
    echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections
# add-apt-repository ppa:apt-fast/stable && \
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y sudo && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    usermod -aG sudo ${_AGL}
WORKDIR /

############################## SKELETON ###################################
########################
# dvlp_skel-build #
########################
FROM dvlp_base AS dvlp_skel-build
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
COPY --from=dvlp_base-r00t-dirs         --chown=r00t:r00t       --chmod=1770    ./admin/                    ./r00t/
COPY --from=dvlp_base-devel-dirs        --chown=${_DVL}:hell    --chmod=1770    ./hel/                      ./hel/
COPY --from=dvlp_base-angel-dirs        --chown=${_AGL}:halo    --chmod=1770    ./hal/                      ./hal/
COPY --from=dvlp_repo              --chown=${_DVL}:hell    --chmod=1770    ./dvlw/dvlp/mnt/home/       ./hel/
COPY --from=dvlp_repo              --chown=${_AGL}:halo    --chmod=1770    ./dvlw/dvlp/mnt/home/       ./hal/
COPY --from=dvlp_repo              --chown=r00t:r00t       --chmod=1770    ./dvlw/dvlp/mnt/home/       ./r00t/
COPY --from=dvlp_repo              --chown=${_AGL}:halo    --chmod=1770    ./dvlw/                     ./dvlw/
COPY --from=dvlp_repo              --chown=${_DVL}:hell    --chmod=1770    ./dvlw/                     ./hel/dvlw/
COPY --from=dvlp_repo              --chown=${_AGL}:halo    --chmod=1770    ./dvlw/                     ./hal/dvlw/
COPY --from=dvlp_repo              --chown=${_AGL}:halo    --chmod=1770    ./dvlw/                     ./r00t/dvlw/
COPY --from=dvlp_repo              --chown=r00t:r00t       --chmod=1770    /dvlw/dvlp/mnt/etc/*        /etc/
COPY --from=dvlp_repo              --chown=r00t:halo       --chmod=1770    ./dvlw/dvlp/mnt/            .${_MNT}/


## WORKDIR /hall
###################
# dvlp_skel-build-kernel #
###################
FROM dvlp_base AS dvlp_skel-build-kernel
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
COPY --from=dvlp_base-r00t-kernel-dirs  --chown=r00t:r00t    --chmod=1770    ./admin/                ./r00t/ 
COPY --from=dvlp_base-devel-kernel-dirs --chown=${_DVL}:hell --chmod=1770    ./hel/                  ./hel/ 
COPY --from=dvlp_base-angel-kernel-dirs --chown=${_AGL}:halo --chmod=1770    ./hal/                  ./hal/ 
COPY --from=dvlp_repo-kernel                  --chown=${_DVL}:hell --chmod=1770    ./dvlw/dvlp/mnt/home/   ./hel/
COPY --from=dvlp_repo-kernel                  --chown=${_AGL}:halo --chmod=1770    ./dvlw/dvlp/mnt/home/   ./hal/
COPY --from=dvlp_repo-kernel                  --chown=r00t:r00t    --chmod=1770    ./dvlw/dvlp/mnt/home/   ./r00t/
COPY --from=dvlp_repo-kernel                  --chown=${_AGL}:halo --chmod=1770    ./dvlw/                 ./dvlw/
# COPY --from=dvlp_base-angel-kernel-dirs --chown=${_AGL}:halo --chmod=1770    ./hal/                  ./dvlw/ 
COPY --from=dvlp_repo-kernel                  --chown=${_DVL}:hell --chmod=1770    ./dvlw/                 ./hel/dvlw/
COPY --from=dvlp_repo-kernel                  --chown=${_AGL}:halo --chmod=1770    ./dvlw/                 ./hal/dvlw/
COPY --from=dvlp_repo-kernel                  --chown=${_AGL}:halo --chmod=1770    ./dvlw/                 ./r00t/dvlw/
COPY --from=dvlp_repo-kernel                  --chown=r00t:r00t    --chmod=1770    /dvlw/dvlp/mnt/etc/*    /etc/
WORKDIR ${_MNT}
COPY --from=dvlp_base-r00t-kernel-dirs  --chown=r00t:r00t    --chmod=1770    ./mnt/                  ./
COPY --from=dvlp_base-devel-kernel-dirs --chown=r00t:r00t    --chmod=1770    ./mnt/                  ./
COPY --from=dvlp_repo-kernel                  --chown=r00t:halo    --chmod=1770    ./dvlw/dvlp/mnt/        ./
WORKDIR /

#############
# dvlp_skel-kernel #
#############
FROM dvlp_skel-build AS dvlp_skel-kernel
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y apt-transport-https curl gh git gnupg2 libssl-dev nvi wget && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

##################
# dvlp_skel #
##################
FROM dvlp_skel-build AS dvlp_skel

#################################################################################
############################### IMAGE BASES #####################################
################################################################################

################################## BARE #########################################
############
# dvlp_base-bare #
############
FROM dvlp_skel-build AS dvlp_base-bare
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hal
USER ${_DVL}

################################### GIT #########################################
#################
# dvlp_base-git_lite #
#################
FROM dvlp_skel AS dvlp_base-git
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hal
USER ${_DVL}

############
# dvlp_base-git-kernel #
############
FROM dvlp_skel-kernel AS dvlp_base-git-kernel
COPY --from=dvlp_skel-build-kernel         ./      ./
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
WORKDIR /hal
USER ${_DVL}

################################# PYTHON ########################################
#####################
# dvlp_base-python-build #
#####################
FROM dvlp_skel-build AS dvlp_base-python-build
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
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev  libpython3-dev pkg-config python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps 
###############################
# dvlp_base-python-build-lite #
###############################
FROM dvlp_skel-build AS dvlp_base-python-build-lite
USER r00t
ARG angel_exists=true
ARG devel_exists=true
ARG r00t_exists=true
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y jq python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
WORKDIR /r00t
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    $r00t_exists && pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user || r00t_exists=false
RUN ( $devel_exists && (chown -R ${_DVL}:hell /hel || chown -R ${_DVL}:hell /hel/.local || devel_exists=false )) 
USER ${_DVL}
WORKDIR /hel
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    $devel_exists && pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user || devel_exists=false
USER ${_AGL}
WORKDIR /hal
RUN  ( $angel_exists && (chown -R ${_AGL}:halo /hal || chown -R ${_AGL}:halo /hal/.local || angel_exists=false )) 
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps || angel_exists=false 
USER r00t
RUN rm -rf /var/cache/pip/*
WORKDIR /

#########################
# dvlp_base-python-lite #
#########################
FROM dvlp_base-git AS dvlp_base-python-lite
USER r00t
WORKDIR / 
COPY --from=dvlp_base-python-build-lite ./ ./
WORKDIR /hal
USER ${_DVL}

####################
# dvlp_base-python #
###################
FROM dvlp_base-git AS dvlp_base-python
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR / 
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-python-build-lite ./ ./
WORKDIR /hal
USER ${_DVL}

############################# POWERHELL #########################################
##############################
# dvlp_base-msdot-build-lite #
#############################
FROM dvlp_skel-build AS dvlp_base-msdot-build-lite
USER r00t
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y apt-utils ca-certificates curl gnupg2 apt-transport-https lsb-release wget && \
    wget "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" && \
    mv packages-microsoft-prod.deb /var/cache/apt/archives && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d//microsoft-prod.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" | tee /etc/apt/sources.list.d/microsoft-prod.list  > /dev/null && \
    dpkg -i /var/cache/apt/archives/packages-microsoft-prod.deb && \
    # curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -O - https://pkg.wslutiliti.es/public.key | tee --append /etc/apt/trusted.gpg.d/wslu.asc && \
    echo "deb [arch=$(dpkg --print-architecture)] https://pkg.wslutiliti.es/debian bullseye main" | tee --append /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y powershell wslu && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb 
# now lives with other apt archives
# RUN apt-get -y remove lsb_release
# apt-get clean all && \
# apt-get autoremove --purge
WORKDIR /hal
USER ${_DVL}

#########################
# dvlp_base-msdot-build #
#########################
FROM dvlp_base-msdot-build-lite AS dvlp_base-msdot-build
USER r00t
RUN apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y dotnet-sdk-7.0  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
WORKDIR /hal
USER ${_DVL}

########################
# dvlp_base-msdot-lite #
########################
FROM dvlp_base-git AS dvlp_base-msdot-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
WORKDIR /hal
USER ${_DVL}

###################
# dvlp_base-msdot #
###################
FROM dvlp_base-git AS dvlp_base-msdot
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
WORKDIR /hal
USER ${_DVL}

########################## DOCKER IN DOCKER ######################################
########################
# dvlp_base-dind-build #
########################
FROM dvlp_skel-build AS dvlp_base-dind-build
USER r00t
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y ca-certificates curl lsb-release gpg && \
    mkdir -pv /etc/apt/keyrings
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null


RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gnupg && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
WORKDIR /hal
USER ${_DVL}

#######################
# dvlp_base-dind-lite #
#######################
FROM dvlp_base-git AS dvlp_base-dind-lite
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
WORKDIR /hal
USER ${_DVL}

##################
# dvlp_base-dind #
##################
FROM dvlp_base-git AS dvlp_base-dind
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
COPY --from=dvlp_base-dind-build ./ ./
WORKDIR /hal
USER ${_DVL}

############################### KERNEL #########################################
##########################
# dvlp_base-kernel-build #
##########################
FROM dvlp_skel-build-kernel AS dvlp_base-kernel-build
USER r00t
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y alien autoconf bison build-essential dbus-user-session daemonize dwarves fakeroot \ 
    flex fontconfig gawk kmod libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev \
    python3-dev python3-setuptools python3-cffi net-tools snapd systemd-sysv sysvinit-utils uuid-dev && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
# RUN apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
WORKDIR /hal
USER ${_DVL}

######################################################################################
###################  dvlp_base-kernel-builder - KERNEL BUILDER  ######################
######################################################################################
FROM dvlp_base-git-kernel AS dvlp_base-kernel-builder
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
COPY --from=dvlp_base-kernel-build ./ ./
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hal
USER ${_DVL}

######################################################################################
########################  dvlp_kernel-make - KERNEL COMPILER  ########################
######################################################################################
FROM dvlp_base-kernel-builder AS dvlp_kernel-make
ARG CONFIG_FILE
ARG KERNEL_TYPE
USER r00t
WORKDIR /
# COPY --from=dvlp_skel-build-kernel ./ ./
WORKDIR /hal/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN chmod +x build-basic-wsl-kernel.sh
RUN bash build-${KERNEL_TYPE}-kernel.sh
# RUN bash make-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" ${_AGL}
# RUN echo '# daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /hal
USER ${_DVL}

#################################### GUI ######################################
######################
# dvlp_base-gui-lite #
######################
# wsl2 required
FROM dvlp_base-git AS dvlp_base-gui-lite
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
COPY --from=dvlp_base-python-build-lite ./ ./
COPY --from=dvlp_base-msdot-build-lite ./ ./
COPY --from=dvlp_base-dind-build ./ ./
WORKDIR /
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN \
    --mount=type=cache,target=/var/cache/curl \
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y brave-browser dolphin vlc x11-apps  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
# change last line of this file - fix for brave-browser displaying empty windows
RUN cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | tee --append /opt/brave.com/brave/brave-browser > /dev/null
COPY --from=dvlp_repo /dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/${_DVL} && \
WORKDIR /hal
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
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y xrdp xfce4 xfce4-goodies && \
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
    apt-get install --no-install-recommends -y lightdm && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    # echo "set shared/default-x-display-manager lightdm" | debconf-communicate && \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y kali-defaults kali-root-login desktop-base kde-plasma-desktop && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
COPY --from=dvlp_repo --chown=r00t:r00t /dvlw/dvlp/mnt/etc/* /etc/

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
WORKDIR /hal
USER ${_DVL}

############################## CUDA ###############################
##################
# dvlp_base-cuda #
##################
FROM dvlp_base-git AS dvlp_base-cuda
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
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
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y nvidia-cuda-toolkit && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb   
WORKDIR /hal
USER ${_DVL}

#######################
# dvlp_base-cuda-plus #
#######################
FROM dvlp_base-git-kernel AS dvlp_base-cuda-plus
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ENV _AGL=$_AGL_USR
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_base-python-build ./ ./
COPY --from=dvlp_base-msdot-build ./ ./
COPY --from=dvlp_base-dind-build ./ ./
COPY --from=dvlp_base-kernel-builder ./ ./
COPY --from=dvlp_base-cuda ./ ./
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get update -y && apt-get autoremove -y && \
    apt-get install --no-install-recommends -y nvidia-cuda-toolkit && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb   
WORKDIR /hal
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


# FROM dvlp_base AS dvlp_jacket

# FROM dvlp_base AS dvlp_jacket-kernel

#####################
## dvlp_jacket-kernel-plus #
#####################
# FROM dvlp_jacket-kernel-kernel-skel-kernel AS dvlp_jacket-kernel-plus

############################
## dvlp_jacket-kernel-kernel-plus #
############################
# FROM dvlp_jacket-kernel-plus AS dvlp_jacket-kernel-kernel-plus

##################
## dvlp_gui-plus #
##################
FROM dvlp_base-gui-plus AS dvlp_gui-plus
WORKDIR /

############
# dvlp_gui #
############
FROM dvlp_base-gui AS dvlp_gui 
WORKDIR /

#################
# dvlp_gui-lite #
#################
FROM dvlp_base-gui-lite AS dvlp_gui-lite
WORKDIR /

###################
# dvlp_dind-lite #
##################
FROM dvlp_base-dind-lite AS dvlp_dind-lite
WORKDIR /

############
# dvlp_git #
############
FROM dvlp_base-git AS dvlp_git
WORKDIR /
########################
# dvlp_git-lite #
########################
FROM dvlp_base-git-kernel AS dvlp_git-kernel
WORKDIR /

####################
# dvlp_ms-dot-lite #
####################
FROM dvlp_base-msdot-lite AS dvlp_msdot-lite
WORKDIR /


####################
# dvlp_python-lite #
####################
FROM dvlp_base-python-lite AS dvlp_python-lite
WORKDIR /

#############
# dvlp_bare #
#############
FROM dvlp_base-bare AS dvlp_bare
WORKDIR /

#############
# dvlp_cuda #
#############
FROM dvlp_base-cuda  AS dvlp_cuda
WORKDIR /

##################
# dvlp_cuda-plus #
##################
FROM dvlp_base-cuda-plus AS dvlp_cuda-plus
WORKDIR /