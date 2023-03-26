# syntax=docker/dockerfile:experimental
# to build, run: 
# docker compose build   ( ... don't try docker run - permissions built with docker compose are needed )
ARG DEBIAN_FRONTEND=noninteractive

FROM ubuntu:latest AS dvlp_init
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
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    # sudo add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get -y install sudo
#   apt-get -y install sudo apt-fast
# non-root will need to use sudo from now on
RUN addgroup --gid 777 halo && \
    addgroup --gid 666 hell && \
    # add just god and agl for now 
    adduser --home /home/god --ingroup root --shell /bin/bash --uid 60000 --disabled-password --gecos GECOS god && \
    adduser --home /home/agl --ingroup halo --shell /bin/bash --uid 00777 --disabled-password --gecos GECOS agl && \
    adduser --home /home/dvl --ingroup hell --shell /bin/bash --uid 00666 --disabled-password --gecos GECOS dvl && \
    # add god and agl to the sudo list
    usermod -aG sudo god agl && \
    usermod -aG rootg god && \
    # add god to both groups
    usermod -aG halo god && \
    usermod -aG hell god && \
    # ensure no passwords
    passwd -d root god agl && \
    passwd -l root && \
    # add dvl    passwd -d dvl && \
    # make dvl default wsl user 
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf

# god permissions/volume builder
FROM dvlp_init AS dvlp_god
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -fs /home/god /rootg && \
    ln -s /mnt/data/bak /home/god/bak

# agl permissions/volume builder
FROM dvlp_init AS dvlp_agl
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -fs /home/agl /hal && \
    ln -s /mnt/data/bak/agl /home/agl/bak && \
    mkdir -m 753 -pv ${mnt_data}/bak/agl

# dvl permissions/volume builder
FROM dvlp_init AS dvlp_dvl
# ARG mnt_data=${mnt_data:-/mnt/data}
WORKDIR /home/dvl
RUN ln -sfv /home/dvl /hel && \
    ln -sv dvlw devels-workshop && \
    ln -sv dvlw/dvlp dvlp && \
    ln -sv dvlw/dvlp/linux linux && \
    ln -sv dvlw/dvlp/docker/ubuntu udocker && \
    ln -sv dvlw/dvlp/kernels/ubuntu/x86/amd u64amdkernels && \
    ln -sv dvlw/dvlp/kernels/ubuntu ukernels && \
    ln -sv dvlw/dvlp/docker docker && \
    ln -s /mnt/data/bak/dvl /home/dvl/bak && \
    mkdir -m 753 -pv ${mnt_data}/bak/dvl
USER dvl

# build aliases
# FROM dvlp_agl AS dvlp_auser

# FROM dvlp_dvl AS dvlp_duser

# DATA helper
FROM dvlp_init AS dvlp_data
ARG mnt_data=${mnt_data:-/mnt/data}
USER root
WORKDIR /
COPY --from=dvlp_dvl --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_agl --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_agl --chown=god:root ./home/god ./home/god
# copy skel files to dvl
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get -y install git
WORKDIR /home/dvl
# add safe directories
RUN \
    --mount=type=cache,target=/var/cache/git-dvlw \
    git config --global --add safe.directory /home/dvl && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/dvl/dvlp && \
    # clone fresh repos and give dvl ownership
    git clone https://github.com/kindtek/dvl-works --depth=1 --single-branch --progress dvlw
# RUN git clone https://github.com/kindtek/dvlw --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/dvl/dvlw
RUN \
    --mount=type=cache,target=/var/cache/git-dvlw/dvlp \
    git submodule update --init --remote --depth=1 --progress
WORKDIR /home/dvl
# && \
# if [ -d "${mnt_data}/bak/dvl" ]; then \
# if [ ! -fv "${mnt_data}/bak/dvl/backup-docker.sh" ]; then \
# echo "#!/bin/bash" > dvl/backup-docker.sh; \
# fi \
# fi && \
# # RUN if [ -d "${mnt_data}/bak/agl" ]; then \
# #         if [ ! -fv "${mnt_data}/bak/agl/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> agl/backup-docker.sh; \
# #         fi \
# #     fi \
# #     if [ -d "${mnt_data}/bak/agl" ]; then \
# #         if [ ! -fv "${mnt_data}/bak/agl/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> agl/backup-docker.sh; \
# #         fi \
# #     fi
# chown -Rv dvl:hell /home/dvl && chown -Rv agl:halo /home/agl
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/bak/agl/backup-docker.sh
# RUN sudo .${mnt_data}/bak/agl/backup-docker.sh
USER dvl

# SKELETON framework
FROM scratch AS dvlp_skel
ARG mnt_data=${mnt_data:-/mnt/data}
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_init --chown=root:root ./ ./
COPY --from=dvlp_dvl --chown=dvl:hell  ./home/dvl ./home/dvl 
COPY --from=dvlp_agl --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_agl --chown=agl:halo .${mnt_data} .${mnt_data}
COPY --from=dvlp_data --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_data --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_data --chown=god:root ./home/god ./home/god

WORKDIR /home/dvl
# RUN with halo ownership
USER agl
# RUN sudo chown agl:halo -Rv ${mnt_data}/bak/agl /home/agl  \
#     git config --global --add safe.directory /home/agl && \
#     git config --global --add safe.directory /halo 
RUN sudo apt-get -y update && \
    # sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    # sudo apt-get install -y tzdata && \
    # sudo dpkg-reconfigure --frontend noninteractive tzdata && \
    # sudo dpkg --configure -a && \
    # # sudo apt-get upgrade -y libsnmp40 && \
    sudo apt-get -y install apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget wslu && \
    # make gh files executable
    sudo chmod -R +x dvlw/dvlp/mnt/bak && \
    sudo chmod +x dvlw/scripts/gh-auth-first-time-login.sh && \
    # copy gh files to mount location and home dirs
    sudo cp -arfv dvlw/dvlp/mnt/bak ${mnt_data} && \
    sudo ls -al ${mnt_data} && \
    sudo mv -v ${mnt_data}/bak/custom ${mnt_data}/bak/agl/ && \
    # make rwx for owner and rw for group - x/rx for others
    # sudo chmod 754 -Rv ${mnt_data}/bak/agl && \
    # sudo chmod 751 ${mnt_data}/bak/agl && \
    # sudo chmod 751 ${mnt_data}/bak/agl && sudo chmod 751 ${mnt_data}/bak/dvl && \
    # sudo chmod 754 -Rv ${mnt_data}/bak/dvl && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *agl* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *agl* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/dvl/README_ASAP  && \
    sudo chown -v agl:halo ${mnt_data}/bak/README_ASAP ${mnt_data}/bak/agl/backup-agl.sh && \
    sudo chown agl:halo ${mnt_data}/bak/agl/backup-agl.sh ${mnt_data}/bak/dvl/backup-dvl.sh && \
    cat dvlw/dvlp/mnt/home/.bashrc | sudo tee --append /home/god/.bashrc /home/dvl/.bashrc /home/agl/.bashrc /etc/skel/.bashrc
USER root
# copy and set ownership
RUN cp -rfv dvlw/scripts/gh-auth-first-time-login.sh /home/dvl && \
    cp -rfv dvlw/scripts/gh-auth-first-time-login.sh /home/agl && \
    cp -rfv dvlw/scripts/gh-auth-first-time-login.sh /home/god
# chmod og+x /home/dvl/gh-auth-first-time-login.sh && chmod og+x /home/agl/gh-auth-first-time-login.sh && \
# chown dvl:hell /home/dvl/gh-auth-first-time-login.sh && chown agl:halo /home/agl/gh-auth-first-time-login.sh 
WORKDIR /home/dvl
USER dvl

# GIT
FROM dvlp_skel as dvlp_git
# these are the new home directories from now on
RUN usermod -d /hal agl && \
    usermod -d /hel dvl
# PYTHON stuff
FROM dvlp_init AS dvlp_python-lite
USER agl
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv
RUN --mount=type=cache,target=/var/cache/pip \pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps
RUN sudo cp -rfv /home/agl/.local/bin /usr/local && \
    sudo cp -rv /home/agl/.local /etc/skel/ /hel /rootg
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_git AS dvlp_python
WORKDIR / 
COPY --from=dvlp_python-lite ./ ./
WORKDIR /home/dvl
USER dvl

# MICROSOFT stuff
FROM dvlp_init AS dvlp_msdot-lite
USER agl
RUN sudo apt-get -y install lsb-release wget
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/wget \
    sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
RUN \
    --mount=type=cache,target=/var/cache/deb \
    sudo dpkg -i packages-microsoft-prod.deb
RUN sudo rm packages-microsoft-prod.deb 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && \
    sudo apt-get -y install powershell dotnet-sdk-7.0
# RUN sudo apt-get -y remove lsb_release
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_python AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_msdot-lite ./ ./
WORKDIR /home/dvl
USER dvl

# DOCKER IN DOCKER
FROM dvlp_init AS dvlp_dind-lite
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
# RUN \
# --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     sudo apt-get -y install lsb-release curl gpg
RUN sudo apt-get -y install lsb-release curl gpg
# sudo apt-get clean all && \
RUN sudo mkdir -pv /etc/apt/keyrings
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# RUN echo ', \
# "experimental": "enabled"' | sudo tee --append /home/dvl/.docker/config.json 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io 
# sudo apt-get remove -y lsb-release && \
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_msdot AS dvlp_dind
WORKDIR /
COPY --from=dvlp_dind-lite ./ ./
WORKDIR /home/dvl
USER dvl

FROM dvlp_dind AS dvlp_dind-plus
USER root
USER dvl

# KERNEL builder
FROM dvlp_init AS dvlp_kernel
USER agl
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y install alien autoconf bison build-essential  dbus-user-session daemonize dwarves \ 
    fakeroot flex fontconfig gawk libblkid-dev libffi-dev lxcfs libudev-dev libssl-dev libaio-dev libattr1-dev libelf-dev \
    python3 python3-dev python3-setuptools python3-cffi snapd sysvinit-utils uuid-dev
# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER agl
# RUN sudo apt-get clean all && \
#     sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

# Kernel only
FROM dvlp_dind-plus AS dvlp_kernel-plus
# ARG _CONFIG_FILE
# ARG _AGL
WORKDIR /
COPY --from=dvlp_kernel ./ ./
WORKDIR /home/dvl/dvlp/kernels/ubuntu
USER agl
SHELL ["/bin/bash", "-c"]
# RUN sudo ln -al && sudo chmod +x build-basic-wsl-kernel.sh
# RUN sudo bash build-basic-wsl-kernel.sh ${_CONFIG_FILE} agl
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /home/dvl
USER dvl

FROM dvlp_dind-lite AS dvlp_kernel-lite
ARG mnt_data=${mnt_data:-/mnt/data}
USER agl
WORKDIR /
COPY --from=dvlp_kernel-plus ./home/dvl/dvlw/dvlp/kernels ./home/dvl/dvlw/dvlp/kernels
# RUN sudo apt-get clean all && \
#     sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

# GUI - wsl2 required
FROM dvlp_init AS dvlp_gui
USER root
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_kernel-lite ./ ./
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl \
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install x11-apps xfce4
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install locales && sudo update-locale locales && \
    echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.gen && \
    sudo locale-gen
    
# RUN \
    # --mount=type=cache,target=/var/cache/apt,sharing=locked \
    # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo apt-get -y install lightdm gnome-session
# RUN \
    # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo dpkg-reconfigure lightdm
# RUN \
#     --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     sudo dpkg-reconfigure --frontend noninteractive locales && \
#     echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager 
# RUN echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
#     sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get install -y locales && sudo update-locale locales
    # in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
# in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -yq update&& \
    sudo apt-get -y install brave-browser
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install  gimp 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install gedit 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install nautilus 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install vlc 
RUN sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    # change last line of this file - fix for brave-browser displaying empty windows
    head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null
# # this is a better way to do this but needs work
# # cd /opt/brave.com/brave && \
# # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
# # sudo apt-get clean all && \
# # sudo apt-get autoremove --purge


WORKDIR /home/dvl
USER dvl

FROM dvlp_kernel-plus AS dvlp_gui-plus
WORKDIR /
COPY --from=dvlp_gui ./ ./
WORKDIR /home/dvl
USER dvl

# FROM dvlp_init AS dvlp_cuda
# USER agl
# # CUDA
# RUN \
# rm -f /etc/apt/apt.conf.d/docker-clean && \
#     echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
# RUN \
#     rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache \
#     --mount=type=cache,target=/var/cache/apt8 \
#     sudo apt-get -y install nvidia-cuda-toolkit 
# # sudo apt-get clean all && \
# # sudo apt-get autoremove --purge
# WORKDIR /home/dvl
# USER dvl

# FROM dvlp_gui-plus AS dvlp_cuda-plus
# WORKDIR /
# COPY --from=dvlp_cuda ./ ./
# WORKDIR /home/dvl
# USER dvl

