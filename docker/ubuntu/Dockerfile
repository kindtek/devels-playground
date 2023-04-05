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
FROM ubuntu:latest AS dvlp_base-fs_devel-lite
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
RUN mkdir -pv /home/dvl && \
    # mkdir -pv /home/dvl/dvlw && \
    mkdir -pv /home/dvl/dls && \
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
    mkdir -pv ${mnt_data}/bak/dvl && \
    chmod 753 ${mnt_data}/bak/dvl && \
    ln -fsv ${mnt_data}/bak/dvl /home/dvl/bak && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose  -d /home/dvl && \
# install --verbose  -d /hel && \
# install --verbose  -d /hell && \
# install --verbose  -m 753 -d ${mnt_data}/bak/dvl && \
# ln -fsv ${mnt_data}/bak/dvl /home/dvl/bak 

# agl permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_angel-lite
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
RUN mkdir -pv /home/agl && \
    mkdir -pv /home/agl/dvlw && \
    mkdir -pv /home/agl/dls && \
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
    mkdir -pv ${mnt_data}/bak/agl && \
    chmod 753 ${mnt_data}/bak/agl && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose -d /home/agl && \
#     install --verbose -d /halo  && \
#     install --verbose -d /halo/hal  && \
#     install --verbose -m 753 -d ${mnt_data}/bak/agl && \
#     ln -fsv ${mnt_data}/bak/agl /home/agl/bak


# god permissions/volume builder
FROM ubuntu:latest AS dvlp_base-fs_god-lite
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
RUN mkdir -pv /home/god && \
    mkdir -pv /home/god/dls && \
    mkdir -pv /home/god/dvlw && \
    mkdir -pv /root/root && \
    mkdir -pv /root/dls && \
    mkdir -pv ${mnt_data}/dls && \
    mkdir -pv ${mnt_data}/bak && \
    mkdir -pv /root/dvlw && \
    mkdir -pv /root/root/dls && \
    mkdir -pv /root/root/dvlw && \
    mkdir -pv /dls && \
    mkdir -pv /fs && \
    mkdir -pv /dvlw && \
    ln -fsv /root/root/halo /halo && \
    ln -fsv /root/root/hell /hell  && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -fsv dvlw/dvlp/docker docker
WORKDIR /

# RUN install --verbose -d /root && \
#     install --verbose -d /home/god && \
#     install --verbose -d /root && \
#     install --verbose -d /dls && \
#     install --verbose -d /fs
# && \
# install -o agl -g halo -d halo && \
# install -o dvl -g hell -d hell 
# && \
#     ln -sv /home/god/bak /mnt/data/bak 

FROM ubuntu:latest AS dvlp_base-fs_devel
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /hel
# RUN install -o dvl -g hell -d /home/dvl /hel /hell && \
# ln -fsv /home/dvl /hel && \
# ln -fsv /home/dvl /hell && \
# ln -sfv /home/dvl /home/dvl && \
RUN mkdir -pv /hel && ln -fsv dvlw devels-workshop && \
    mkdir -pv /hal/built-kernels && \
    mkdir -pv /halo/hal/built-kernels && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels WORKDIR /
WORKDIR /


FROM ubuntu:latest AS dvlp_base-fs_angel
WORKDIR /hal
ARG mnt_data=${mnt_data:-/mnt/data}
RUN mkdir -pv /hal && ln -fsv dvlw devels-workshop && \
    mkdir -pv /hal/built-kernels && \
    mkdir -pv /halo/hal/built-kernels && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
# ln -fsv /home/agl /halo 
WORKDIR /

FROM ubuntu:latest AS dvlp_base-fs_god
WORKDIR /root/root
ARG mnt_data=${mnt_data:-/mnt/data}
RUN mkdir -pv /root/root && ln -fsv dvlw devels-workshop && \
    mkdir -pv /root/root/built-kernels && \
    ln -fsv dvlw/dvlp dvlp && \
    ln -fsv dvlw/dvlp/kernels/linux linux && \
    ln -fsv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -fsv dvlw/dvlp/kernels kernels 
WORKDIR /


# FROM scratch AS dvlp_base-fs_permissions
# #COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./hel ./hel
# COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./hell ./hell
# COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./home ./home
# COPY --from=dvlp_base-fs_devel --chown=agl:dvl ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel --chown=agl:agl ./hal ./hal
# COPY --from=dvlp_base-fs_angel --chown=agl:agl ./halo ./halo
# COPY --from=dvlp_base-fs_angel --chown=agl:agl ./home ./home
# COPY --from=dvlp_base-fs_angel --chown=agl:agl ./mnt ./mnt

# COPY --from=dvlp_base-fs_god --chown=god:r00t ./home ./home
# # COPY --from=dvlp_base-fs_god --chown=god:r00t ./root/root ./root/root
# COPY --from=dvlp_base-fs_god --chown=god:r00t ./root/root ./root/root
# COPY --from=dvlp_base-fs_god --chown=god:r00t ./fs ./fs

# FROM scratch AS dvlp_base-fs_permissions-lite
# COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./hel ./hel
# # COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./hell ./hell
# COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./home ./home
# COPY --from=dvlp_base-fs_devel-lite --chown=agl:dvl ./mnt ./mnt

# COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./hal ./hal
# # COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./halo ./halo
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./home ./home
# COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./mnt ./mnt

# COPY --from=dvlp_base-fs_god-lite --chown=god:r00t ./home ./home
# # COPY --from=dvlp_base-fs_god-lite --chown=god:r00t ./root/root ./root/root
# COPY --from=dvlp_base-fs_god-lite --chown=god:r00t ./root ./root
# # COPY --from=dvlp_base-fs_god-lite --chown=god:r00t ./fs ./fs


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
    apt-get upgrade -y 
#   apt-get -y install sudo apt-fast

# adduser --home /home/god --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS god && \
RUN addgroup --gid 4321 --force-badname r00t  && \
    addgroup --gid 777 agl && \
    addgroup --gid 666 dvl && \
    useradd -s /bin/bash  -u 0 -o -g root -G r00t,agl,dvl -d /root/root r00t && \
    # usermod -aG r00t god  && \
    # usermod -g 0 -u 0 -o god  && \
    chown -R r00t:r00t /root  && \
    # usermod -g 0 -u 0 -o god  && \
    usermod -d /root/root r00t && \
    passwd -d r00t && \
    # passwd -d agl && \
    # passwd -d dvl && \
    passwd -l r00t  && \
    passwd -d root && \
    # passwd -d agl && \
    # passwd -d dvl && \
    passwd -l root  && \
    echo "[user] \
    default=dvl" >> /etc/wsl.conf 
USER r00t
# adduser --home /home/agl --ingroup halo --shell /bin/bash --uid agl --disabled-password --gecos GECOS agl && \
# adduser --home /home/dvl --ingroup hell --shell /bin/bash --uid dvl --disabled-password --gecos GECOS dvl && \
#    RUN adduser --shell /bin/bash --uid 777 --gid 777  --disabled-password --gecos GECOS --no-create-home agl && \
#     adduser --shell /bin/bash --uid 666 --gid 777 --disabled-password --gecos GECOS --no-create-home dvl 

# usermod -aG sudo god && \
# rm -rf /home/god* && rm -rf /root/root* && \
# rm -rf /home/dvl/* && rm -rf /home/agl/* && \
# add agl to the sudo list
# add god to both groups
# ensure no passwords
# make dvl default wsl user 
# run as god asap
# COPY --from=dvlp_base-fs_permissions ./ ./
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./hel/ ./fs/hel/
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./hell/ ./fs/hell/
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./home/ ./fs/home/
COPY --from=dvlp_base-fs_devel-lite --chown=dvl:dvl ./mnt/ ./fs/mnt/
##############################################################
COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./hal/ ./fs/hal/
COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./halo/ ./fs/halo/
COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./home/ ./fs/home/
COPY --from=dvlp_base-fs_angel-lite --chown=agl:agl ./mnt/ ./fs/mnt/
##############################################################
COPY --from=dvlp_base-fs_god-lite --chown=r00t:r00t ./root/root/ ./fs/root/root/
COPY --from=dvlp_base-fs_god-lite --chown=r00t:r00t ./home/ ./fs/home/
COPY --from=dvlp_base-fs_god-lite --chown=r00t:r00t ./fs/ ./fs/fs/
COPY --from=dvlp_base-fs_god-lite --chown=r00t:r00t ./mnt/ ./fs/mnt/
##############################################################

RUN useradd -s /bin/bash  -u 666 -o -g dvl -d /hel devel 
RUN useradd -s /bin/bash  -u 777 -o -g agl -d /hal angel 
RUN passwd -d angel && \
    passwd -d devel
RUN apt-get -y install sudo && \
    usermod -aG sudo angel && \
    chown r00t:r00t /fs && \
    cp -r /lib /usr /mnt /bin /opt /lib64 /tmp /sbin /media /etc /root /boot /var /fs && \
# apt-get -y install sudo debootstrap && \
# sudo debootstrap sid chroot && \
    useradd -s /bin/bash  -u 0 -o -g root -G r00t,agl,dvl -d /root/root --root /fs god && \
    useradd -s /bin/bash  -u 666  -o -g root -G dvl -d /hel --root /fs dvl && \
    useradd -s /bin/bash  -u 777 -o -g root -G agl -d /hal --root /fs agl     
RUN chroot --userspec=god:r00t /fs usermod -aG sudo agl && \
    chroot --userspec=god:r00t /fs echo "[user] \
    default=dvl" >> /etc/wsl.conf && \
    chroot --userspec=god:r00t /fs passwd -d agl && \
    chroot --userspec=god:r00t /fs passwd -d dvl
FROM dvlp_base-fs-lite AS dvlp_base-fs
COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./hel/ ./fs/hel/
# COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./hell/ ./fs/hell/
COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./home/ ./fs/home/
COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./mnt/ ./fs/mnt/

COPY --from=dvlp_base-fs_angel --chown=agl:agl ./hal/ ./fs/hal/
# COPY --from=dvlp_base-fs_angel --chown=agl:agl ./halo/ ./fs/halo/
COPY --from=dvlp_base-fs_angel --chown=agl:agl ./home/ ./fs/home/
COPY --from=dvlp_base-fs_angel --chown=agl:agl ./mnt/ ./fs/mnt/

COPY --from=dvlp_base-fs_god --chown=god:r00t ./root/root/ ./fs/root/root/
COPY --from=dvlp_base-fs_god --chown=god:r00t ./home/ ./fs/home/
# COPY --from=dvlp_base-fs_god --chown=god:r00t ./fs/ ./fs/fs/

################################### REPO ####################################
#############
# dvlp_repo #
#############
FROM dvlp_base-fs-lite AS dvlp_repo-build-prep
ARG mnt_data=${mnt_data:-/mnt/data}
ARG REFRESH_REPO=${REFRESH_REPO:-no}
WORKDIR /fs
# RUN mkdir -p /tmp/git/cache && \
# chown -R god:r00t /tmp/git/cache && \
#     mkdir -p /dvlw && \
#     chown -R god:r00t /dvlw
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
    git config --global --add safe.directory /fs/home/dvl && \
    git config --global --add safe.directory /fs/hel && \
    git config --global --add safe.directory /fs/tmp/git/cache

FROM dvlp_repo-build-prep AS dvlp_repo-build-lite
WORKDIR /fs
# COPY --from=dvlp_base-fs_devel --chown=dvl:dvl ./hell/ ./hell/

# clone fresh repos and give dvl ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
RUN \
    --mount=type=cache,target=/tmp/git/cache \
    git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --filter=blob:limit=12400 --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/dvl/dvlw)
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /fs/dvlw
# RUN if [ $REFRESH_REPO != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --progress -- dvlp || git pull \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/dvl/dvlw/dvlp)
    chmod -R +x dvlp/mnt/home && \
    chmod -R +x dvlp/mnt/bak

FROM dvlp_repo-build-lite AS dvlp_repo-build
WORKDIR /
COPY --from=dvlp_base-fs ./fs/home/ ./fs/home/
COPY --from=dvlp_base-fs ./fs/mnt/ ./fs/mnt/
COPY --from=dvlp_base-fs ./fs/hel/ ./fs/hel/
COPY --from=dvlp_base-fs ./fs/hal/ ./fs/hal/
COPY --from=dvlp_base-fs ./fs/root/root/ ./fs/root/root/
# clone fresh repos and give dvl ownership
# git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress /tmp/git/cache/dvlw  \
# RUN \
#     --mount=type=cache,target=/tmp/git/cache \
#     git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw || (cd dvlw && git pull) 
# (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/dvl/dvlw)
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
#     # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/dvl/dvlw/dvlp)
#     chmod -R +x mnt/home && \
#     chmod -R +x mnt/bak

# RUN if [ "$REFRESH_REPO" != no ]; then git pull; fi    
WORKDIR /

FROM scratch AS dvlp_repo-lite
COPY --from=dvlp_repo-build-lite ./fs/dvlw/ ./fs/dvlw/
FROM scratch AS dvlp_repo
COPY --from=dvlp_repo-build ./fs/dvlw/ ./fs/dvlw/

############################## SKELETON ###################################
########################
# dvlp_skel-build-lite #
########################
FROM dvlp_repo-build-lite AS dvlp_skel-build-lite
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /

COPY --from=dvlp_repo-lite               --chown=dvl:dvl    ./fs/dvlw/dvlp/mnt/home/  ./fs/hel/
COPY --from=dvlp_repo-lite               --chown=agl:agl    ./fs/dvlw/dvlp/mnt/home/  ./fs/hal/
COPY --from=dvlp_repo-lite               --chown=god:r00t  ./fs/dvlw/dvlp/mnt/home/  ./fs/root/root/
COPY --from=dvlp_repo-lite               --chown=god:agl   ./fs/dvlw/dvlp/mnt/       ./fs${mnt_data}/

## WORKDIR /hell
###################
# dvlp_skel-build #
###################
FROM dvlp_repo-build-lite AS dvlp_skel-build
ARG REFRESH_REPO=${REFRESH_REPO:-no}
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
COPY --from=dvlp_repo                --chown=dvl:dvl    ./fs/dvlw/dvlp/mnt/home/  ./fs/hel/
COPY --from=dvlp_repo                --chown=agl:agl    ./fs/dvlw/dvlp/mnt/home/  ./fs/hal/
COPY --from=dvlp_repo                --chown=god:r00t  ./fs/dvlw/dvlp/mnt/home/  ./fs/root/root/
COPY --from=dvlp_repo                --chown=god:agl   ./fs/dvlw/dvlp/mnt/       ./fs${mnt_data}/

# COPY --from=dvlp_skel-build-lite --chown=god:agl      .${mnt_data}/   .${mnt_data}/
# COPY --from=dvlp_skel-build-lite --chown=agl:agl      .${mnt_data}/bak .${mnt_data}/bak
# COPY --from=dvlp_skel-build-lite --chown=dvl:dvl       ./hel/          ./hel/
# COPY --from=dvlp_skel-build-lite --chown=agl:agl       ./hal/          ./hal/
# COPY --from=dvlp_skel-build-lite --chown=god:r00t     ./root/root/    ./root/root/

# COPY --from=dvlp_base-fs ./etc/passwd ./etc/passwd
# COPY --from=dvlp_base-fs ./etc/group ./etc/group
# # COPY --from=dvlp_base-fs ./lib/x86_64-linux-gnu ./lib/x86_64-linux-gnu
# # COPY --from=dvlp_base-fs_devel  --chown=dvl:dvl    ./home/dvl/     ./home/dvl/
# # COPY --from=dvlp_base-fs_angel  --chown=agl:agl    ./home/agl/     ./home/agl/
# # COPY --from=dvlp_base-fs_god   --chown=god:r00t  ./home/god/    ./home/god/
# # # COPY --from=dvlp_base-fs_devel --chown=dvl:dvl   .${mnt_data}    .${mnt_data}
# # # COPY --from=dvlp_base-fs_angel --chown=agl:agl   .${mnt_data}    .${mnt_data}
# COPY --from=dvlp_repo           --chown=dvl:dvl    ./home/dvl/dvlw/dvlp/mnt/home/  ./home/dvl/
# COPY --from=dvlp_repo           --chown=agl:agl    ./home/dvl/dvlw/dvlp/mnt/home/  ./home/agl/
# COPY --from=dvlp_repo           --chown=god:r00t  ./home/dvl/dvlw/dvlp/mnt/home/  ./home/god/
# # COPY --from=dvlp_base-fs_devel  --chown=agl:agl    .${mnt_data}/                   .${mnt_data}/
# # COPY --from=dvlp_base-fs_angel  --chown=agl:agl    .${mnt_data}/                   .${mnt_data}/
# COPY --from=dvlp_repo           --chown=god:agl   ./home/dvl/dvlw/dvlp/mnt/       .${mnt_data}/
# # COPY --from=dvlp_repo           --chown=agl:agl    .${mnt_data}                    .${mnt_data}
# COPY --from=dvlp_base-fs_devel  --chown=dvl:dvl    ./home/dvl/                     ./home/dvl/
# COPY --from=dvlp_base-fs_angel  --chown=agl:agl    ./home/agl/                     ./home/agl/
# COPY --from=dvlp_base-fs_god   --chown=god:r00t  ./home/god/                    ./home/god/
# COPY --from=dvlp_base-fs_devel --chown=god:r00t ./home/dvl/                     ./home/god/
# COPY --from=dvlp_base-fs_devel --chown=agl:agl   ./home/dvl/                     ./home/agl/
# USER root
# WORKDIR /hell
# # SHELL ["/bin/bash", "-c"]
# USER devel
# WORKDIR /hell
# # # FROM dvlp_base-fs AS dvlp_base-fs2
# # # COPY --from=dvlp_skel-build --chown=god:r00t   ./ ./fs/
#############
# dvlp_skel #
#############
FROM dvlp_skel-build AS dvlp_skel
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && \
    apt-get -y install apt-transport-https curl gh git gnupg2 libssl-dev nvi wget

# FROM dvlp_skel-prep AS dvlp_skel2
# # # RUN  cp -r /lib /usr /mnt /bin /opt /lib64 /tmp /home /sbin /media /etc /root /boot /var /fs
# COPY --from=dvlp_skel-build --chown=god:r00t ./lib/ ./fs/lib/
# COPY --from=dvlp_skel-build --chown=god:r00t ./usr/ ./fs/usr/
# COPY --from=dvlp_skel-build --chown=god:r00t ./mnt/ ./fs/mnt/
# COPY --from=dvlp_skel-build --chown=god:r00t ./bin/ ./fs/bin/
# COPY --from=dvlp_skel-build --chown=god:r00t ./opt/ ./fs/opt/
# COPY --from=dvlp_skel-build --chown=god:r00t ./lib64/ ./fs/tmp/
# COPY --from=dvlp_skel-build --chown=god:r00t ./home/ ./fs/home/
# COPY --from=dvlp_skel-build --chown=god:r00t ./sbin/ ./fs/sbin/
# COPY --from=dvlp_skel-build --chown=god:r00t ./media/ ./fs/media/
# COPY --from=dvlp_skel-build --chown=god:r00t ./etc/ ./fs/etc/
# COPY --from=dvlp_skel-build --chown=god:r00t ./root/ ./fs/root/
# COPY --from=dvlp_skel-build --chown=god:r00t ./boot/ ./fs/boot/
# COPY --from=dvlp_skel-build --chown=god:r00t ./var/ ./fs/var/

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
# # COPY --from=dvlp_skel-build-lite --chown=god:r00t ./ ./fs/
# # USER agl
# # WORKDIR /halo
# # RUN chown god:r00t /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal agl && chown -R agl:agl /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel dvl && chown -R dvl:dvl /hell
# # WORKDIR /root/root
# # RUN usermod -d /root/root god && chown -R god:r00t /root/root

# # lock down volumes, permissions
# FROM dvlp_skel-install AS dvlp_skel
# ARG REFRESH_REPO=${REFRESH_REPO:-no}
# WORKDIR /
# # COPY --from=dvlp_skel-build                       ./            ./
# COPY --from=dvlp_skel-install                     ./            ./
# # COPY --from=dvlp_skel-build    --chown=god:r00t ./            ./fs/
# COPY --from=dvlp_skel-install  --chown=god:r00t ./            ./fs/
# # COPY --from=dvlp_base-fs_devel --chown=dvl:dvl   ./home/dvl/   ./home/dvl/
# # COPY --from=dvlp_base-fs_angel --chown=agl:agl   ./home/agl/   ./home/agl/
# # COPY --from=dvlp_base-fs_god  --chown=god:r00t ./home/god/  ./home/god/
# # USER agl
# # WORKDIR /halo
# # RUN chown god:r00t /halo 
# # WORKDIR /hal
# # RUN usermod -d /hal agl && chown -R agl:agl /hal 
# # WORKDIR /hell
# # RUN usermod -d /hel dvl && chown -R dvl:dvl /hell && chown -R dvl:dvl /hell 
# # WORKDIR /root/root
# # RUN usermod -d /root/root god && chown -R god:r00t /root/root

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_skel-build-lite AS dvlp_bare
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-build-lite ./ ./
# COPY --from=dvlp_repo --chown=dvl:dvl  ./dvlw/ ./home/dvl/dvlw/
WORKDIR /hel
USER devel

################################### GIT #########################################
#################
# dvlp_git_lite #
#################
FROM dvlp_skel-build AS dvlp_git-lite
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
# COPY --from=dvlp_base-fs ./ ./
# COPY --from=dvlp_skel-lite ./ ./
# COPY --from=dvlp_repo --chown=dvl:dvl  ./dvlw/ ./home/dvl/dvlw/
# COPY --from=dvlp_repo ./ ./
# RUN chown -R god:r00t /root

WORKDIR /hel
USER devel

############
# dvlp_git #
############
FROM dvlp_skel AS dvlp_git
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
WORKDIR /hel
USER devel

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
USER god
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
RUN sudo chown -R dvl:dvl /hel || sudo chown -R dvl:dvl /hel/.local
USER devel
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=private \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user

####################
# dvlp_python-lite #
####################
FROM dvlp_git-lite AS dvlp_python-lite
WORKDIR / 
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /hel
USER devel

###############
# dvlp_python #
###############
FROM dvlp_git AS dvlp_python
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
USER devel

####################
# dvlp_msdot-build #
####################
FROM dvlp_msdot-build-lite AS dvlp_msdot-build
USER root
RUN sudo apt-get -y update && \
    sudo apt-get -y install dotnet-sdk-7.0 
USER devel

###################
# dvlp_msdot-lite #
###################
FROM dvlp_git-lite AS dvlp_msdot-lite
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
WORKDIR /hel
USER devel

##############
# dvlp_msdot #
##############
FROM dvlp_git-lite AS dvlp_msdot
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
USER devel

##################
# dvlp_dind-lite #
##################
FROM dvlp_git-lite AS dvlp_dind-lite
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
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
USER devel

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
USER devel

########################################################
###  dvlp_basic-wsl-kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_git AS dvlp_kernel-builder
ARG CONFIG_FILE=${CONFIG_FILE}
ARG KERNEL_TYPE=${KERNEL_TYPE:-basic-wsl}
WORKDIR /
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /hel
USER devel

########################################################
###  dvlp_basic-wsl-kernel-builder - KERNEL BUILDER  ###
########################################################
FROM dvlp_kernel-builder AS dvlp_kernel-make
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
USER devel

#################################### GUI ######################################
#################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_git-lite AS dvlp_gui-lite
USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
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
COPY --from=dvlp_repo --chown=god:r00t /dvlw/dvlp/mnt/opt/* /opt/

# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
USER devel

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
    sudo apt-get install -y xrdp xfce4 xfce4-godies && \
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
    sudo apt-get install -y lightdm
RUN \
    --mount=type=cache,target=/var/cache/debconf \
    # echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
    sudo apt-get install --no-install-recommends -y kubuntu-desktop
COPY --from=dvlp_repo --chown=god:r00t /dvlw/dvlp/mnt/etc/* /etc/

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
USER devel

#################
# dvlp_gui-plus #
#################
FROM dvlp_kernel-builder AS dvlp_gui-plus
ARG REFRESH_REPO=${REFRESH_REPO:-yes}
WORKDIR /
# COPY --from=dvlp_basic-wsl-kernel-builder ./ ./
COPY --from=dvlp_gui ./ ./
WORKDIR /hel
USER devel

############################## CUDA ###############################
#############
# dvlp_cuda #
#############
FROM dvlp_git AS dvlp_cuda
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
USER devel

##################
# dvlp_cuda-plus #
##################
FROM dvlp_git AS dvlp_cuda-plus
WORKDIR /
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_basic-wsl-kernel-builder ./ ./
COPY --from=dvlp_cuda ./ ./
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y install nvidia-cuda-toolkit
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


# docker buildx build --target=built-kernels --output type=local,dest=$(pwd)/out/ .
# docker buildx build -t dvlp_latest-rc-wsl-zfs-kernel-builder --output type=tar,dest=kubuntu22-plus-wsl-zfs-linux-kernel-6-28.tar  --build-arg CONFIG_FILE="https://raw.githubusercontent.com/kindtek/devels-playground/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0" .  2>&1 | tee latest-rc-wsl-zfs-kernel-builder-"$(date)".log
