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
ARG KERNEL_TYPE=${KERNEL_TYPE}
ARG KERNEL_PACKAGE_NAME=${KERNEL_PACKAGE_NAME}
ARG INSTALL_KERNEL="dont_install_kernel"
ARG install=INSTALL
ARG installkernel=${install}_KERNEL
# $ echo ${installkernel}
# dont_install_kernel
# $ echo ${!installkernel}
# INSTALL_KERNEL
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ARG WINDOWS
ARG LINUX
ARG _AGL_USR=${_AGL:-agl}
ARG _DVL_USR=${_DVL:-dvl}
ARG _MNT=${_MNT:-/mnt/data}
ARG JACKET=bare

################
# kali_testing #
################
FROM kalilinux/kali-rolling:latest AS dvlp_testing
WORKDIR /
RUN touch testing

################################### GITHUB REPO #####################################
########################
# dvlp_build-repo-prep #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_build-repo-prep
ARG _MNT
ARG REFRESH_REPO
ARG _AGL_USR
ARG _DVL_USR
ARG _AGL=${_AGL:-agl}
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG DOCKER_TIMESTAMP
ARG KERNEL_PACKAGE_NAME
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
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
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb  && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git && \
    apt-get --reinstall -y install ca-certificates && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb 
# add safe directories
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked  \
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
    git config --global --add safe.directory /var/cache/dvlp/archives && \
    git config --global core.autocrlf input && \
    git config --global user.name 'Snail Mail' && \
    git config --global user.email '<>' && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
########################
# dvlp_build-repo #
#######################
FROM dvlp_build-repo-prep AS dvlp_build-repo
WORKDIR /repos
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked  \
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
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    echo  "git submodule update --init --remote --filter=blob:limit=13k --progress -- dvlp dvl-adv powerhell 2>/dev/null" && \
    git submodule update --init --remote --filter=blob:limit=13k --progress -- dvlp dvl-adv powerhell 2>/dev/null 
WORKDIR /repos/dvlw/dvlp
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    # get default user files
    echo "git submodule update --init --progress -- mnt" && \
    git submodule update --init --progress -- mnt && \
    chmod -R 1770 mnt/HOME_NIX && \
    chmod -R 1770 mnt/bak

###################
# dvlp_build-repo-kernel #
###################
FROM dvlp_build-repo AS dvlp_build-repo-kernel
WORKDIR /repos/dvlw/dvlp
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    # allow download of larger files (kernels)
    git submodule update --init --progress --filter=blob:limit=20m -- kernels 

FROM dvlp_build-repo${KERNEL_TYPE:+-kernel} AS dvlp_built-repo
RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y
    
#############
# dvlp_repo #
#############
FROM scratch AS dvlp_repo
COPY --from=dvlp_build-repo --chmod=1770 ./repos/dvlw/ ./repos/dvlw/
# VOLUME . .
FROM scratch AS dvlp_repo-kernel
# VOLUME . .
COPY --from=dvlp_build-repo-kernel --chmod=1770 ./repos/dvlw/ ./repos/dvlw/
FROM scratch AS dvlp_repos
COPY --from=dvlp_build-repo --chmod=1770 ./repos/dvlw/ ./repos/dvlw/
COPY --from=dvlp_build-repo-kernel --chmod=1770 ./repos/dvlw/ ./repos/dvlw/

# VOLUME . .

####################### BASE volumes AND VOLUME MOUNT POINTS ####################################
########################
# dvlp_base-devel-volumes #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-build-devel-volumes
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
WORKDIR ${_MNT}
RUN ln -fsv ${_MNT}/bak/${_DVL} bak 
# && \
#     chmod -R 1770 ${_MNT}/bak/${_DVL}
# ln -fsv ${_MNT}/bak/${_DVL} /home/${_DVL}/bak 
WORKDIR /

################################
#  dvlp_base-build-devel-volumes #
################################
FROM dvlp_base-build-devel-volumes AS dvlp_base-build-devel-kernel-volumes
ARG _MNT
ARG _DVL
WORKDIR /hel
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN mkdir -pv /hel && \
    mkdir -pv /hel/kache && \
    mkdir -pv /home/${_DVL}/kache && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$(uname -m | grep -o '^[^_]*')/$(echo "$(grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo | grep -Eio --color=never 'intel|amd' || grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo --color=never)" | tr '[:upper:]' '[:lower:]')" "$(uname -m | grep -o '^[^_]*')" && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    chmod -R 1770 /hel && \
    chmod -R 1770 /home/${_DVL} && \
    cp -prv * /home/${_DVL} 
# WORKDIR /home/${_DVL}
# RUN ln -fsv dvlw/dvlp dvlp && \
#     ln -fsv dvlw/dvlp/kernels/linux linux && \
#     ln -fsv dvlw/dvlp/kernels/linux/$(echo "${cpu_arch%%_*}")/amd x64amd && \
#     ln -fsv dvlw/dvlp/kernels kernels && \
WORKDIR /

###############################
#  dvlp_base-built-dvl-volumes #
###############################
FROM dvlp_base-build-devel${KERNEL_TYPE:+-kernel}-volumes AS dvlp_base-built-devel-volumes
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/

#########################
#  dvlp_base-build-angel-volumes #
#########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-build-angel-volumes
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
WORKDIR ${_MNT}
RUN mkdir -pv bak/${_AGL} && \
    chmod -R 1770 bak/${_AGL}
WORKDIR /

################################
#  dvlp_base-build-angel-volumes #
################################
FROM dvlp_base-build-angel-volumes AS dvlp_base-build-angel-kernel-volumes
ARG _MNT
ARG _AGL
WORKDIR /hal
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
# COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/      ./mnt/
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$(uname -m | grep -o '^[^_]*')/$(echo "$(grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo | grep -Eio --color=never 'intel|amd' || grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo --color=never)" | tr '[:upper:]' '[:lower:]')" "$(uname -m | grep -o '^[^_]*')" && \
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
#  dvlp_base-built-agl-volumes #
###############################
FROM dvlp_base-build-angel${KERNEL_TYPE:+-kernel}-volumes AS dvlp_base-built-angel-volumes
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/


########################
#  dvlp_base-build-r00t-volumes #
########################
FROM kalilinux/kali-rolling:latest AS dvlp_base-build-r00t-volumes
ARG _MNT
ARG _ADMIN
WORKDIR /admin
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
# chmod -R 1770 /admin
WORKDIR /mnt
RUN mkdir -pv dls && \
    mkdir -pv bak && \
    mkdir -pv etc && \
    # mkdir -pv home && \
    # mkdir -pv opt && \
    chmod -R 1770 dls && \
    chmod -R 1770 etc && \
    chmod -R 1770 /mnt 
WORKDIR /

###############################
#  dvlp_base-build-r00t-volumes #
###############################
FROM dvlp_base-build-r00t-volumes AS dvlp_base-build-r00t-kernel-volumes
ARG _MNT
ARG _ADMIN
WORKDIR /admin
COPY --from=dvlp_repos ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
RUN ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv "dvlw/dvlp/kernels/linux/$(uname -m | grep -o '^[^_]*')/$(echo "$(grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo | grep -Eio --color=never 'intel|amd' || grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo --color=never)" | tr '[:upper:]' '[:lower:]')" "$(uname -m | grep -o '^[^_]*')" && \
    ln -fsv dvlw/dvlp/kernels kernels && \
    mkdir -pv /admin && mkdir -pv kache
#  && \
# chmod -R 1770 /admin && \
# cp -prv * /home/r00t
WORKDIR /

###############################
#  dvlp_base-built-r00t-volumes #
###############################
FROM dvlp_base-build-r00t${KERNEL_TYPE:+-kernel}-volumes AS dvlp_base-built-r00t-volumes
WORKDIR /
COPY --from=dvlp_repos ./repos/dvlw/ ./repos/dvlw/

FROM scratch AS dvlp_base-built-volumes



############################# BASE BUILD (part 1 ) ###################################
FROM kalilinux/kali-rolling:latest AS dvlp_base-skel
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER root
WORKDIR /

# COPY --from=dvlp_base-r00t-volumes             --chown=r00t:r00t       --chmod=1770    ./admin/                        ./r00t/
# COPY --from=dvlp_base-devel-volumes            --chown=${_DVL}:hell    --chmod=1770    ./hel/                          ./hel/
# COPY --from=dvlp_base-angel-volumes            --chown=${_AGL}:halo    --chmod=1770    ./hal/                          ./hal/
# COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/
# COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
# COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
# COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
# COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
# COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
# COPY --from=dvlp_repo                       --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/

# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
# ONBUILD COPY --from=dvlp_repo${KERNEL_TYPE:+-kernel}                       --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/
# ONBUILD COPY --from=dvlp_base-r00t${KERNEL_TYPE:+-kernel}-volumes             --chown=r00t:r00t       --chmod=1770    ./admin/                        ./r00t/
# ONBUILD COPY --from=dvlp_base-devel${KERNEL_TYPE:+-kernel}-volumes            --chown=${_DVL}:hell    --chmod=1770    ./hel/                          ./hel/
# ONBUILD COPY --from=dvlp_base-angel${KERNEL_TYPE:+-kernel}-volumes            --chown=${_AGL}:halo    --chmod=1770    ./hal/                          ./hal/

ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ARG REFRESH_REPO
USER root
WORKDIR /mnt
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    # mkdir -p /usr/lib/modules && \
    mkdir -p /usr/lib/binfmt.d && \
    mkdir -p /kache && \
    mkdir -p /boot && \
    # mkdir -p /r00t/dvlw && \
    mkdir -m 1770 dls && \
    # mkdir -m 1770 repos  && \
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
    # mkdir -p /r00t/dvlw && \
    chown r00t:w0rld dls && \
    # chown ${_AGL}:halo repos  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -yq && apt-get install -f && apt-get upgrade -yq && \
    apt-get install --no-install-recommends -y apt-utils apt-transport-https curl gh git gnupg2 libssl-dev pigz plzip nvi screen shellcheck ssh systemd-sysv sysvinit-utils wget && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
# COPY --from=dvlp_repos                       --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/
# ONBUILD COPY --from=dvlp_base-r00t${KERNEL_TYPE:+-kernel}-volumes             --chown=r00t:r00t       --chmod=1770    ./admin/                        ./r00t/
# ONBUILD COPY --from=dvlp_base-devel${KERNEL_TYPE:+-kernel}-volumes            --chown=${_DVL}:hell    --chmod=1770    ./hel/                          ./hel/###############################
#  dvlp_base-volumes #
WORKDIR /
###############################

FROM dvlp_base-skel AS dvlp_base-build-volumes
COPY --from=dvlp_base-build-r00t-volumes     --chown=r00t:r00t       --chmod=1770    ./admin/                        ./r00t/
COPY --from=dvlp_base-build-devel-volumes    --chown=${_DVL}:hell    --chmod=1770    ./hel/                          ./hel/
COPY --from=dvlp_base-build-angel-volumes    --chown=${_AGL}:halo    --chmod=1770    ./hal/                          ./hal/
COPY --from=dvlp_base-built-r00t-volumes     --chown=r00t:r00t       --chmod=1770    ./admin/                       ./r00t/
COPY --from=dvlp_base-built-devel-volumes    --chown=${_DVL}:hell    --chmod=1770    ./hel/                         ./hel/
COPY --from=dvlp_base-built-angel-volumes    --chown=${_AGL}:halo    --chmod=1770    ./hal/                         ./hal/
COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hel/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hal/
COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./r00t/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
COPY --from=dvlp_repo                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
COPY --from=dvlp_repo                       --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/ 
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./ ./
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./ ./
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw                   ./hal/dvlw
COPY --from=dvlp_repo                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw                   ./r00t/dvlw
COPY --from=dvlp_repo                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                  ./dvl/dvlw
COPY --from=dvlp_base-built-r00t-volumes     --chown=r00t:r00t       --chmod=1770    ./admin/                       ./r00t/
COPY --from=dvlp_base-built-devel-volumes    --chown=${_DVL}:hell    --chmod=1770    ./hel/                         ./hel/
COPY --from=dvlp_base-built-angel-volumes    --chown=${_AGL}:halo    --chmod=1770    ./hal/                         ./hal/

###############################
#  dvlp_base-build-kernel-volumes #
###############################

FROM dvlp_base-build-volumes AS dvlp_base-build-kernel-volumes
COPY --from=dvlp_base-build-r00t-volumes            --chown=r00t:r00t       --chmod=1770    ./admin/                        ./r00t/
COPY --from=dvlp_base-build-devel-volumes           --chown=${_DVL}:hell    --chmod=1770    ./hel/                          ./hel/
COPY --from=dvlp_base-build-angel-volumes           --chown=${_AGL}:halo    --chmod=1770    ./hal/                          ./hal/
COPY --from=dvlp_base-built-r00t-volumes     --chown=r00t:r00t       --chmod=1770    ./admin/                       ./r00t/
COPY --from=dvlp_base-built-devel-volumes    --chown=${_DVL}:hell    --chmod=1770    ./hel/                         ./hel/
COPY --from=dvlp_base-built-angel-volumes    --chown=${_AGL}:halo    --chmod=1770    ./hal/                         ./hal/
COPY --from=dvlp_repo-kernel                              --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hel/
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./hal/
COPY --from=dvlp_repo-kernel                              --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./r00t/
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
COPY --from=dvlp_repo-kernel                              --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
COPY --from=dvlp_repo-kernel                              --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
COPY --from=dvlp_repo-kernel                              --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/ 
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./ ./
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./ ./
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw                   ./hal/dvlw
COPY --from=dvlp_repo-kernel                              --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw                   ./r00t/dvlw
COPY --from=dvlp_repo-kernel                              --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                  ./dvl/dvlw
COPY --from=dvlp_base-build-r00t-kernel-volumes     --chown=r00t:r00t       --chmod=1770    ./admin/                       ./r00t/
COPY --from=dvlp_base-build-devel-kernel-volumes    --chown=${_DVL}:hell    --chmod=1770    ./hel/                         ./hel/
COPY --from=dvlp_base-build-angel-kernel-volumes    --chown=${_AGL}:halo    --chmod=1770    ./hal/                         ./hal/

FROM dvlp_base-build-volumes AS dvlp_base-build
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ARG REFRESH_REPO
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ENV DEBIAN_FRONTEND=noninteractive
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./repos/dvlw/
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/                   ./hel/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./hal/dvlw/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/                   ./r00t/dvlw/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1774    /repos/dvlw/dvlp/mnt/etc/*      ./etc/
# COPY --from=dvlp_repos                       --chown=r00t:halo       --chmod=1770    ./repos/dvlw/dvlp/mnt/          .${_MNT}/
# COPY --from=dvlp_repos                       --chown=${_DVL}:hell    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hel/
# COPY --from=dvlp_repos                       --chown=${_AGL}:halo    --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./hal/
# COPY --from=dvlp_repos                       --chown=r00t:r00t       --chmod=1770    ./repos/dvlw/dvlp/mnt/HOME_NIX/     ./r00t/

############################# BASE BUILD KERNEL ###################################

FROM dvlp_base-build-kernel-volumes AS dvlp_base-build-kernel
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ARG REFRESH_REPO
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --install-recommends -y apt-utils apt-transport-https curl gh git gnupg2 libssl-dev pigz plzip nvi screen shellcheck ssh systemd-sysv sysvinit-utils wget \
    alien autoconf bison bc build-essential cpio dbus-user-session daemonize dwarves fakeroot \ 
    flex fontconfig gawk git kmod libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev libpam-systemd libncurses-dev \
    libssl-dev pkg-config python3-dev python3-setuptools python3-cffi net-tools rsync snapd systemd-sysv sysvinit-utils uuid-dev zstd  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y

FROM dvlp_base-build${KERNEL_TYPE:+-kernel} AS dvlp_base-built


################################## BASE BUILDER #######################################

FROM dvlp_base-build${KERNEL_TYPE:+-kernel}  AS dvlp_base-builder
WORKDIR /
RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y

FROM dvlp_base-build AS dvlp_make

################################### KERNEL ###########################################

######################################################################################
########################  KERNEL MAKE/R - KERNEL COMPILER  ###########################
######################################################################################

FROM dvlp_base-build-kernel AS dvlp_make-kernel
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ENV KERNEL_TYPE=${KERNEL_TYPE}
ENV KERNEL_FEATURE=${KERNEL_FEATURE}
ENV CONFIG_FILE=${CONFIG_FILE}
ENV WIN_USER=${WIN_USER}
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
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y

# WORKDIR /
# ONBUILD COPY --from=dvlp_base-build${KERNEL_TYPE:+-kernel} ./ ./
SHELL ["/bin/bash", "-c"]
RUN \
    git config --global --add safe.directory /r00t/dvlw/dvlp && \
    git config --global --add safe.directory /r00t/dvlw/dvlp/kernels 
RUN \
    --mount=type=cache,target=/var/cache/kernel_${KERNEL_TYPE}_${KERNEL_FEATURE}_${CONFIG_FILE},sharing=private \
    bash build-import-kernel.sh "${KERNEL_TYPE}" "${CONFIG_FILE}" "${KERNEL_FEATURE}" "${WIN_USER}" "${DOCKER_BUILD_TIMESTAMP}" 
WORKDIR /

FROM dvlp_make-kernel AS dvlp_made-kernel
WORKDIR /
USER r00t
RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
ONBUILD RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

FROM dvlp_make${KERNEL_TYPE:+-kernel} AS dvlp_made
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
# FROM dvlp_base-build AS dvlp_base-skel 
# COPY --from=dvlp_base_build ./ ./
# COPY --from=dvlp_made-kernel ./boot/ ./boot/
# COPY --from=dvlp_made-kernel ./usr/src/ ./usr/src/
# COPY --from=dvlp_made-kernel ./usr/lib/modules/ ./usr/lib/modules/
# COPY --from=dvlp_made-kernel ./kache/ ./kache/
# COPY --from=dvlp_made-kernel ./r00t/dvlw/ ./r00t/dvlw/

FROM dvlp_made AS dvlp_base
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
# WORKDIR /boot
# WORKDIR /kache
# WORKDIR /usr/lib
# WORKDIR /r00t/dvlw
WORKDIR /
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get purge -y openssh-server && \
    apt-get install --no-install-recommends -y sudo openssh-server && \
    usermod -aG docker root && \
    usermod -aG docker r00t && \
    usermod -aG sudo ${_AGL} && \
    usermod -aG docker ${_AGL} 
ONBUILD RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y 

FROM dvlp_make-kernel AS dvlp_base-kernel
ARG _MNT
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y  
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get purge -y openssh-server && \
    apt-get install --no-install-recommends -y sudo openssh-server && \
    usermod -aG docker root && \
    usermod -aG docker r00t && \
    usermod -aG sudo ${_AGL} && \
    usermod -aG docker ${_AGL} 



################################# BASE #######################################

# FROM dvlp_base-skel AS dvlp_base
# ARG _AGL_USR
# ARG _DVL_USR
# ARG _ADM_USR
# ARG _AGL=${_AGL:-agl}
# ARG KERNEL_TYPE
# ARG KERNEL_FEATURE
# ARG CONFIG_FILE
# ARG WIN_USER
# ARG DOCKER_BUILD_TIMESTAMP
# ARG installkernel
# ENV _AGL=$_AGL
# ENV _DVL=$_DVL_USR
# ENV _ADM=$_ADM_USR
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
# kernel-kache #
################

FROM scratch AS dvlp_kernel-kache
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG KERNEL_PACKAGE_NAME
ENV DOCKER_BUILD_TIMESTAMP=${DOCKER_BUILD_TIMESTAMP}
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG WIN_USER
USER r00t
WORKDIR /boot
WORKDIR /kache
WORKDIR /usr/lib
WORKDIR /
COPY --from=dvlp_made-kernel ./r00t/dvlw/dvlp/kernels/linux/kache/ ./


#################################################################################
############################### IMAGE BASES #####################################
################################################################################

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_base AS dvlp_bare
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR /
RUN echo "[user]" | tee /etc/wsl.conf
RUN echo "default = ${_AGL}" | tee --append /etc/wsl.conf
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d   && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


# ################################### GIT #########################################

########################
# dvlp_git        #
########################
FROM dvlp_base${KERNEL_TYPE:+-kernel} AS dvlp_git-build

FROM dvlp_git-build AS dvlp_git-build-kernel

FROM dvlp_git-build${KERNEL_TYPE:+-kernel} as dvlp_git_built

FROM dvlp_git_built AS dvlp_git
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


########################
# dvlp_base-scan-build #
########################
FROM dvlp_git AS dvlp_base-scan-build
USER r00t
SHELL ["/bin/bash", "-c"]
WORKDIR /r00t/build
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    # printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install -y --reinstall ca-certificates && \
    apt-get install -y software-properties-common && \
    apt-get update --fix-missing && apt-get install -f && \
    apt-get install -y  --install-suggests autoconf automake build-essential espeak ethtool expect hostapd iw lame libnl-3-dev libnl-genl-3-dev libpcre2-dev libhwloc-dev libssl-dev libsqlite3-dev libtool libcmocka-dev libpcap-dev pkg-config ruby-dev rfkill shtool screen strace tcpdump usbutils wpasupplicant zlib1g-dev && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
WORKDIR /r00t/build
RUN git clone https://github.com/nmap/nmap 
WORKDIR /r00t/build/nmap
RUN \
    ./configure && \
    make && \
    make install && \
    rm -rf /r00t/build/nmap
WORKDIR /r00t/build
RUN git clone https://github.com/aircrack-ng/aircrack-ng aircrack
WORKDIR /r00t/build/aircrack
ENV NOCONFIGURE=1
RUN \
    ./autogen.sh && \
    ./configure  && \
    make  && \
    make check && \
    make install
WORKDIR /usr/share
RUN git clone https://github.com/beefproject/beef beef
WORKDIR /usr/share/beef
USER agl
RUN \
    gem install bundler
# RUN \
#     bundle config set --local with 'test' 
RUN \
    yes "" | ./install 
WORKDIR /
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /etc/ssl/certs && \
rm -rf /var/lib/apt/lists && \
rm -rf /var/cache/apt/archives/*.deb && \
apt-get update -y && apt-get upgrade -y && \
apt-get --reinstall -y install ca-certificates && \
update-ca-certificates && \
apt-get update -y && apt-get upgrade -y && \
echo " \
Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
rm -rf /var/cache/apt && \
rm -rf /var/lib/apt/lists && \
rm -rf /var/cache/apt/archives/*.deb

##################
# dvlp_base-scan #
##################
FROM dvlp_base-scan-build AS dvlp_base-scan
COPY --from=dvlp_python-lite ./ ./
USER r00t
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get --no-install-recommends -y install burpsuite finger hydra maltego metasploit-framework ncat nmap nikto rpcbind telnet wireshark
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /etc/ssl/certs && \
rm -rf /var/lib/apt/lists && \
rm -rf /var/cache/apt/archives/*.deb && \
apt-get update -y && apt-get upgrade -y && \
apt-get --reinstall -y install ca-certificates && \
update-ca-certificates && \
apt-get update -y && apt-get upgrade -y && \
echo " \
Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

################################# PYTHON ########################################
#####################
# dvlp_python-build #
#####################
FROM dvlp_base AS dvlp_python-build
ARG _AGL_USR
ARG _DVL_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
USER r00t
WORKDIR /

RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get --no-install-recommends -y install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev  libpython3-dev pkg-config python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y
# RUN \
#     apt-get --no-install-recommends -y remove libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev 

###############################
# dvlp_python-build #
###############################
FROM dvlp_python-build AS dvlp_python-lite
USER r00t
WORKDIR /
ARG angel_exists=true
ARG devel_exists=true
ARG r00t_exists=true
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y jq python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
WORKDIR /r00t
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    $r00t_exists && pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user --target=/r00t || r00t_exists=false
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
    pip3 install pip --upgrade --no-warn-script-location --no-deps || angel_exists=false && \
    pip3 install cdir --user || devel_exists=false 

USER r00t
RUN rm -rf /var/cache/pip/* && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
    
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get autoremove -y && apt-get remove -y libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev apt-utils
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


#########################
# dvlp_python-lite #
#########################
FROM dvlp_python-lite AS dvlp_python
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR / 
# COPY --from=dvlp_python-build ./ ./
RUN rm -rf /var/cache/pip/* && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


######### POWERHELL ###########
###############################
# dvlp_msdot-build-lite #
##############################
FROM dvlp_base AS dvlp_msdot-build-lite

# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb 
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y apt-utils ca-certificates curl gnupg2 apt-transport-https lsb-release wget && \
    wget "https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb" && \
    mv packages-microsoft-prod.deb /var/cache/apt/archives && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d//microsoft-prod.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" | tee /etc/apt/sources.list.d/microsoft-prod.list  > /dev/null && \
    dpkg -i /var/cache/apt/archives/packages-microsoft-prod.deb && \
    # curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    wget -O - https://pkg.wslutiliti.es/public.key | tee --append /etc/apt/trusted.gpg.d/wslu.asc && \
    echo "deb [arch=$(dpkg --print-architecture)] https://pkg.wslutiliti.es/kali kali-rolling main" | tee --append /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y powershell wslu && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y


#########################
# dvlp_msdot-build #
#########################
FROM dvlp_msdot-build-lite AS dvlp_msdot-build
USER r00t

RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y dotnet-sdk-7.0  && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

########################
# dvlp_msdot-lite #
########################
FROM dvlp_msdot-build-lite AS dvlp_msdot-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ARG KERNEL_TYPE
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
COPY --from=dvlp_git ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./

ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

########################
# dvlp_msdot-kernel #
########################
FROM dvlp_base AS dvlp_msdot
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
USER r00t
WORKDIR /
COPY --from=dvlp_base-build         ./      ./
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

########################## DOCKER IN DOCKER ######################################
########################
# dvlp_dind-build #
########################
FROM dvlp_base AS dvlp_dind-build
USER r00t
WORKDIR /
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y ca-certificates curl lsb-release gpg && \
    mkdir -pv /etc/apt/keyrings

ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null
ONBUILD RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gnupg && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/cache/apt && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

#######################
# dvlp_dind-lite #
#######################
FROM dvlp_base AS dvlp_dind-lite
USER r00t
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

##################
# dvlp_dind #
##################
FROM dvlp_base AS dvlp_dind
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

#################################### GUI ######################################
##################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_base AS dvlp_gui-lite
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
USER r00t
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache && \
    echo 'Acquire::Retries "3";' | tee /etc/apt/apt.conf.d/50kali && \
    rm -rf /var/cache/apt && \
    rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get install --install-recommends -y apt-transport-https curl 
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list 
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y brave-browser virtualbox vlc x11-apps  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb

# change last line of this file - fix for brave-browser displaying empty windows
RUN cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | tee --append /opt/brave.com/brave/brave-browser > /dev/null
COPY --from=dvlp_repo /repos/dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/${_DVL} && \
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


#################
# dvlp_gui #
#################
# wsl2 required
FROM dvlp_gui-lite AS dvlp_gui
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
ARG REFRESH_REPO
ARG DEBIAN_FRONTEND
ARG DEBCONF_NONINTERACTIVE_SEEN
USER r00t
WORKDIR /
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install -y locales && \    
    update-locale LANGUAGE="C" && \
    update-locale LANG="C" && \
    update-locale LC_ALL="C" && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime  
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get install -y locales && \
    dpkg-reconfigure --frontend noninteractive locales && \
    echo "/usr/sbin/lightdm" | tee /etc/X11/default-display-manager && \
    locale-gen && update-locale 
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install -y xrdp xfce4 xfce4-goodies 
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get install -y lightdm && \
    echo "set shared/default-x-display-manager lightdm" | debconf-communicate && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y locales kali-defaults kali-root-login desktop-base kali-win-kex kali-desktop-xfce pulseaudio-module-xrdp && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb
COPY --from=dvlp_repo --chmod=755 /repos/dvlw/dvlp/mnt/etc/* /etc/
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN rm -rf /var/cache/dvlp/archives && \
    rm -rf /etc/ssl/certs && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get --reinstall -y install ca-certificates && \
    update-ca-certificates && \
    apt-get update -y && apt-get upgrade -y && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb


############################## CUDA ###############################
##################
# dvlp_cuda #
##################
FROM dvlp_gui AS dvlp_cuda
ARG _AGL_USR
ARG _DVL_USR
ARG _ADM_USR
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL
ENV _DVL=$_DVL_USR
ENV _ADM=$_ADM_USR
USER r00t
WORKDIR /
# COPY --from=dvlp_python-build ./ ./
# COPY --from=dvlp_msdot-build-lite ./ ./
# COPY --from=dvlp_dind-build ./ ./
# COPY --from=dvlp_base-kernel-build ./ ./
# # COPY --from=dvlp_base-kernel-lite ./ ./
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee --append /etc/apt/apt.conf.d/keep-cache
ONBUILD USER r00t
ONBUILD WORKDIR /
ONBUILD RUN \
    --mount=type=cache,target=/var/cache/dvlp/archives,sharing=locked \
    rm -rf /var/cache/apt && \
    apt-get update --fix-missing -y && apt-get install -f && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y nvidia-cuda-toolkit && \
    echo " \
    Binary::apt-get::APT::Install-Recommends 'true';" | tee --append /etc/apt/apt.conf.d/98aptsuggrecomm && \
    echo 'exit 0;' | tee /usr/sbin/policy-rc.d  && \
    rm -rf /var/lib/apt/lists && \
    rm -rf /var/cache/apt/archives/*.deb   

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
USER r00t
WORKDIR /
COPY --from=dvlp_repo-kernel ./repos/dvlw/dvlp/mnt/HOME_NIX/ ./
# COPY --from=dvlp_repo ./repos/dvlw/dvlp/mnt/${HOME_DIR}/ ./

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
ARG WIN_USER
ARG DOCKER_BUILD_TIMESTAMP
ARG installkernel
USER r00t
WORKDIR /
COPY --from=dvlp_repo-kernel ./repos/dvlw/dvlp/mnt/HOME_WIN/ ./
COPY --from=dvlp_repo-kernel ./repos/dvlw/ ./repos/kindtek/dvlw/
COPY --from=dvlp_repo-kernel ./repos/dvlw/dvlp/kernels/linux/kache/ ./
# COPY --from=dvlp_repo ./repos/dvlw/dvlp/mnt/${HOME_DIR}/ ./

FROM kalilinux/kali-rolling:latest AS dvlp_k-home-win-user-mod
ARG _AGL=${_AGL:-agl}
ENV _AGL=$_AGL=${_AGL:-agl}
ARG CONFIG_FILE
ARG KERNEL_TYPE
ARG KERNEL_FEATURE
ARG CONFIG_FILE
ARG WIN_USER
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
