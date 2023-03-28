# syntax=docker/dockerfile:experimental
# to build, run: 
# docker compose build   ( ... don't try docker run - permissions built with docker compose are needed )
ARG DEBIAN_FRONTEND=noninteractive

############################## BASE ####################################
#
# dvlp_base
#
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
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    # sudo add-apt-repository ppa:apt-fast/stable && \
    apt-get update -y && \
    apt-get upgrade -y && \
    # non-root will need to use sudo from now on
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
    apt-get -y install sudo && \
    usermod -aG sudo agl && \
    usermod -aG sudo  god  && \
    rm -rf /var/cache/apt/archives/*.deb

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
    ln -sv /mnt/data/bak/agl /home/agl/bak

# dvl permissions/volume builder
FROM dvlp_base AS dvlp_base-devel
USER root
WORKDIR /home/dvl
ARG mnt_data=${mnt_data:-/mnt/data}
RUN ln -sfv /home/dvl /hel && \
    ln -sv dvlw devels-workshop && \
    ln -sv dvlw/dvlp dvlp && \
    ln -sv dvlw/dvlp/linux linux && \
    ln -sv dvlw/dvlp/docker/ubuntu udocker && \
    ln -sv dvlw/dvlp/kernels/ubuntu/x86/amd u64amdkernels && \
    ln -sv dvlw/dvlp/kernels/ubuntu ukernels && \
    ln -sv dvlw/dvlp/docker docker && \
    mkdir -m 753 -pv ${mnt_data}/bak/dvl && \
    ln -sv ${mnt_data}/bak/dvl /home/dvl/bak

USER dvl

# build aliases
# FROM dvlp_base-angel AS dvlp_auser

# FROM dvlp_base-devel AS dvlp_duser

################################### DATA ####################################
#
# dvlp_data
#
FROM dvlp_base AS dvlp_data
ARG mnt_data=${mnt_data:-/mnt/data}
USER root
WORKDIR /
COPY --from=dvlp_base-devel --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_base-angel --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_base-god --chown=god:rootg ./home/god ./home/god
COPY --from=dvlp_base-devel --chown=agl:halo .${mnt_data} .${mnt_data}
COPY --from=dvlp_base-angel --chown=agl:halo .${mnt_data} .${mnt_data}
# copy skel files to dvl
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    # --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get -y install git
USER dvl
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
    git submodule update --init --remote --depth=1 --progress && \
    chmod +x dvlp/mnt/home/gh-auth-first-time-login.sh && \
    chmod -R +x dvlp/mnt/bak
USER root
RUN cat dvlp/mnt/home/.bashrc | sudo tee --append /home/god/.bashrc /home/dvl/.bashrc /home/agl/.bashrc /etc/skel/.bashrc && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *agl* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/README_ASAP && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *agl* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/dvl/README_ASAP 
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
WORKDIR /home/dvl

# SKELETON framework
#
# dvlp_skel-build
#
FROM dvlp_base AS dvlp_skel-build
ENV DEBIAN_FRONTEND=noninteractive
ARG mnt_data=${mnt_data:-/mnt/data}
COPY --from=dvlp_data --chown=dvl:hell ./home/dvl ./home/dvl
COPY --from=dvlp_data --chown=agl:halo ./home/agl ./home/agl
COPY --from=dvlp_data --chown=god:rootg ./home/god ./home/god
COPY --from=dvlp_data --chown=agl:halo .${mnt_data} .${mnt_data}
COPY --from=dvlp_data /home/dvl/dvlw/dvlp/mnt/. .${mnt_data}
COPY --from=dvlp_data /home/dvl/dvlw/dvlp/mnt/home/gh-auth-first-time-login.sh /home/dvl/gh-auth-first-time-login.sh
COPY --from=dvlp_data /home/dvl/dvlw/dvlp/mnt/home/gh-auth-first-time-login.sh /home/agl/gh-auth-first-time-login.sh
COPY --from=dvlp_data /home/dvl/dvlw/dvlp/mnt/home/gh-auth-first-time-login.sh /home/god/gh-auth-first-time-login.sh
USER root
RUN chown -v agl:halo ${mnt_data}/bak/README_ASAP ${mnt_data}/bak/agl/backup-agl.sh
USER dvl
WORKDIR /home/dvl

#
# dvlp_skel
# 
FROM dvlp_skel-build AS dvlp_skel
# RUN with agl ownership
USER agl
# sudo mv -v ${mnt_data}/bak/custom ${mnt_data}/bak/agl/ && \
# make rwx for owner and rw for group - x/rx for others
# sudo chmod 754 -Rv ${mnt_data}/bak/agl && \
# sudo chmod 751 ${mnt_data}/bak/agl && \
# sudo chmod 751 ${mnt_data}/bak/agl && sudo chmod 751 ${mnt_data}/bak/dvl && \
# sudo chmod 754 -Rv ${mnt_data}/bak/dvl && \
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && \
    # sudo add-apt-repository ppa:saiarcot895/myppa && \
    # sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    # sudo apt-get install -y tzdata && \
    # sudo dpkg-reconfigure --frontend noninteractive tzdata && \
    # sudo dpkg --configure -a && \
    # # sudo apt-get upgrade -y libsnmp40 && \
    # sudo apt-get -y install apt-fast aria2 
    sudo apt-get -y install apt-transport-https gh wget
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    sudo apt-get -y install curl
# cant cache these ..
RUN sudo apt-get -y install build-essential ca-certificates git gnupg2 libssl-dev nvi wslu

WORKDIR /home/dvl
USER dvl

# GIT
FROM dvlp_base AS dvlp_git
WORKDIR /
COPY --from=dvlp_skel ./ ./
USER agl
RUN sudo rm -rf /var/cache/apt/archives/
USER dvl

################################# PYTHON ########################################
#
# dvlp_python-build
#
FROM dvlp_base AS dvlp_python-build
USER agl
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv
USER dvl
RUN pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps
RUN pip3 install cdir --user
USER god
RUN rm -rf /cache/apt/archives/
RUN pip3 install cdir --user
USER dvl
RUN pip3 install cdir --user
# sudo apt-get autoremove --purge
WORKDIR /hel

#
# dvlp_python
#
FROM dvlp_git AS dvlp_python
WORKDIR / 
COPY --from=dvlp_python-build ./ ./
USER agl
RUN sudo rm -rf /var/cache/apt/archives/
# RUN \
#     --mount=type=cache,target=/var/cache/pip \
#     pip3 install cdir --user
WORKDIR /hel

############################# POWERHELL #########################################
#
# dvlp_msdot-build
#
FROM dvlp_base AS dvlp_msdot-build
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
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && \
    sudo apt-get -y install powershell dotnet-sdk-7.0 
RUN sudo rm packages-microsoft-prod.deb
# RUN sudo apt-get -y remove lsb_release
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

FROM dvlp_python AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_msdot-build ./ ./
USER agl
RUN sudo rm -rf /var/cache/apt/archives/
WORKDIR /hel
USER dvl

########################## DOCKER IN DOCKER ######################################
#
# dvlp_dind-build
#
FROM dvlp_base AS dvlp_dind-build
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    sudo apt-get -y install curl
RUN sudo apt-get -y install lsb-release gpg
# sudo apt-get clean all && \
RUN sudo mkdir -pv /etc/apt/keyrings
RUN \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io 
# sudo apt-get remove -y lsb-release && \
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

#
# dvlp_dind
#
FROM dvlp_msdot AS dvlp_dind
WORKDIR /
COPY --from=dvlp_dind-build ./ ./
USER agl
RUN sudo rm -rf /var/cache/apt/archives/
WORKDIR /hel
USER dvl

FROM dvlp_dind AS dvlp_dind-plus
USER root
USER dvl

#
# KERNEL
#
FROM dvlp_base AS dvlp_kernel-build
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
WORKDIR /hel
USER dvl

############################### KERNEL #########################################
#
# dvlp_kernel-builder - KERNEL BUILDER
#
FROM dvlp_dind AS dvlp_kernel-builder
ARG _CONFIG_FILE
# ARG _AGL
WORKDIR /
COPY --from=dvlp_kernel-build ./ ./
WORKDIR /hel/dvlp/kernels/ubuntu
USER god
RUN sudo rm -rf /var/cache/apt/archives/
SHELL ["/bin/bash", "-c"]
# RUN sudo ln -al && sudo chmod +x build-basic-wsl-kernel.sh
# RUN sudo bash build-basic-wsl-kernel.sh ${_CONFIG_FILE} agl
RUN cpu_vendor=$(grep -Pom 1 '^vendor_id\s*:\s*\K.*' /proc/cpuinfo); \
    user_name=dvl; \
    cpu_arch=$(uname -m); \
    cpu_arch="${cpu_arch%%_*}"; \
    if ! [ -d /home/$user_name ]; then $user_name=/home/dvl; fi; \
    if [ $cpu_vendor = AuthenticAMD ]; then cpu_vendor=amd; fi; \
    if [ $cpu_vendor = GenuineIntel ]; then cpu_vendor=intel; fi; \
    linux_version_name="5.15.90.1"; \
    # replace first . with _ and then remove the rest of the .s
    linux_version_mask=${linux_version_name/\./\_}; \
    linux_version_mask=${linux_version_mask//[\.-]/}; \
    linux_mask=linux-$linux_version_mask; \
    save_name=linux-$linux_version_mask\_w0; \
    save_location1=/home/dvl/dvlw/dvlp/kernels/ubuntu/$cpu_arch/$cpu_vendor/$linux_version_mask/$save_name; \
    save_location2=/home/$user_name/$save_name; \
    # try to pick the best .config file and default to the one provided by microsoft
    config_file_default=$cpu_arch/$cpu_vendor/$linux_version_mask/.config_wsl0; \
    if ! [ -f $config_file_default ]; then config_file_default=/home/dvl/dvlw/dvlp/kernels/ubuntu/$cpu_arch/generic/$linux_version_mask/.config_wsl0; fi; \
    if ! [ -f $config_file_default ]; then config_file_default=wsl2/Microsoft/config-wsl; fi; \
    if ! [ -f ${config_file} ]; then cp -fv $config_file_default wsl2/.config; config_file=$config_file_default; else cp -fv ${config_file} wsl2/.config; fi; \
    config_file=${_CONFIG_FILE:-$config_file_default}; \
    printf '\n======= Kernel Build Info =========================================================================\n\n\tCPU Architecture:\t%s\n\n\tCPU Vendor:\t\t%s\n\n\tConfiguration File:\n\t\t%s\n\n\tSave Locations:\n\t\t%s\n\t\t%s\n\n===================================================================================================\n' $cpu_arch $cpu_vendor $config_file $save_location1 $save_location2; \
    git clone https://github.com/microsoft/WSL2-Linux-Kernel.git --progress --depth=1 --single-branch --branch linux-msft-wsl-5.15.90.1; \
    mv -uv WSL2-Linux-Kernel wsl2; \
    cd wsl2; \
    yes "" | make oldconfig && yes "" | make prepare; \
    yes "" | make -j $(expr $(nproc) - 1); \
    make modules_install ; \
    mkdir -pv /home/$user_name/kernels; \
    mkdir -pv ../$cpu_arch/$cpu_vendor/$save_name; \
    cp -fv --backup=numbered arch/x86/boot/bzImage /home/$user_name/$save_name; \
    cp -fv --backup=numbered arch/x86/boot/bzImage /home/dvl/$save_name; \
    cp -fv --backup=numbered arch/x86/boot/bzImage kernels/ubuntu/$cpu_arch/$cpu_vendor/$linux_version_mask/$save_name ; \
    cp -fv --backup=numbered .config kernels/ubuntu/$cpu_arch/$cpu_vendor/$linux_version_mask/.config_wsl0; \
    rm -rf wsl2;
# RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/agl/.bashrc
WORKDIR /hel
USER dvl

#
# dvlp_kernel-lite - kernel only
#
FROM dvlp_dind AS dvlp_kernel-lite
USER agl
WORKDIR /
RUN sudo rm -rf /var/cache/apt/archives/
COPY --from=dvlp_kernel-builder ./hel/dvlw/dvlp/kernels ./hel/dvlw/dvlp/kernels
# RUN sudo apt-get clean all && \
#     sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

#################################### GUI ######################################
#
# dvlp_gui 
#
# wsl2 required
FROM dvlp_base AS dvlp_gui
USER root
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=dvlp_kernel-build ./ ./
WORKDIR /hel
RUN \
    --mount=type=cache,target=/var/cache/curl,sharing=locked \
    sudo apt-get -y install curl
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
    sudo apt-get update && \
    sudo apt-get install -y locales  
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y brave-browser
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y locales
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y  gimp  
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y gedit 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y nautilus  
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y vlc 
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y x11-apps  
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get update && \
    sudo apt-get install -y xfce4
# RUN \
#     --mount=type=cache,target=/var/cache/apt,sharing=locked \
#     sudo apt-get install -y xfce4
    # sudo apt-get install -y locales brave-browser gimp gedit nautilus vlc x11-apps xfce4
RUN sudo update-locale && \
    echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.gen && \
    sudo locale-gen && \
    sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    # change last line of this file - fix for brave-browser displaying empty windows
    head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null
# # # this is a better way to do this but needs work
# # # cd /opt/brave.com/brave && \
# # # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
# # # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
# # # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
# # # sudo apt-get clean all && \
# # # sudo apt-get autoremove --purge
# # stuff to try to make gimp install without interaction
# # RUN \
# # --mount=type=cache,target=/var/cache/apt,sharing=locked \
# # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo apt-get -y install lightdm gnome-session
# # RUN \
# # sudo DEBIAN_FRONTEND=noninteractive sudo DEBCONF_NONINTERACTIVE_SEEN=true sudo dpkg-reconfigure lightdm
# # RUN \
# #     --mount=type=cache,target=/var/cache/apt,sharing=locked \
# #     sudo dpkg-reconfigure --frontend noninteractive locales && \
# #     echo "/usr/sbin/lightdm" | sudo tee /etc/X11/default-display-manager 
# # RUN echo "set shared/default-x-display-manager lightdm" | sudo debconf-communicate && \
# #     sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
USER dvl

#
# dvlp_gui-plus
#
FROM dvlp_kernel-builder AS dvlp_gui-plus
WORKDIR /
USER agl
COPY --from=dvlp_gui ./ ./
RUN sudo rm -rf /var/cache/apt/archives/
WORKDIR /hel
USER dvl

############################## CUDA ###############################
#
# dvlp_cuda
#
FROM dvlp_base AS dvlp_cuda
USER agl
RUN \
    sudo rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | sudo tee --append /etc/apt/apt.conf.d/keep-cache
RUN \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    sudo apt-get -y install nvidia-cuda-toolkit
# sudo apt-get clean all && \
# sudo apt-get autoremove --purge
WORKDIR /hel
USER dvl

#
# dvlp_gui-plus
#
FROM dvlp_gui-plus AS dvlp_cuda-plus
WORKDIR /
USER agl
COPY --from=dvlp_cuda ./ ./
RUN sudo rm -rf /var/cache/apt/archives/
WORKDIR /hel
USER dvl

