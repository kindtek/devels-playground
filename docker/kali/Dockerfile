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
ARG DOCKER_BUILDKIT=1
ARG _MNT=${_MNT:-/mnt/data}
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
ARG _ARCH
ARG _ARCH_VENDOR
ARG __ARCH__VENDOR
ARG WINDOWS
ARG LINUX
ARG KERNEL_TYPE=${KERNEL_TYPE}
ARG KERNEL_PACKAGE_NAME=${KERNEL_PACKAGE_NAME}
ARG INSTALL_KERNEL="dont_install_kernel"
ARG install=INSTALL
ARG installkernel=${install}_KERNEL
# $ echo ${installkernel}
# dont_install_kernel
# $ echo ${!installkernel}
# INSTALL_KERNEL
ARG CONFIG_FILE
ARG DOCKER_TIMESTAMP
ARG KERNEL_PACKAGE_NAME

################
# kali_testing #
################
FROM kindtek/devels-playground:kali-skel AS dvlp_testing
WORKDIR /
RUN touch testing

################################### GITHUB REPO #####################################
########################
# dvlp_repo-builder #
########################
FROM kindtek/devels-playground:kali-skel AS dvlp_repo-builder
ARG _MNT
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG DOCKER_TIMESTAMP
ARG KERNEL_PACKAGE_NAME
ENV KERNEL_TYPE=${KERNEL_TYPE}
ENV KERNEL_FEATURE=${KERNEL_FEATURE}
ENV CONFIG_FILE=${CONFIG_FILE}
ENV DOCKER_TIMESTAMP=${DOCKER_TIMESTAMP}
ENV KERNEL_PACKAGE_NAME=${KERNEL_PACKAGE_NAME}

# USER r00t
WORKDIR /
# add git cache directory
# RUN mkdir -pv /var/cache/dvlp/archives && \
# chown -R r00t:r00t /var/cache/dvlp/archives && \
#     mkdir -pv /dvlw && \
#     chown -R r00t:r00t /repos/dvlw
RUN \
    # clear docker-clean to flag for apt-get clean
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    # cache packages in docker builds as long as using apt-get
    echo 'Binary::apt-get::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    # no suggests or recommends for apt-get
    # suggests and recommends for apt
    echo "\
    Acquire::Retries '3';\
    Acquire::https::Timeout '240';\
    Acquire::http::Timeout '240';\
    Acquire::BrokenProxy='true';\
    Acquire::http::No-Cache='true'; \ 
    Acquire::http::Pipeline-Depth='0';\
    Debug::Acquire::https 'true';\
    Binary::apt-get::APT::Get::Assume-Yes 'true';\
    Binary::apt-get::APT::Install-Recommends 'false';\
    Binary::apt-get::APT::Install-Suggests 'false'; \
    Binary::apt::APT::Install-Recommends 'true'; \
    Binary::apt::APT::Install-Suggests 'true';\
    Binary::apt-get::APT::Keep-Downloaded-Packages 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm 
# use apt loading bar for apt-get by default
# RUN echo 'Binary::apt-get::DPkg::Progress-Fancy "1"' | tee /etc/apt/apt.conf.d/99fancybar.conf
# import/install basic utils from layer cache if possible and delete .deb archives from container when finished
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo-git,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get --reinstall -y install ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt
# add safe directories
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo-git,sharing=locked  \
    # if [ "$fresh_repo" != no ]; then rm -rf /var/cache/dvlp/archives/dvlw; fi && \
    # git config --global --add safe.directory /home/${_DVL} && \
    # git config --global --add safe.directory /home/${_AGL} && \
    git config --global --add safe.directory /hal && \
    git config --global --add safe.directory /hal/dvlw && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /hel/dvlw && \
    git config --global --add safe.directory / && \
    git config --global --add safe.directory /root && \
    git config --global --add safe.directory /r00t && \
    git config --global --add safe.directory /repos/dvlw && \
    git config --global --add safe.directory /var/cache/dvlp/build-repo-git && \
    git config --global core.autocrlf input && \
    git config --global user.name 'Snail Mail' && \
    git config --global user.email '<>' 
########################
# dvlp_build-repo #
#######################
FROM kindtek/devels-playground:repo-builder AS dvlp_build-repo
WORKDIR /repos
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo,sharing=locked  \
    repo_owner=kindtek && \
    repo_name=devels-workshop && \
    repo_url=https://github.com/${repo_owner}/${repo_name} && \
    repo_path=dvlw && \
    repo_branch=main && \
    echo repo_owner: $repo_owner && \
    echo repo_name: $repo_name && \
    echo repo_url: $repo_url && \
    echo repo_path: $repo_path && \
    echo repo_branch: $repo_branch && \
    echo "git clone $repo_url --single-branch --branch $repo_branch --filter=blob:limit=13k --progress -- $repo_path 2>/dev/null" && \
    git clone "$repo_url" --single-branch --branch $repo_branch --filter=blob:limit=13k --progress -- $repo_path 2>/dev/null
WORKDIR /repos/dvlw
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo,sharing=locked \
    echo  "git submodule update --init --remote --filter=blob:limit=13k --progress -- dvlp dvl-adv powerhell 2>/dev/null" && \
    git submodule update --init --remote --filter=blob:limit=13k --progress -- dvlp dvl-adv powerhell 2>/dev/null 
WORKDIR /repos/dvlw/dvlp
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo,sharing=locked \
    # get default user files
    echo "git submodule update --init --progress -- mnt" && \
    git submodule update --init --progress -- mnt && \
    chmod -R 1770 mnt/bak

###################
# dvlp_build-repo-kernel #
###################
FROM dvlp_build-repo AS dvlp_build-repo-kernel
WORKDIR /repos/dvlw/dvlp
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-repo-kernel,sharing=locked \
    # allow download of larger files (kernels)
    git submodule update --init --progress --filter=blob:limit=20m -- kernels 

FROM dvlp_build-repo${KERNEL_TYPE:+-kernel} AS dvlp_built-repo

#############
# dvlp_repo #
#############
FROM scratch AS dvlp_repo
COPY --from=dvlp_build-repo --chmod=1750 ./repos/dvlw/ ./repos/dvlw/
# VOLUME . .
FROM scratch AS dvlp_repo-kernel
# VOLUME . .
COPY --from=dvlp_build-repo-kernel --chmod=1750 ./repos/dvlw/ ./repos/dvlw/
FROM scratch AS dvlp_repos
COPY --from=dvlp_build-repo --chmod=1750 ./repos/dvlw/ ./repos/dvlw/
COPY --from=dvlp_build-repo-kernel --chmod=1750 ./repos/dvlw/ ./repos/dvlw/

# VOLUME . .

####################### BASE volumes AND VOLUME MOUNT POINTS ####################################
########################
# dvlp_base-devel-volumes #
########################
FROM kindtek/devels-playground:kali-skel AS dvlp_base-devel-volumes-builder
ARG _MNT
ARG _DVL_USR
ENV _DVL=$_DVL_USR
WORKDIR /hel
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN mkdir -pv kache && \
    mkdir -pv dvlw && \
    mkdir -pv dls && \
    mkdir -pv .docker/run && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_DVL} && \
    chmod -R 1770 /hel && \
    chmod -R 1770 /home/${_DVL} && \
    cp -prv * /home/${_DVL}
WORKDIR ${_MNT}/data
RUN ln -fsv ${_MNT}/data/bak/${_DVL} bak 
# && \
#     chmod -R 1770 ${_MNT}/bak/${_DVL}
# ln -fsv ${_MNT}/data/bak/${_DVL} /home/${_DVL}/bak 
WORKDIR /

################################
#  dvlp_base-devel-volumes-builder #
################################
FROM dvlp_base-devel-volumes-builder AS dvlp_base-devel-kernel-volumes-builder
ARG _MNT
ARG _DVL
ARG _ARCH
ARG _ARCH_VENDOR
ARG __ARCH__VENDOR
WORKDIR /hel
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN mkdir -pv /hel && \
    mkdir -pv /hel/kache && \
    mkdir -pv /home/${_DVL}/kache && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$_ARCH/$_ARCH_VENDOR" && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    chmod -R 1770 /hel && \
    chmod -R 1770 /home/${_DVL} && \
    cp -prv * /home/${_DVL} 
# WORKDIR /home/${_DVL}
# RUN ln -fsv dvlw/dvlp dvlp && \
#     ln -fsv dvlw/dvlp/kernels/linux linux && \
#     ln -fsv dvlw/dvlp/kernels/linux/$(echo "${cpu_ARCH_VENDOR%%_*}")/amd x64amd && \
#     ln -fsv dvlw/dvlp/kernels kernels && \
WORKDIR /

###############################
#  dvlp_base-dvl-volumes-built #
###############################
FROM dvlp_base-devel${KERNEL_TYPE:+-kernel}-volumes-builder AS dvlp_base-devel-volumes-built
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/

#########################
#  dvlp_base-angel-volumes-builder #
#########################
FROM kindtek/devels-playground:kali-skel AS dvlp_base-angel-volumes-builder
ARG _MNT
ARG _AGL_USR
ENV _AGL=${_AGL_USR:-agl}
WORKDIR /hal
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN mkdir -pv kache && \
    mkdir -pv dvlw && \
    mkdir -pv dls && \
    mkdir -pv .docker/run && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker && \
    mkdir -pv /home/${_AGL} && \
    chmod -R 1770 /hal && \
    chmod -R 1770 /home/${_AGL} && \
    cp -prv * /home/${_AGL} 
WORKDIR ${_MNT}/data
RUN mkdir -pv c && \
    mkdir -pv n && \
    mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv bak/${_AGL} && \
    chmod -R 1770 bak/${_AGL} && \
    chmod -R 1770 c && \
    chmod -R 1770 n && \
    chmod -R 1770 ${_MNT}/data
WORKDIR /

################################
#  dvlp_base-angel-volumes-builder #
################################
FROM dvlp_base-angel-volumes-builder AS dvlp_base-angel-kernel-volumes-builder
ARG _MNT
ARG _AGL
ARG _ARCH
ARG _ARCH_VENDOR
ARG __ARCH__VENDOR
WORKDIR /hal
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
# COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/      ./mnt/
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$_ARCH/$_ARCH_VENDOR" && \
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

###############################
#  dvlp_base-agl-volumes-built #
###############################
FROM dvlp_base-angel${KERNEL_TYPE:+-kernel}-volumes-builder AS dvlp_base-angel-volumes-built
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/


########################
#  dvlp_base-r00t-volumes-builder #
########################
FROM kindtek/devels-playground:kali-skel AS dvlp_base-r00t-volumes-builder
ARG _MNT
ARG _R00T
WORKDIR /r00t
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/    ./
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/         ./mnt/
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/

RUN mkdir -pv dvlw && \
    mkdir -pv dls && \
    mkdir -pv .docker/run && \
    ln -fsv dvlw devels-workshop && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/kali kdock && \
    ln -fsv dvlw/dvlp/docker docker 
# && \
# chmod -R 1770 /r00t
WORKDIR ${_MNT}/data
RUN mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv etc && \
    # mkdir -pv home && \
    # mkdir -pv opt && \
    chmod -R 1770 dls && \
    chmod -R 1770 etc && \
    chmod -R 1770 ${_MNT}/data
WORKDIR /

###############################
#  dvlp_base-r00t-volumes-builder #
###############################
FROM dvlp_base-r00t-volumes-builder AS dvlp_base-r00t-kernel-volumes-builder
ARG _MNT
ARG _R00T
ARG _ARCH
ARG _ARCH_VENDOR
ARG __ARCH__VENDOR
WORKDIR /r00t
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$_ARCH/$_ARCH_VENDOR" && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    mkdir -pv /r00t && mkdir -pv kache
#  && \
# chmod -R 1770 /r00t && \
# cp -prv * /home/r00t
WORKDIR /

###############################
#  dvlp_base-r00t-volumes-built #
###############################
FROM dvlp_base-r00t${KERNEL_TYPE:+-kernel}-volumes-builder AS dvlp_base-r00t-volumes-built
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/

FROM scratch AS dvlp_base-volumes-built



############################# BASE BUILD (part 1 ) ###################################
FROM kindtek/devels-playground:kali-skel AS dvlp_base-skel
ARG _MNT
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
USER root
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/base-skel,sharing=locked \
    # mkdir -p /usr/lib/modules && \
    mkdir -pv /usr/lib/binfmt.d && \
    mkdir -pv /kache && \
    mkdir -pv /boot && \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo ':WSLInterop:M::MZ::/init:PF' > /usr/lib/binfmt.d/WSLInterop.conf && \
    echo 'Acquire::Retries "3";\
    Acquire::https::Timeout "240";\
    Acquire::http::Timeout "240";\
    Acquire::http::No-Cache="true"; \ 
    Acquire::http::Pipeline-Depth="0"; \
    Acquire::BrokenProxy="true"; \
    Acquire::Check-Valid-Until="false"; \
    Acquire::Check-Date="false"; \
    Debug::Acquire::https "true"; \
    Binary::apt-get::APT::Get::Assume-Yes "true"; \
    Binary::apt-get::APT::Install-Recommends "false"; \
    Binary::apt-get::APT::Install-Suggests "false"; \
    Binary::apt::APT::Install-Recommends "true"; \
    Binary::apt::APT::Install-Suggests "true";\
    Binary::apt-get::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections && \
    groupadd    -g 999  docker && \
    groupadd            r00t    && \
    groupadd            halo    && \
    groupadd            hell    && \
    groupadd            w0rld  && \
    useradd -s /bin/bash -u 0   -o  -g root     -G r00t,w0rld   -d /r00t    r00t && \
    useradd -s /bin/bash            -g halo     -G w0rld,hell   -d /hal     ${_AGL} && \
    useradd -s /bin/bash            -g hell     -G w0rld        -d /hel     ${_DVL} && \
    passwd -d ${_AGL} && \
    passwd -d ${_DVL} && \
    passwd -d r00t && \
    passwd -d root && \
    passwd -l root && \
    mkdir -pv /mnt/dls && \
    mkdir -pv /mnt/c && \
    mkdir -pv /mnt/n && \
    mkdir -pv ${_MNT}/dls && \
    # mkdir -p /r00t/dvlw && \
    # mkdir -m 1770 ${_MNT}/dls && \
    # mkdir -m 1770 repos  && \
    chown ${_AGL}:halo /mnt && \
    chown ${_AGL}:halo /mnt/c && \
    chown ${_AGL}:halo /mnt/n && \
    chown r00t:w0rld /mnt/dls && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get purge -y openssh-server && \
    apt-get install --no-install-recommends -y curl locales openssh-server ssh systemd-sysv sysvinit-utils wget && \   
    update-locale LANGUAGE="C" && \
    update-locale LANG="C" && \
    update-locale LC_ALL="C" && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime  && \
    apt-get update --fix-missing -yq && apt-get install -f && apt-get upgrade -yq && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/                   ./repos/dvlw/
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1750    ./repos/dvlw/                   ./hel/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/                   ./hal/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/                   ./r00t/dvlw/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
# COPY --from=dvlp_repos                       --chown=r00t:halo       --chmod=1750    ./repos/dvlw/dvlp/mnt/          .${_MNT}/
# ONBUILD COPY --from=dvlp_base-r00t${KERNEL_TYPE:+-kernel}-volumes             --chown=r00t:r00t       --chmod=1750    ./r00t/                        ./r00t/
# ONBUILD COPY --from=dvlp_base-devel${KERNEL_TYPE:+-kernel}-volumes            --chown=${_DVL}:hell    --chmod=1750    ./hel/                          ./hel/###############################
#  dvlp_base-volumes #
WORKDIR /
###############################

FROM kindtek/devels-playground:kali-skel AS dvlp_base-volumes-builder
ARG _MNT
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
COPY --from=dvlp_base-devel-volumes-built   --chown=${_DVL}:hell    --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-angel-volumes-built   --chown=${_AGL}:halo    --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-r00t-volumes-built    --chown=r00t:r00t       --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-devel-volumes-built   --chown=${_DVL}:hell    --chmod=1750    ./hel/                          ./hel/
COPY --from=dvlp_base-angel-volumes-built   --chown=${_AGL}:halo    --chmod=1750    ./hal/                          ./hal/
COPY --from=dvlp_base-r00t-volumes-built    --chown=r00t:r00t       --chmod=1750    ./r00t/                         ./r00t/
COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hel/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hal/
COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./r00t/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/                   ./repos/dvlw/
COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1755     /repos/dvlw/dvlp/mnt/etc/*     ./etc/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/dvlp/mnt/          .${_MNT}/ 

###############################
#  dvlp_base-kernel-volumes-builder #
###############################

FROM kindtek/devels-playground:kali-skel AS dvlp_base-kernel-volumes-builder
ARG _MNT
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
COPY --from=dvlp_base-devel-volumes-built   --chown=${_DVL}:hell    --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-angel-volumes-built   --chown=${_AGL}:halo    --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-r00t-volumes-built    --chown=r00t:r00t       --chmod=1750    ./home/                         ./home/
COPY --from=dvlp_base-devel-volumes-built   --chown=${_DVL}:hell    --chmod=1750    ./hel/                          ./hel/
COPY --from=dvlp_base-angel-volumes-built   --chown=${_AGL}:halo    --chmod=1750    ./hal/                          ./hal/
COPY --from=dvlp_base-r00t-volumes-built    --chown=r00t:r00t       --chmod=1750    ./r00t/                         ./r00t/
COPY --from=dvlp_repo-kernel                --chown=${_DVL}:hell    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hel/
COPY --from=dvlp_repo-kernel                --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hal/
COPY --from=dvlp_repo-kernel                --chown=r00t:r00t       --chmod=1750    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./r00t/
COPY --from=dvlp_repo-kernel                --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/                   ./repos/dvlw/
COPY --from=dvlp_repo-kernel                --chown=r00t:r00t       --chmod=1755     /repos/dvlw/dvlp/mnt/etc/*     ./etc/
COPY --from=dvlp_repo-kernel                --chown=${_AGL}:halo    --chmod=1750    ./repos/dvlw/dvlp/mnt/          .${_MNT}/ 

############################# BASE BUILD ###################################

FROM dvlp_base-volumes-builder AS dvlp_base-builder
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ENV DEBIAN_FRONTEND=noninteractive


WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/base-kernel,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get purge -y openssh-server
RUN \
    apt-get install --no-install-recommends -y apt-utils apt-transport-https curl libssl-dev locales openssh-server sudo ssh systemd-sysv sysvinit-utils vim wget && \    
    usermod -aG docker root && \
    usermod -aG docker r00t && \
    usermod -aG sudo ${_AGL} && \
    usermod -aG docker ${_AGL} && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt 

############################# BASE BUILD KERNEL ###################################

FROM dvlp_base-kernel-volumes-builder AS dvlp_base-kernel-builder
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG DOCKER_BUILD_TIMESTAMP
ARG _MNT
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/base-kernel,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get purge -y openssh-server
RUN \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils apt-transport-https curl libssl-dev locales openssh-server sudo ssh systemd-sysv sysvinit-utils vim wget && \    
    usermod -aG docker root && \
    usermod -aG docker r00t && \
    usermod -aG sudo ${_AGL} && \
    usermod -aG docker ${_AGL} && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt 
RUN \
    --mount=type=cache,target=/var/cache/dvlp/build-kernel,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --install-recommends -y alien autoconf apt-utils apt-transport-https bison bc build-essential busybox cpio curl dbus-user-session daemonize dwarves fakeroot flex fontconfig \
    gawk gh git gnupg2 kmod libblkid-dev libffi-dev libudev-dev libaio-dev libattr1-dev libelf-dev libpam-systemd libncurses-dev libssl-dev libssl-dev lightdm lxcfs pigz plymouth plzip pkg-config python3-dev \
    python3-setuptools python3-cffi nvi net-tools rsync screen shellcheck ssh systemd-sysv sysvinit-utils snapd systemd-sysv sysvinit-utils uuid-dev virtualbox zstd wget && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt



################################## MAKE #######################################

FROM dvlp_base-builder AS dvlp_base

################################### KERNEL ###########################################

######################################################################################
########################  KERNEL MAKE/R - KERNEL COMPILER  ###########################
######################################################################################

FROM dvlp_base-kernel-builder AS dvlp_base-kernel
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG _WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG KERNEL_PACKAGE_NAME
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ENV KERNEL_TYPE=${KERNEL_TYPE}
ENV KERNEL_FEATURE=${KERNEL_FEATURE}
ENV CONFIG_FILE=${CONFIG_FILE}
# ENV _WIN_USER=${_WIN_USER}
ENV DOCKER_BUILD_TIMESTAMP=${DOCKER_BUILD_TIMESTAMP}
ARG installkernel
# WORKDIR /boot
# WORKDIR /kache
# WORKDIR /usr/lib
# WORKDIR /r00t/dvlw
WORKDIR /r00t/dvlw/dvlp/kernels/linux
USER r00t
SHELL ["/bin/bash", "-c"]
RUN \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y

# WORKDIR /
# ONBUILD COPY --from=dvlp_base${KERNEL_TYPE:+-kernel}-builder ./ ./
SHELL ["/bin/bash", "-c"]
RUN \
    git config --global --add safe.directory /r00t/dvlw/dvlp && \
    git config --global --add safe.directory /r00t/dvlw/dvlp/kernels 
RUN \
    # --mount=type=cache,target=/var/cache/kernel_${KERNEL_TYPE}_${KERNEL_FEATURE}_${CONFIG_FILE},sharing=private \
    bash build-export-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" "${KERNEL_FEATURE}" "${DOCKER_BUILD_TIMESTAMP}" 
RUN \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt

WORKDIR /

# every onbuild command in dvlp_make-kernel will be triggered to run here
# use COPY --from=dvlp_made-kernel instead of COPY --from=dvlp_make-kernel

###############################################################################
########################  dvlp_base-xxxx (cont'd)  ############################
###############################################################################
############################### dvlp_base #####################################

###############
# dvlp_base #
###############
# FROM scratch AS dvlp_base-skel 
# OR
# FROM dvlp_base-builder AS dvlp_base-skel 
# COPY --from=dvlp_base_build ./ ./
# COPY --from=dvlp_made-kernel ./boot/ ./boot/
# COPY --from=dvlp_made-kernel ./usr/src/ ./usr/src/
# COPY --from=dvlp_made-kernel ./usr/lib/modules/ ./usr/lib/modules/
# COPY --from=dvlp_made-kernel ./kache/ ./kache/
# COPY --from=dvlp_made-kernel ./r00t/dvlw/ ./r00t/dvlw/


################################# BASE #######################################

# FROM kindtek/devels-playground:kali-skel-image AS dvlp_base
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _R00T_USR
# ARG _AGL=${_AGL:-agl}
# ARG KERNEL_TYPE
# ARG KERNEL_FEATURE
# ARG CONFIG_FILE
# ARG _WIN_USER
# ARG DOCKER_BUILD_TIMESTAMP
# ARG installkernel
# ENV _AGL=$_AGL
# ENV _DVL=$_DVL_USR
# ENV _R00T=$_R00T_USR
# USER root

# ONBUILD COPY --from=dvlp_made-kernel ./boot/ ./boot/
# ONBUILD COPY --from=dvlp_made-kernel ./usr/src/ ./usr/src/
# WORKDIR /usr/lib/modules
# ONBUILD COPY --from=dvlp_made-kernel ./ ./usr/lib/modules/
# WORKDIR /
# ONBUILD COPY --from=dvlp_made-kernel ./kache/ ./kache/
# ONBUILD COPY --from=dvlp_made-kernel ./r00t/dvlw/ ./r00t/dvlw/
# ONBUILD WORKDIR /r00t/dvlw/dvlp/kernels/linux/linux-build*

###################################################################
######################## KERNEL KACHE #############################
###################################################################

################
# get-kernel #
################

FROM scratch AS dvlp_get-kernel
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG _WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG KERNEL_PACKAGE_NAME
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ENV KERNEL_TYPE=${KERNEL_TYPE}
ENV KERNEL_FEATURE=${KERNEL_FEATURE}
ENV CONFIG_FILE=${CONFIG_FILE}
USER r00t
WORKDIR /boot
WORKDIR /kache
WORKDIR /usr/lib
WORKDIR /
COPY --from=dvlp_madk-kernel ./r00t/dvlw/dvlp/kernels/linux/kache/ ./


#################################################################################
############################### IMAGE BASES #####################################
################################################################################

################################## BARE #########################################
############
# dvlp_cli-bare #
############
FROM dvlp_base AS dvlp_cli-bare
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
USER r00t
WORKDIR /
RUN echo "[user]" | tee /etc/wsl.conf && \
    echo "default = ${_AGL}" | tee --append /etc/wsl.conf && \
    rm -rf /etc/ssl/certs/* && \
    apt-get -y install ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt 


# ################################### CLI #########################################

########################
# dvlp_cli        #
########################
FROM dvlp_base${KERNEL_TYPE:+-kernel} AS dvlp_cli-base

FROM dvlp_cli-base AS dvlp_cli-base-kernel

FROM dvlp_cli-base${KERNEL_TYPE:+-kernel} AS dvlp_cli-builder

FROM dvlp_cli-builder AS dvlp_cli
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
RUN rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    rm -rf /etc/ssl/certs/* && \
    apt-get -y install ca-certificates && \
    update-ca-certificates && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt

########################
# dvlp_base-scan-build #
########################
# FROM kindtek/devels-playground:kali-skel-image AS dvlp_base-scan-builder
# USER r00t
# SHELL ["/bin/bash", "-c"]
# WORKDIR /r00t/build
# RUN \
#     rm -f /etc/apt/apt.conf.d/docker-clean && \
#     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
# RUN \
#     --mount=type=cache,target=/var/cache/dvlp/scan,sharing=locked \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     apt-get install -y --reinstall ca-certificates && \
#     apt-get install -y software-properties-common && \
#     apt-get update --fix-missing && apt-get install -f && \
#     apt-get install -y  --install-suggests autoconf automake build-essential espeak ethtool expect hostapd iw lame libnl-3-dev libnl-genl-3-dev libpcre2-dev libhwloc-dev libssl-dev libsqlite3-dev libtool libcmocka-dev libpcap-dev pkg-config ruby-dev rfkill shtool screen strace tcpdump usbutils wpasupplicant zlib1g-dev && \
#     rm -rf /var/lib/apt/lists && \
#     rm -rf /var/cache/apt
# WORKDIR /r00t/build
# RUN git clone https://github.com/nmap/nmap 
# WORKDIR /r00t/build/nmap
# RUN \
#     ./configure && \
#     make && \
#     make install && \
#     rm -rf /r00t/build/nmap
# WORKDIR /r00t/build
# RUN git clone https://github.com/aircrack-ng/aircrack-ng aircrack
# WORKDIR /r00t/build/aircrack
# ENV NOCONFIGURE=1
# RUN \
#     ./autogen.sh && \
#     ./configure  && \
#     make  && \
#     make check && \
#     make install
# WORKDIR /usr/share
# RUN git clone https://github.com/beefproject/beef beef
# WORKDIR /usr/share/beef
# USER agl
# RUN \
#     gem install bundler
# # RUN \
# #     bundle config set --local with 'test' 
# RUN \
#     yes "" | ./install 
# WORKDIR /
# USER r00t
# RUN rm -rf /etc/ssl/certs/* && \
# apt-get -y install ca-certificates && \
# update-ca-certificates && \
# rm -rf /var/lib/apt/lists && \
# apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
# echo " \
# Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
# rm -rf /var/lib/apt/lists && \
# rm -rf /var/cache/apt 

##################
# dvlp_base-scan #
##################
# FROM dvlp_base-scan-builder AS dvlp_base-scan
# COPY --from=dvlp_python ./ ./
# USER r00t
# RUN \
#     rm -f /etc/apt/apt.conf.d/docker-clean && \
#     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
# RUN \
#     --mount=type=cache,target=/var/cache/dvlp/scan,sharing=locked \
#     # rm -rf /var/lib/apt/lists && \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     apt-get --no-install-recommends -y install burpsuite finger hydra maltego metasploit-framework ncat nmap nikto rpcbind telnet wireshark && \
#     echo " \
# Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm 
# # && \
# #     rm -rf /var/lib/apt/lists && \
# #     rm -rf /var/cache/apt

################################# PYTHON ########################################
#####################
# dvlp_python-build #
#####################
# FROM kindtek/devels-playground:kali-skel-image AS dvlp_python-build
FROM dvlp_cli-builder AS dvlp_cli-goodies
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
USER r00t

RUN \
    # --mount=type=cache,target=/var/cache/dvlp/python,sharing=locked \
    # rm -f /etc/apt/apt.conf.d/docker-clean && \
    # echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get --no-install-recommends -y install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev python3-pip python3-venv pkg-config  && \
    # && \
    # # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # rm -rf /var/cache/apt
    # RUN \
    # --mount=type=cache,target=/var/cache/pip,sharing=locked \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    # RUN \
    #     apt-get --no-install-recommends -y remove libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev 
    ###############################
    # dvlp_python-build #
    ###############################
    # FROM dvlp_python-build AS dvlp_python
    # USER r00t
    # WORKDIR /
    # ARG angel_exists=true
    # ARG devel_exists=true
    # ARG r00t_exists=true
    # RUN \
    #     --mount=type=cache,target=/var/cache/dvlp/python,sharing=locked \
    #     rm -f /etc/apt/apt.conf.d/docker-clean && \
    #     # rm -rf /var/lib/apt/lists && \
    #     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    #     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    #     apt-get install --no-install-recommends -y jq python3-pip python3-venv 
    # && \
    # rm -rf /var/lib/apt/lists && \
    # rm -rf /var/cache/apt
    # WORKDIR /r00t
    # RUN \
    # --mount=type=cache,target=/var/cache/pip,sharing=private \
    # $r00t_exists && 
    # pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    # pip3 install cdir --user --target=/r00t && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt
USER ${_DVL}
WORKDIR /hel
RUN \
    # --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user 
USER ${_AGL}
WORKDIR /hal
# RUN  ( $angel_exists && (chown -R ${_AGL}:halo /hal || chown -R ${_AGL}:halo /hal/.local || angel_exists=false )) 
RUN \
    # --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
USER r00t
WORKDIR /


# RUN apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     apt-get autoremove -y && apt-get remove -y libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev apt-utils



# #########################
# # dvlp_python-lite #
# #########################
# FROM dvlp_python-lite AS dvlp_python-lite
# ARG CONFIG_FILE
# ARG KERNEL_TYPE
# ARG KERNEL_FEATURE
# ARG _WIN_USER
# ARG DOCKER_BUILD_TIMESTAMP
# ARG installkernel
# USER r00t
# WORKDIR / 
# COPY --from=dvlp_python-build ./ ./
# RUN rm -rf /etc/ssl/certs/* && \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     apt-get -y install ca-certificates && \
#     update-ca-certificates && \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     rm -rf /var/lib/apt/lists && \
#     rm -rf /var/cache/apt


######### POWERHELL ###########
###############################
# dvlp_msdot-build-lite #
##############################
# FROM kindtek/devels-playground:kali-skel-image AS dvlp_msdot-build-lite

# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    # --mount=type=cache,target=/var/cache/dvlp/msdot,sharing=locked \
    # rm -f /etc/apt/apt.conf.d/docker-clean && \
    # echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    # rm -rf /var/lib/apt/lists && \
    # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y powershell && \
    # wget "https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb" && \
    # mv packages-microsoft-prod.deb /var/cache/apt/archives/packages-microsoft-prod.deb && \
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/microsoft-prod.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" | tee /etc/apt/sources.list.d/microsoft-prod.list  > /dev/null && \
    # dpkg -i /var/cache/apt/archives/packages-microsoft-prod.deb && \
    #     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # # rm -rf /var/lib/apt/lists && \
    #     rm -rf /var/cache/apt
    #########################
    # dvlp_msdot-build #
    #########################
    # FROM dvlp_msdot-build-lite AS dvlp_msdot-build
    # RUN \
    # --mount=type=cache,target=/var/cache/dvlp/msdot,sharing=locked \
    # rm -f /etc/apt/apt.conf.d/docker-clean && \
    # echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    # rm -rf /var/lib/apt/lists && \
    # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # apt-get install --no-install-recommends -y apt-utils ca-certificates curl gnupg2 apt-transport-https lsb-release wget && \
    # curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    # wget -O - https://pkg.wslutiliti.es/public.key | tee --append /etc/apt/trusted.gpg.d/wslu.asc && \
    # echo "deb [arch=$(dpkg --print-architecture)] https://pkg.wslutiliti.es/kali kali-rolling main" | tee --append /etc/apt/sources.list && \
    # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # # apt-get install -y powershell wslu && \
    # apt-get install --no-install-recommends -y dotnet-sdk-7.0 wslu && \
    # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # rm -rf /var/lib/apt/lists && \
    # rm -rf /var/cache/apt
    # 
    ########################
    # dvlp_msdot-lite #
    ########################
    # FROM dvlp_msdot-builder-lite AS dvlp_msdot-builder
    # ARG _AGL_USR
    # ARG _DVL_USR
    # ARG _R00T_USR
    # ARG _AGL=${_AGL:-agl}
    # ARG KERNEL_TYPE
    # ENV _AGL=$_AGL
    # ENV _DVL=$_DVL_USR
    # ENV _R00T=$_R00T_USR
    # USER r00t
    # WORKDIR /
    # RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    #     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    #     rm -rf /etc/ssl/certs/* && \
    #     apt-get -y install ca-certificates && \
    #     update-ca-certificates && \
    #     rm -rf /var/lib/apt/lists && \
    #     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    #     rm -rf /var/lib/apt/lists && \
    #     rm -rf /var/cache/apt
    # 
    ########################## DOCKER IN DOCKER ######################################
    ########################
    # dvlp_dind-build #
    ########################
    # FROM dvlp_msdot-builder AS dvlp_dind-builder
    # USER r00t
    # WORKDIR /
    # DOCKER - https://docs.docker.com/engine/install/ubuntu/
    # RUN \
    #     --mount=type=cache,target=/var/cache/dvlp/dind,sharing=locked \
    #     rm -f /etc/apt/apt.conf.d/docker-clean && \
    #     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y ca-certificates curl lsb-release gpg && \
    mkdir -pv /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gnupg && \
    # apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt

#######################
# dvlp_dind #
#######################
# FROM dvlp_dind-build AS dvlp_dind-base
# COPY --from=dvlp_base ./ ./

# FROM dvlp_dind-build AS dvlp_dind-base-kernel
# COPY --from=dvlp_base-kernel ./ ./

# FROM dvlp_dind-base${KERNEL_TYPE:+-kernel} AS dvlp_dind_built

# FROM dvlp_dind-builder AS dvlp_dind
# USER r00t
# ARG KERNEL_TYPE
# ARG KERNEL_FEATURE
# ARG CONFIG_FILE
# ARG _WIN_USER
# ARG DOCKER_BUILD_TIMESTAMP
# ARG installkernel
# USER r00t
# WORKDIR /
# RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
#     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
#     rm -rf /etc/ssl/certs/* && \
#     apt-get -y install ca-certificates && \
#     update-ca-certificates && \
#     rm -rf /var/lib/apt/lists && \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     rm -rf /var/lib/apt/lists && \
#     rm -rf /var/cache/apt


#################################### GUI ######################################
##################
# dvlp_gui-lite #
#################
# FROM scratch AS dvlp_gui-lite-base
# COPY --from=dvlp_python ./ ./
# COPY --from=dvlp_msdot-build-lite ./ ./
# COPY --from=dvlp_dind-build ./ ./
# COPY --from=dvlp_base ./ ./
# # COPY --from=dvlp_msdot-build-lite ./etc/apt/trusted.gpg.d/microsoft-prod.gpg ./etc/apt/trusted.gpg.d/microsoft-prod.gpg

# FROM scratch AS dvlp_gui-lite-base-kernel
# COPY --from=dvlp_python ./ ./
# COPY --from=dvlp_msdot-build-lite ./ ./
# COPY --from=dvlp_dind-build ./ ./
# COPY --from=dvlp_base-kernel ./ ./
# # COPY --from=dvlp_msdot-build-lite ./etc/apt/trusted.gpg.d/microsoft-prod.gpg ./etc/apt/trusted.gpg.d/microsoft-prod.gpg

# FROM dvlp_gui-lite-base${KERNEL_TYPE:+-kernel} as dvlp_gui-lite-builder
FROM dvlp_cli-goodies AS dvlp_gui-builder
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/gui-lite,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    rm -rf /var/lib/apt/lists && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    # echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/microsoft-prod.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" | tee /etc/apt/sources.list.d/microsoft-prod.list  > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # RUN \
    #     rm -rf /etc/ssl/certs/* && \
    #     update-ca-certificates 
    apt-get install --install-recommends -y apt-transport-https curl && \
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list && \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y brave-browser bridge-utils libvirt-clients libvirt-daemon-system qemu-system-gui qemu-kvm vlc x11-apps && \
    # change last line of this file - fix for brave-browser displaying empty windows
    cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | tee --append /opt/brave.com/brave/brave-browser > /dev/null && \
    # apt-get install --no-install-recommends -y vlc x11-apps qemu-system-gui qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt
COPY --from=dvlp_repo /repos/dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/${_DVL} && \
# FROM dvlp_gui-lite-builder AS dvlp_gui-lite
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _R00T_USR
# ARG _AGL=${_AGL:-agl}
# ENV _AGL=$_AGL
# ENV _DVL=$_DVL_USR
# ENV _R00T=$_R00T_USR
# ARG REFRESH_REPO
# ARG CONFIG_FILE
# ARG KERNEL_TYPE
# ARG KERNEL_FEATURE
# ARG CONFIG_FILE
# ARG _WIN_USER
# ARG DOCKER_BUILD_TIMESTAMP
# ARG installkernel
# RUN rm -rf /var/lib/apt/lists && \
#     apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
#     rm -rf /etc/ssl/certs/* && \
#     apt-get -y install ca-certificates && \
#     update-ca-certificates && \
#     echo " \
#     Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
#     rm -rf /var/lib/apt/lists && \
#     rm -rf /var/cache/apt

#################
# dvlp_gui #
#################
# wsl2 required
FROM dvlp_gui-builder AS dvlp_gui
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
USER r00t
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/gui,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    # rm -rf /etc/ssl/certs/* && \
    # # apt-get -y install ca-certificates && \
    # update-ca-certificates && \
    # rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install -y gobject-introspection libgirepository1.0-dev xrdp xfce4 xfce4-goodies && \
    apt-get install -y locales && \
    dpkg-reconfigure --frontend noninteractive locales && \
    echo "/usr/sbin/lightdm" | tee /etc/X11/default-display-manager && \
    locale-gen && update-locale && \
    apt-get install -y lightdm && \
    mkdir -pv /var/lib/lightdm/data && \
    echo "set shared/default-x-display-manager lightdm" | debconf-communicate && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y locales kali-defaults kali-root-login desktop-base kali-win-kex kali-desktop-xfce pulseaudio-module-xrdp virt-manager virtualbox && \
    # rm -rf /etc/ssl/certs/* && \
    # apt-get -y install ca-certificates && \
    # update-ca-certificates && \
    # rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    # echo " \
    # Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt
COPY --from=dvlp_repo --chmod=755 /repos/dvlw/dvlp/mnt/etc/* /etc/


FROM dvlp_gui-builder AS dvlp_gui-goodies
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
RUN rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    rm -rf /etc/ssl/certs/* && \
    apt-get -y install ca-certificates && \
    update-ca-certificates && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt

############################## CUDA ###############################
##################
# dvlp_cuda #
##################
FROM dvlp_gui-goodies-builder AS dvlp_gui-cuda-goodies
ARG _R00T=${_R00T:-r00t}
ARG _DVL=${_DVL:-dvl}
ARG _AGL=${_AGL:-agl}
ENV _R00T=$_R00T
ENV _DVL=$_DVL
ENV _AGL=$_AGL
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
ARG _WIN_USER
USER r00t
WORKDIR /
RUN rm -rf /etc/ssl/certs/* && \
    apt-get -y install ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y nvidia-cuda-toolkit && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    # rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt

###################################################################
########################### K-HOME ################################
###################################################################
############
# get-home #
############


FROM scratch AS dvlp_k-home-nix
# ARG WINDOWS
# ARG LINUX
# # determine which home dir to get -- default is HOME_NIX 
ARG HOME_DIR='HOME_NIX'
ARG KERNEL_TYPE
# # if WINDOWS argument is provided, use win home dir
# ARG HOME_DIR="${WINDOWS:+'HOME_WIN'}"
# # if LINUX argument is provided, use nix home dir
# ARG HOME_DIR="${LINUX:+'HOME_NIX'}"
WORKDIR /
COPY --from=dvlp_repo-kernel --chmod=1750 ./repos/ ./
COPY --from=dvlp_base-angel-kernel-volumes-builder ./hal/ ./

FROM dvlp_k-home-nix AS dvlp_k-home-nix-angel


FROM scratch AS dvlp_k-home-nix-devel
# ARG WINDOWS
# ARG LINUX
# # determine which home dir to get -- default is HOME_NIX 
ARG HOME_DIR='HOME_NIX'
ARG KERNEL_TYPE
# # if WINDOWS argument is provided, use win home dir
# ARG HOME_DIR="${WINDOWS:+'HOME_WIN'}"
# # if LINUX argument is provided, use nix home dir
# ARG HOME_DIR="${LINUX:+'HOME_NIX'}"
WORKDIR /
COPY --from=dvlp_repo-kernel --chmod=1750 ./repos/ ./
COPY --from=dvlp_base-devel-kernel-volumes-builder ./hel/ ./

FROM scratch AS dvlp_k-home-nix-r00t
# ARG WINDOWS
# ARG LINUX
# # determine which home dir to get -- default is HOME_NIX 
ARG HOME_DIR='HOME_NIX'
ARG KERNEL_TYPE
# # if WINDOWS argument is provided, use win home dir
# ARG HOME_DIR="${WINDOWS:+'HOME_WIN'}"
# # if LINUX argument is provided, use nix home dir
# ARG HOME_DIR="${LINUX:+'HOME_NIX'}"
WORKDIR /
COPY --from=dvlp_repo-kernel --chmod=1750 ./repos/ ./
COPY --from=dvlp_base-r00t-kernel-volumes-builder ./r00t/ ./


############
# get-home #
############
FROM scratch AS dvlp_k-home-win
# ARG WINDOWS
# ARG LINUX
# determine which home dir to get -- default is HOME_NIX 
# ARG HOME_DIR='HOME_WIN'
# # if WINDOWS argument is provided, use win home dir
# ARG HOME_DIR="${WINDOWS:+'HOME_WIN'}"
# # if LINUX argument is provided, use nix home dir
# ARG HOME_DIR="${LINUX:+'HOME_NIX'}"
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL=${_AGL:-agl}
ARG _DVL
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG _WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR /
COPY --from=dvlp_repo-kernel ./repos/dvlw/dvlp/mnt/HOME_WIN/ ./
COPY --from=dvlp_repo-kernel ./repos/dvlw/ ./repos/kindtek/dvlw/
COPY --from=dvlp_repo-kernel ./repos/dvlw/dvlp/kernels/linux/kache/wsl* ./

# COPY --from=dvlp_repo ./repos/dvlw/dvlp/mnt/${HOME_DIR}/ ./

FROM kindtek/devels-playground:kali-skel AS dvlp_k-home-win-user-mod
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL=${_AGL:-agl}
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG _WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
COPY --from=dvlp_k-home-win ./ ./build/
WORKDIR /build
RUN ls -al
RUN head -n -1 KEX-GUI.rdp > KEX-GUI-temp.rdp
RUN rm KEX-GUI.rdp && mv KEX-GUI-temp.rdp KEX-GUI.rdp
RUN echo "username:s:${_AGL}" >> KEX-GUI.rdp
RUN head -n -1 KDE-GUI.rdp > KDE-GUI-temp.rdp
RUN rm KDE-GUI.rdp && mv KDE-GUI-temp.rdp KDE-GUI.rdp
RUN echo "username:s:${_AGL}" >> KDE-GUI.rdp

# add custom user
FROM scratch AS dvlp_k-home-win-user
# # # # TODO: debug COPY --from=dvlp_k-home-win-user-mod ./build/ ./
COPY --from=dvlp_k-home-win ./ ./
