# syntax=docker/dockerfile:experimental
# to build and run an individual service with args (ie git):
## `docker compose build git --build-arg fresh_repo=true && docker compose up git`
# to build everything:
## `docker compose build && docker compose up`
# to remove all volumes:
## docker compose down && docker volume rm $(docker volume ls -q)
ARG _CONFIG_FILE=${_CONFIG_FILE}
ARG DEBIAN_FRONTEND=noninteractive
ARG refresh_repo=${refresh_repo:-no}
ARG _AGL_USR=${_AGL_USR:-agl}
ARG _DVL_USR=${_DVL_USR:-dvl}

############################## BASE ####################################
#############
# dvlp_base #
#############
FROM ubuntu:latest AS dvlp_base
ARG _AGL_USR=${_AGL_USR:-agl}
ARG _DVL_USR=${_DVL_USR:-dvl}
ARG _HALO=halo
ARG _CONFIG_FILE
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    # sudo add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && \
    apt-get upgrade -y && \
    #   apt-get -y install sudo apt-fast
    addgroup --gid 4321 rootg && \
    addgroup --gid 777 halo && \
    addgroup --gid 666 hell && \
    # add just god and agl for now 
    adduser --home /home/god --ingroup root --shell /bin/bash --uid 4321 --disabled-password --gecos GECOS god && \
    adduser --home /home/agl --ingroup halo --shell /bin/bash --uid 777 --disabled-password --gecos GECOS agl && \
    adduser --home /home/dvl --ingroup hell --shell /bin/bash --uid 666 --disabled-password --gecos GECOS dvl && \
    # add god and agl to the sudo list
    usermod -aG rootg god && \
    # add god to both groups
    usermod -aG halo god && \
    usermod -aG hell god && \
    # ensure no passwords
    passwd -d god && \
    passwd -d agl && \
    passwd -d dvl && \
    passwd -l root && \
    # make dvl default wsl user 
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    usermod -aG sudo agl && \
    usermod -aG sudo god 
# god permissions/volume builder
FROM dvlp_base AS dvlp_base-god
USER root
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -fs /home/god /rootg
# && \
#     ln -sv /home/god/bak /mnt/data/bak 
# agl permissions/volume builder
FROM dvlp_base AS dvlp_base-angel
USER root
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -fs /home/agl /hal && \
    mkdir -m 753 -pv ${mnt_data}/bak/agl && \
    ln -sv ${mnt_data}/bak/agl /home/agl/bak

# dvl permissions/volume builder
FROM dvlp_base AS dvlp_base-devel
USER root
WORKDIR /home/dvl
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -sfv /home/dvl /home/dvl && \
    ln -sv dvlw devels-workshop && \
    ln -sv dvlw/dvlp dvlp && \
    ln -sv dvlw/dvlp/linux linux && \
    ln -sv dvlw/dvlp/docker/ubuntu dockeru && \
    ln -sv dvlw/dvlp/kernels/linux/x86/amd x64amd && \
    ln -sv dvlw/dvlp/kernels kernels && \
    ln -sv dvlw/dvlp/docker docker && \
    mkdir -m 753 -pv ${mnt_data}/bak/dvl && \
    ln -sv ${mnt_data}/bak/dvl /home/dvl/bak

USER dvl

# build aliases
# FROM dvlp_base-angel AS dvlp_auser

# FROM dvlp_base-devel AS dvlp_duser

################################### REPO ####################################
#############
# dvlp_repo #
#############
FROM dvlp_base AS dvlp_repo
ARG mnt_data=${mnt_data:-/mnt/data}
ARG refresh_repo=${refresh_repo:-no}
USER root
WORKDIR /
COPY --from=dvlp_base-devel --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_base-angel --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_base-god --chown=god:rootg ./home/god ./home/god
# COPY --from=dvlp_base-devel --chown=agl:halo .${mnt_data} .${mnt_data}
# COPY --from=dvlp_base-angel --chown=agl:halo .${mnt_data} .${mnt_data}
# copy skel files to dvl
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    apt-get -y update && apt-get -y upgrade && apt-get -y install git 
# USER dvl
WORKDIR /home/dvl
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
    git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw || (cd dvlw && git pull) 
    # (cd /tmp/git/cache/dvlw && git pull && cp -rv --remove-destination . /home/dvl/dvlw)
    # git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/dvl/dvlw
# RUN if [ $refresh_repo != no ]; then git pull; fi    
RUN \
    --mount=type=cache,target=/tmp/git/cache,sharing=locked \
    git submodule update --init --remote --depth=1 --progress || git pull \
    # (cd /tmp/git/cache/dvlw/dvlp && git pull && cp -rv --remove-destination . /home/dvl/dvlw/dvlp)
    chmod +x dvlp/mnt/home/ssh-keygen.sh && \
    chmod +x dvlp/mnt/home/start-kde.sh && \
    chmod -R +x dvlp/mnt/bak
# WORKDIR /home/dvl/dvlw/dvlp
# RUN if [ "$refresh_repo" != no ]; then git pull; fi    
USER dvl
WORKDIR /home/dvl

############################## SKELETON ###################################
###################
# dvlp_skel-build #
###################
FROM dvlp_base AS dvlp_skel-build
ARG refresh_repo=${refresh_repo:-no}
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /
# COPY --from=dvlp_repo --chown=dvl:hell ./home/dvl ./home/dvl
# COPY --from=dvlp_repo --chown=agl:halo ./home/agl ./home/agl
# COPY --from=dvlp_repo --chown=god:rootg ./home/god ./home/god
COPY --from=dvlp_repo --chown=dvl:hell ./home/dvl/dvlw/dvlp/mnt/home/ ./home/dvl/
COPY --from=dvlp_repo --chown=agl:halo ./home/dvl/dvlw/dvlp/mnt/home/ ./home/agl/
COPY --from=dvlp_repo --chown=god:rootg ./home/dvl/dvlw/dvlp/mnt/home/ ./home/god/
COPY --from=dvlp_base-devel --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_base-angel --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_base-god --chown=god:rootg ./home/god ./home/god
COPY --from=dvlp_base-devel --chown=agl:halo .${mnt_data} .${mnt_data}
COPY --from=dvlp_base-angel --chown=agl:halo .${mnt_data} .${mnt_data}
COPY --from=dvlp_repo --chown=god:halo /home/dvl/dvlw/dvlp/mnt/. .${mnt_data}
# COPY --from=dvlp_repo --chown=agl:halo .${mnt_data} .${mnt_data}



# USER root
# RUN chown -v agl:halo ${mnt_data}/bak/README_ASAP ${mnt_data}/bak/agl/backup-agl.sh
USER dvl
WORKDIR /home/dvl

#############
# dvlp_skel #
#############
FROM dvlp_skel-build AS dvlp_skel
ARG refresh_repo=${refresh_repo:-no}
# RUN with agl ownership
USER agl
# sudo mv -v ${mnt_data}/bak/custom ${mnt_data}/bak/agl/ && \
# make rwx for owner and rw for group - x/rx for others
# sudo chmod 754 -Rv ${mnt_data}/bak/agl && \
# sudo chmod 751 ${mnt_data}/bak/agl && \
# sudo chmod 751 ${mnt_data}/bak/agl && sudo chmod 751 ${mnt_data}/bak/dvl && \
# sudo chmod 754 -Rv ${mnt_data}/bak/dvl && \
# RUN \
#     --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
#     sudo apt-get -y update && \
    # sudo add-apt-repository ppa:saiarcot895/myppa && \
    # sudo apt-get -y install apt-fast aria2 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install apt-transport-https curl gh git gnupg2 libssl-dev nvi wget
WORKDIR /home/dvl
USER dvl

################################## BARE #########################################
############
# dvlp_bare #
############
FROM dvlp_base AS dvlp_bare
ARG refresh_repo=${refresh_repo:-yes}
WORKDIR /
WORKDIR /home/dvl
USER dvl

################################### GIT #########################################
#################
# dvlp_git_lite #
#################
FROM dvlp_base AS dvlp_git-lite
ARG refresh_repo=${refresh_repo:-yes}
WORKDIR /
COPY --from=dvlp_skel-build ./ ./
WORKDIR /home/dvl
USER dvl

############
# dvlp_git #
############
FROM dvlp_base AS dvlp_git
ARG fresh_repo=${fresh_repo:-no}
WORKDIR /
COPY --from=dvlp_skel ./ ./
WORKDIR /home/dvl
USER dvl

################################# PYTHON ########################################
#####################
# dvlp_python-build #
#####################
FROM dvlp_base AS dvlp_python-build
USER agl
RUN sudo apt-get -y install apt-utils libgirepository1.0-dev pkg-config python3-pip
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev  libpython3-dev pkg-config python3-pip python3-venv
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=locked \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps 
##########################
# dvlp_python-build-lite #
##########################
FROM dvlp_base AS dvlp_python-build-lite
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y install jq python3-pip python3-venv
WORKDIR /home/agl
USER agl
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=locked \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
WORKDIR /home/god
USER god
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=locked \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user
WORKDIR /home/dvl
USER dvl
RUN \
    --mount=type=cache,target=/var/cache/pip,sharing=locked \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    pip3 install cdir --user

####################
# dvlp_python-lite #
####################
FROM dvlp_git AS dvlp_python-lite
WORKDIR / 
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /home/dvl
USER dvl

###############
# dvlp_python #
###############
FROM dvlp_git AS dvlp_python
WORKDIR / 
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_python-build-lite ./ ./
WORKDIR /home/dvl
USER dvl

############################# POWERHELL #########################################
#########################
# dvlp_msdot-build-lite #
#########################
FROM dvlp_base AS dvlp_msdot-build-lite
USER root
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives \
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
WORKDIR /home/dvl
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
FROM dvlp_base AS dvlp_msdot-lite
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
WORKDIR /home/dvl
USER dvl

##############
# dvlp_msdot #
##############
FROM dvlp_base AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
WORKDIR /home/dvl
USER dvl

########################## DOCKER IN DOCKER ######################################
###################
# dvlp_dind-build #
###################
FROM dvlp_base AS dvlp_dind-build
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
WORKDIR /home/dvl
USER dvl

##################
# dvlp_dind-lite #
##################
FROM dvlp_base AS dvlp_dind-lite
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /home/dvl
USER dvl

#############
# dvlp_dind #
#############
FROM dvlp_base AS dvlp_dind
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
USER dvl

############################### KERNEL #########################################
#####################
# dvlp_kernel-build #
#####################
FROM dvlp_base AS dvlp_kernel-build
USER agl
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get -y install alien autoconf bison build-essential dbus-user-session daemonize dwarves \ 
    fakeroot flex fontconfig gawk libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev \
    python3-dev python3-setuptools python3-cffi net-tools snapd systemd-sysv sysvinit-utils uuid-dev
# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER agl
# RUN sudo apt-get clean all && \
#     sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

##############################################
###  dvlp_kernel-builder - KERNEL BUILDER  ###
##############################################
FROM dvlp_base AS dvlp_kernel-builder
ARG _CONFIG_FILE
# ARG _AGL
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-build ./ ./
USER god
WORKDIR /home/dvl/dvlw/dvlp/kernels/linux
SHELL ["/bin/bash", "-c"]
# RUN sudo ln -al && sudo chmod +x build-basic-wsl-kernel.sh
RUN sudo bash build-basic-wsl-kernel.sh ${_CONFIG_FILE} agl
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /home/dvl
USER dvl

##################################
# dvlp_kernel-lite - kernel only #
##################################
FROM dvlp_dind-lite AS dvlp_kernel-lite
WORKDIR /home/dvl
# COPY --from=dvlp_kernel-builder dvlw/dvlp/kernels kernels/
COPY --from=dvlp_kernel-builder linux-* ./
USER dvl

#################################### GUI ######################################
#################
# dvlp_gui-lite #
#################
# wsl2 required
FROM dvlp_base AS dvlp_gui-lite
USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ARG refresh_repo=${refresh_repo:-yes}
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build-lite ./ ./
COPY --from=dvlp_msdot-build-lite ./ ./
COPY --from=dvlp_dind-build ./ ./
WORKDIR /home/dvl
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl \
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get install -y brave-browser nautilus vlc x11-apps  
# change last line of this file - fix for brave-browser displaying empty windows
RUN sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null
# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
USER dvl
#
# dvlp_gui
#
# wsl2 required
FROM dvlp_gui-lite AS dvlp_gui
ARG refresh_repo=${refresh_repo:-yes}
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true
USER root
RUN sudo apt-get -y update && sudo apt-get -y upgrade && \
    update-locale LANGUAGE="C" && \
    update-locale LANG="C" && \
    update-locale LC_ALL="C" && \
    sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    sudo dpkg-reconfigure debconf -f noninteractive -p critical && \
    # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo debconf -f noninteractive -p critical xfce4 && \
    # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo debconf -f noninteractive -p critical kubuntu-desktop && \
    # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo debconf -f noninteractive -p critical xfce4 && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections 
# RUN sudo apt-get install -y locales && \
#     sudo dpkg-reconfigure --frontend noninteractive locales && \
#     echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager && \
#     sudo locale-gen && sudo update-locale 
RUN \
    --mount=type=cache,target=/var/cache/apt/archives \
    sudo apt-get -y update && sudo apt-get -y upgrade && \
    sudo apt-get install -y xrdp xfce4 xfce4-goodies && \
    # MUST install this separately and AFTER xfce or xfce prompting to choose default dm will hang/break build
    sudo apt-get install -y lightdm
RUN \
     --mount=type=cache,target=/var/cache/debconf \
    # echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
    sudo apt-get install --no-install-recommends -y kubuntu-desktop
COPY --from=dvlp_repo --chown=god:rootg /home/dvl/dvlw/dvlp/mnt/etc/* /etc/

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

#
# dvlp_gui-plus
#
FROM dvlp_kernel-builder AS dvlp_gui-plus
WORKDIR /
COPY --from=dvlp_kernel-builder ./ ./
COPY --from=dvlp_gui ./ ./
WORKDIR /home/dvl
USER dvl

############################## CUDA ###############################
#############
# dvlp_cuda #
#############
FROM dvlp_base AS dvlp_cuda
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
WORKDIR /home/dvl
USER dvl

##################
# dvlp_cuda-plus #
##################
FROM dvlp_base AS dvlp_cuda-plus
WORKDIR /
COPY --from=dvlp_skel ./ ./
COPY --from=dvlp_python-build ./ ./
COPY --from=dvlp_msdot-build ./ ./
COPY --from=dvlp_dind-build ./ ./
COPY --from=dvlp_kernel-builder ./ ./
COPY --from=dvlp_cuda ./ ./
RUN \
    --mount=type=cache,target=/var/cache/apt/archives,sharing=locked \
    sudo apt-get -y install nvidia-cuda-toolkit
WORKDIR /home/dvl
USER dvl

