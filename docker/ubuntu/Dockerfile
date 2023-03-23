# to build, run: 
# `_GBL=mine _HALOS=ours docker run -d -i`
FROM ubuntu:latest AS dplay_init
ARG _GBL=${_GBL:-gbl}
ARG _HALOS=${_HALOS:-halos}
ARG mnt_data=${mnt_data:-/mnt/data}
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections && \
    addgroup --gid 777 ${_HALOS} && \
    addgroup --gid 666 horns && \
    adduser --home /home/${_GBL} --ingroup ${_HALOS} --shell /bin/bash --uid 1000 --disabled-password ${_GBL} && \
    adduser --system --home /home/host --ingroup ${_HALOS} --shell /bin/bash --uid 76667 --disabled-password host && \
    adduser --home /home/dvl --ingroup horns --shell /bin/bash --uid 666 --disabled-password dvl && \
    # ensure no passwords
    passwd -d ${_GBL} && \
    passwd -d dvl && \
    passwd -d host && \
    passwd -d root && \
    passwd -l root

# HAL permissions/volume builder
FROM dplay_init AS dplay_hal
USER root
# add dvl and host users using custom user setup
# add only _GBL to the sudo list
RUN usermod -aG ${_HALOS} host && \
    # usermod -aG horns ${_GBL} && \
    usermod -aG sudo ${_GBL} && \
    # chown -R ${_GBL}:${_HALOS} /home/${_GBL} \
    chown -R host:${_HALOS} /home/host && \
    chown -R ${_GBL}:${_HALOS} /home/${_GBL} && \
    apt-get update -yq && \
    apt-get upgrade -y && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    # add ${_GBL} to sudo group
    sudo adduser ${_GBL} sudo && \
    # uncomment to add sudo privileges for host
    # sudo adduser host sudo && \
    # set up /hal folder as symbolic link to /home/gbl 
    ln -s /home/${_GBL} /hal && \
    ln -s ${mnt_data}/${_GBL} /home/${_GBL}/bak && \
    chown -R ${_GBL}:${_HALOS} /hal && \
    # TODO: add a "readme" here
    touch /hal/o.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /hal/.ssh /hal/dls && chmod 700 /hal/.ssh && \
    chown -R ${_GBL}:${_HALOS} /hal/.ssh /hal/dls && \
    # make dvl default wsl user 
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf
# mount stuff if needed
# echo "//${mnt_data}/${_GBL} /home/${_GBL} cifs _GBL=${_GBL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/dvl /home/dvl cifs _GBL=dvl, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
# copy to skel and /hel, add common paths
USER ${_GBL}
ENV PATH="$PATH:/home/${_GBL}/.local/bin:/hel/devels-work/scripts:/home/dvl/devels-work/devels-play/scripts"
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/${_GBL}/.bashrc && \
    sudo cp -rfv /home/${_GBL}/. /etc/skel/ && \
    sudo rm /etc/skel/.sudo_as_admin_successful && \
    echo 'sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target \
    sleep 20 \
    exec sudo nsenter -t "$(pidof -s systemd)" -a su - $LOGNAME \
    echo "\"exec sudo nsenter -t \"$(pidof -s systemd)\" -a su - $LOGNAME\"' | sudo tee .bashrc
USER dvl

# HEL volume/permissions builder
FROM dplay_hal AS dplay_hel
USER root
# set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
RUN ln -s /home/dvl /hel && \
    chown -R dvl:horns /home/dvl && chown -R dvl:horns /hel  && \
    chown -R dvl:horns /hel  && \
    # add an instructional "readme" here later
    touch /hel/lo.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /hel/.ssh /hel/dls && chmod 700 /hel/.ssh && \
    # set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
    chown -R dvl:horns /hel/.ssh /hel/dls
# uncomment to add sudo priveleges for host / dvl
# sudo adduser dvl sudo && \
USER dvl
# add common paths
ENV PATH="$PATH:/home/dvl/.local/bin:/hel/devels-work/scripts:/home/dvl/devels-work/devels-play/scripts"
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/dvl/.bashrc

# DATA helper
FROM dplay_hel AS dplay_data
USER root
# copy skel files to dvl
RUN cp -rpv /etc/skel/. /home/dvl/ && chown -R dvl:horns /home/dvl && \
    apt-get -y install git
USER dvl
WORKDIR /home/dvl
# add safe directories
RUN git config --global --add safe.directory /home/dvl && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/dvl/devels-play && \
    # clone fresh repos and give dvl ownership
    git clone https://github.com/kindtek/devels-work --depth=1 --single-branch
# RUN git clone https://github.com/kindtek/devels-work --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/dvl/devels-work
RUN git pull && git submodule update --init --remote --depth=1
WORKDIR /home/dvl
# && \
# if [ -d "${mnt_data}/dvl" ]; then \
# if [ ! -fv "${mnt_data}/dvl/backup-docker.sh" ]; then \
# echo "#!/bin/bash" > dvl/backup-docker.sh; \
# fi \
# fi && \
# # RUN if [ -d "${mnt_data}/${_GBL}" ]; then \
# #         if [ ! -fv "${mnt_data}/${_GBL}/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> ${_GBL}/backup-docker.sh; \
# #         fi \
# #     fi \
# #     if [ -d "${mnt_data}/gbl" ]; then \
# #         if [ ! -fv "${mnt_data}/gbl/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> gbl/backup-docker.sh; \
# #         fi \
# #     fi
# chown -R dvl:horns /home/dvl && chown -R ${_GBL}:${_HALOS} /home/${_GBL}
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/gbl/backup-docker.sh
# RUN sudo .${mnt_data}/gbl/backup-docker.sh
USER dvl

# SKELETON framework
FROM dplay_data AS dplay_skel
# RUN with halos ownership
USER ${_GBL}
# RUN sudo chown ${_GBL}:${_HALOS} -R ${mnt_data}/${_GBL} /home/${_GBL}  \
#     git config --global --add safe.directory /home/gbl && \
#     git config --global --add safe.directory /hal 
RUN sudo apt-get -y update && \
    sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    sudo apt-get install -y tzdata && \
    sudo dpkg-reconfigure --frontend noninteractive tzdata && \
    sudo dpkg --configure -a && \
    # sudo apt-get upgrade -y libsnmp40 && \
    sudo apt-get -y install apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget wslu && \
    sudo chmod +x devels-work/devels-play/mnt/bak/gbl/backup-gbl.sh && \
    sudo mkdir -pv ${mnt_data}/${_GBL}/${_GBL}-orig && \
    sudo mkdir -pv ${mnt_data}/${_GBL}/dvl-orig && \
    sudo mkdir -pv ${mnt_data}/dvl && \
    sudo mkdir -pv ${mnt_data}/${_GBL}/dvl-orig && \
    sudo chown ${_GBL}:${_HALOS} -R ${mnt_data}/${_GBL} && \
    sudo chown dvl:horns -R ${mnt_data}/dvl && \
    sudo chown dvl:horns ${mnt_data}/${_GBL}/dvl-orig && \
    # copy newly pulled backup script to mount location and home dirs
    sudo cp -arfv devels-work/devels-play/mnt/bak/gbl/backup-gbl.sh ${mnt_data}/gbl/backup-gbl.sh && \
    sudo cp -arfv devels-work/devels-play/mnt/bak/custom/backup-custom.sh ${mnt_data}/${_GBL}/backup-${_GBL}.sh && \
    # sudo cp -arfv devels-work/devels-play/mnt/bak/backup-custom.sh ${mnt_data}/gbl/backup-gbl.sh && cp -arfv devels-work/devels-play/mnt/bak/backup-custom.sh /home/gbl/backup-gbl.sh && \
    # sudo cp -arfv devels-work/devels-play/mnt/dvl/bak/backup-dvl.sh ${mnt_data}/dvl/backup-dvl.sh && \
    # sudo cp -arfv devels-work/devels-play/mnt/dvl/bak/backup-dvl.sh ${mnt_data}/${_GBL}/backup-dvl.sh && \
    # sudo cp -arfv devels-work/devels-play/mnt/dvl/bak/backup-dvl.sh /home/dvl/backup-dvl.sh && \
    # copy contents in dplay/mnt/bak to mnt_data
    sudo cp -arfv devels-work/devels-play/mnt/bak/** ${mnt_data} && \
    # overwrite gbl if default username or create custom
    sudo mv -fv ${mnt_data}/custom ${mnt_data}/${_GBL} && \
    # make rwx for owner and rx for group - none for others
    sudo chmod 750 -R ${mnt_data}/${_GBL} && \
    sudo chmod 755 ${mnt_data}/${_GBL} && \
    sudo chmod 750 -R ${mnt_data}/dvl && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/README_ASAP      && \
    # echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/${_GBL}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/gbl/README_ASAP      && \
    sudo chown ${_GBL}:${_HALOS} ${mnt_data}/README_ASAP ${mnt_data}/${_GBL}/backup-${_GBL}.sh
# wait to do this until we have WSL_DISTRO_NAME
# sh ${mnt_data}/backup-dvl.sh
USER root
# set up basic utils
# install github, build-essentials, libssl, etc
RUN chown dvl:horns -R /home/dvl && chown ${_GBL}:${_HALOS} /home/gbl && \
    # # # For debug only
    # # # RUN sudo apt-get -y update && sudo apt-get -y install nvi curl git gh wget
    # # # RUN apt-get install -y lsb-release python3 python3-pip software-properties-common 
    # setup gh ssh login 
    sudo chmod +x devels-work/scripts/gh-auth-first-time-login.sh && \
    # make backup script executable
    sudo chmod ugo+x devels-work/devels-play/mnt/bak/gbl/backup-gbl.sh && \
    sudo chmod ugo+x devels-work/devels-play/mnt/bak/dvl/backup-dvl.sh && \
    sudo chmod ugo+x devels-work/devels-play/mnt/bak/custom/backup-custom.sh
USER dvl
# setup ssh gh login
# add symlinks for convenience
RUN ln -s devels-work dwork && ln -s devels-work/devels-play dplay && ln -s devels-play devels-work/dplay && \
    ln -s linux devels-work/devels-play/linux && \
    # ln -s ub devels-work/devels-play/docker/ubuntu && \
    # ln -s kernel devels-work/devels-play/kernel && \
    ln -s docker devels-work/devels-play/docker
# sh devels-work/scripts/gh-auth-first-time-login.sh

# GIT
FROM dplay_skel as dplay_git
WORKDIR /home/dvl
USER root
# copy and set ownership
RUN cp -rfv devels-work/scripts/gh-auth-first-time-login.sh /home/dvl && \
    cp -rfv devels-work/scripts/gh-auth-first-time-login.sh /home/${_GBL}  && \
    chmod og+x /home/dvl/gh-auth-first-time-login.sh && chmod og+x /home/${_GBL}/gh-auth-first-time-login.sh && \
    chown dvl:horns /home/dvl/gh-auth-first-time-login.sh && chown ${_GBL}:${_HALOS} /home/${_GBL}/gh-auth-first-time-login.sh 
USER dvl
WORKDIR /home/dvl/devels-work
WORKDIR /home/dvl
RUN sh gh-auth-first-time-login.sh dvl && \
    rm gh-auth-first-time-login.sh
USER ${_GBL}
WORKDIR /home/${_GBL}
RUN sh gh-auth-first-time-login.sh ${_GBL} && \
    rm gh-auth-first-time-login.sh
WORKDIR /home/dvl

# PYTHON stuff
FROM dplay_git AS dplay_python
USER ${_GBL}
RUN sudo apt-get -y install apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv && \
    pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    sudo cp -rfv /home/${_GBL}/.local/bin /usr/local && \
    sudo cp -afv /home/${_GBL}/.local /etc/skel/ &&  sudo rm /etc/skel/bak && \
    sudo rm /home/dvl/bak && sudo ln -s ${mnt_data}/dvl /home/dvl/bak && sudo chown -R dvl:horns /home/dvl/bak && \
    sudo cp -afv /home/${_GBL}/.local /home/dvl/ && sudo chown -R dvl:horns /home/dvl
USER dvl

# MICROSOFT stuff
FROM dplay_python AS dplay_msdot
USER ${_GBL}
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN sudo apt-get -y install lsb-release && \
    sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    #  && \
    ## Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt-get -y update && \
    sudo apt-get -y install powershell dotnet-sdk-7.0 && \
    sudo rm packages-microsoft-prod.deb
USER dvl

# DOCKER IN DOCKER
FROM dplay_msdot AS dplay_dind
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN sudo mkdir -pv /etc/apt/keyrings   && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io
USER dvl

# KERNEL builder
############################## DEFAULT MICROSOFT WSL 5_1519 KERNEL ######################################
FROM dplay_dind AS dplay_kernel-phat
USER root
RUN echo exit 0 > /usr/sbin/policy-rc.d && \
    sudo apt-get -y update && apt-get -y upgrade && \
    apt-get -y install alien autoconf automake bc bison build-essential dbus-user-session daemonize dwarves fakeroot flex fontconfig gawk gnupg libtooldkms libblkid-dev libffi-dev lxcfs libudev-dev libssl-dev \
    libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi snapd sysvinit-utils uuid-dev

# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER ${_GBL}
WORKDIR /home/${_GBL}/dls
RUN sudo apt install build-essential flex bison libssl-dev libelf-dev git dwarves && \
    git clone https://github.com/microsoft/WSL2-Linux-Kernel.git --progress --depth=1 --single-branch   && \
    mv -v WSL2-Linux-Kernel wsl2
WORKDIR /home/${_GBL}/dls/wsl2
RUN sudo cp -fv /home/dvl/devels-work/devels-play/kernel/5_1519/amd/.config_0 /home/${_GBL}/dls/wsl2/.config && \
    sudo chown ${_GBL}:${_HALOS} .config && \
    yes "" | sudo make -j $(expr $(nproc) - 1) && sudo make modules_install && \
    sudo mkdir -pv ../../../${_GBL}/kernels && sudo mkdir -pv ../../../dvl/kernels && \
    sudo cp -fv arch/x86/boot/bzImage ../../../${_GBL}/kernels/linux-kernel-5_1519_0a && \
    sudo cp -fv arch/x86/boot/bzImage ../../../dvl/kernels/linux-kernel-5_1519_0a && \
    sudo rm -rfv /hal/dls/*
WORKDIR /home/dvl
USER dvl

# Kernel only
FROM dplay_dind AS dplay_kernel
COPY --from=dplay_kernel-phat /home/gbl/kernels /home/gbl
COPY --from=dplay_kernel-phat /home/dvl/kernels /home/dvl

# GUI - wsl2 required
FROM dplay_kernel AS dplay_gui
USER ${_GBL}
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list && \ 
    # in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
    sudo apt-get -yq update && \
    sudo apt-get -y install brave-browser && \
    # now no longeer need to add --disable-gpu flag everytime
    cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    # change last line of this file - fix for brave-browser displaying empty windows
    head -n -1 /opt/brave.com/brave/brave-browser.old > /opt/brave.com/brave/brave-browser && \
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' >> /opt/brave.com/brave/brave-browser && \
    # this is a better way to do this but needs work
    # cd /opt/brave.com/brave && \
    # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
    # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
    # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
    sudo apt-get -y install x11-apps xfce4 && \
    sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -yq install gnome-session gdm3 gimp gedit nautilus vlc 
USER dvl

FROM dplay_gui AS dplay_gui-phat
COPY --from=dplay_kernel-phat ./ ./

FROM dplay_gui AS dplay_cuda
USER ${_GBL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER dvl

FROM dplay_gui-phat AS dplay_cuda-phat
USER ${_GBL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER dvl

