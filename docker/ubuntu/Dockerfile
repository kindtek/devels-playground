# to build, run: 
# `_GABRIEL=mine _HALOS=ours docker run -d -i`
FROM ubuntu:latest AS dplay_init
ARG _GABRIEL=${_GABRIEL:-gabriel}
ARG _HALOS=${_HALOS:-halos}
ARG mnt_data=${mnt_data:-/mnt/data}
RUN addgroup --gid 777 ${_HALOS} && \
    addgroup --gid 666 horns && \
    adduser --home /home/${_GABRIEL} --ingroup ${_HALOS} --shell /bin/bash --uid 777 --disabled-password ${_GABRIEL} && \
    adduser --system --home /home/host --ingroup ${_HALOS} --shell /bin/bash --uid 76667 --disabled-password host && \
    adduser --home /home/devel --ingroup horns --shell /bin/bash --uid 666 --disabled-password devel && \
    # ensure no passwords
    passwd -d ${_GABRIEL} && \
    passwd -d devel && \
    passwd -d host && \
    passwd -d root && \
    passwd -l root

# HAL permissions/volume builder
FROM dplay_init AS dplay_hal
USER root
# add devel and host users using custom user setup
# add only _GABRIEL to the sudo list
RUN usermod -aG ${_HALOS} host && \
    # usermod -aG horns ${_GABRIEL} && \
    usermod -aG sudo ${_GABRIEL} && \
    # chown -R ${_GABRIEL}:${_HALOS} /home/${_GABRIEL} \
    chown -R host:${_HALOS} /home/host && \
    chown -R ${_GABRIEL}:${_HALOS} /home/${_GABRIEL} && \
    apt-get update -yq && \
    apt-get upgrade -y && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    # add ${_GABRIEL} to sudo group
    sudo adduser ${_GABRIEL} sudo && \
    # uncomment to add sudo privileges for host
    # sudo adduser host sudo && \
    # set up /hal folder as symbolic link to /home/gabriel 
    ln -s /home/${_GABRIEL} /hal && \
    ln -s ${mnt_data}/devel /home/devel/bak && \
    ln -s ${mnt_data}/${_GABRIEL} /home/${_GABRIEL}/bak && \
    chown -R ${_GABRIEL}:${_HALOS} /hal && \
    # TODO: add a "readme" here
    touch /hal/o.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -p /hal/.ssh /hal/dls && chmod 700 /hal/.ssh && \
    chown -R ${_GABRIEL}:${_HALOS} /hal/.ssh && \
    # make devel default wsl user 
    echo "[user]\ndefault=devel" >> /etc/wsl.conf
# mount stuff if needed
# echo "//${mnt_data}/${_GABRIEL} /home/${_GABRIEL} cifs _GABRIEL=${_GABRIEL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/devel /home/devel cifs _GABRIEL=devel, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
# copy to skel and /hel, add common paths
USER ${_GABRIEL}
ENV PATH="$PATH:/home/${_GABRIEL}/.local/bin:/hel/devels-work/scripts:/home/devel/devels-work/devels-play/scripts"
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/${_GABRIEL}/.bashrc && \
    sudo cp -rf /home/${_GABRIEL}/. /etc/skel/ && \
    sudo rm /etc/skel/.sudo_as_admin_successful
USER devel

# HEL volume/permissions builder
FROM dplay_hal AS dplay_hel
USER root
# set up /devel folder as symbolic link to /home/devel for cloning repository(ies)
RUN ln -s /home/devel /hel && \
    chown -R devel:horns /home/devel && chown -R devel:horns /hel  && \
    chown -R devel:horns /hel  && \
    # add an instructional "readme" here later
    touch /hel/lo.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -p /hel/.ssh /hel/dls && chmod 700 /hel/.ssh && \
    # set up /devel folder as symbolic link to /home/devel for cloning repository(ies)
    chown -R devel:horns /hel/.ssh 
# uncomment to add sudo priveleges for host / devel
# sudo adduser devel sudo && \
USER devel
# add common paths
ENV PATH="$PATH:/home/devel/.local/bin:/home/devel/devels-work/devels-play/scripts"
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/devel/.bashrc

# DATA helper
FROM dplay_hel AS dplay_data
USER root
# copy skel files to devel
RUN cp -rp /etc/skel/. /home/devel/ && chown -R devel:horns /home/devel
RUN apt-get -y install git
USER devel
WORKDIR /home/devel
# add safe directories
RUN git config --global --add safe.directory /home/devel && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/devel/devels-play 
# clone fresh repos and give devel ownership
RUN git clone https://github.com/kindtek/devels-work 
# RUN git clone https://github.com/kindtek/devels-work --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/devel/devels-work
RUN git pull && git submodule update --init --remote 
WORKDIR /home/devel
# && \
# if [ -d "${mnt_data}/devel" ]; then \
# if [ ! -f "${mnt_data}/devel/backup-docker.sh" ]; then \
# echo "#!/bin/bash" > devel/backup-docker.sh; \
# fi \
# fi && \
# # RUN if [ -d "${mnt_data}/${_GABRIEL}" ]; then \
# #         if [ ! -f "${mnt_data}/${_GABRIEL}/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> ${_GABRIEL}/backup-docker.sh; \
# #         fi \
# #     fi \
# #     if [ -d "${mnt_data}/gabriel" ]; then \
# #         if [ ! -f "${mnt_data}/gabriel/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> gabriel/backup-docker.sh; \
# #         fi \
# #     fi
# chown -R devel:horns /home/devel && chown -R ${_GABRIEL}:${_HALOS} /home/${_GABRIEL}
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/gabriel/backup-docker.sh
# RUN sudo .${mnt_data}/gabriel/backup-docker.sh
USER devel

# SKELETON framework
FROM dplay_data AS dplay_skel
# RUN with halos ownership
USER ${_GABRIEL}
# RUN sudo chown ${_GABRIEL}:${_HALOS} -R ${mnt_data}/${_GABRIEL} /home/${_GABRIEL}  \
#     git config --global --add safe.directory /home/gabriel && \
#     git config --global --add safe.directory /hal
RUN sudo sh devels-work/scripts/gh-auth-first-time-login.sh ${_GABRIEL} && \
    # set up shared backup drive structure 
    sudo chmod +x devels-work/mnt/backup-gabriel.sh && \
    sudo mkdir -p ${mnt_data}/${_GABRIEL}/${_GABRIEL}-orig && \
    sudo mkdir -p ${mnt_data}/${_GABRIEL}/devel-orig && \
    sudo mkdir -p ${mnt_data}/devel && \
    sudo mkdir -p ${mnt_data}/${_GABRIEL}/devel-orig && \
    sudo chown ${_GABRIEL}:${_HALOS} -R ${mnt_data}/${_GABRIEL} && \
    sudo chown devel:horns -R ${mnt_data}/devel && \
    sudo chown devel:horns ${mnt_data}/${_GABRIEL}/devel-orig 
# copy newly pulled backup script to mount location and home dirs
RUN sudo cp -arf devels-work/mnt/backup-gabriel.sh ${mnt_data}/gabriel/backup-gabriel.sh && \
    sudo cp -arf devels-work/mnt/backup-custom.sh ${mnt_data}/${_GABRIEL}/backup-${_GABRIEL}.sh && \
    # sudo cp -arf devels-work/mnt/backup-custom.sh ${mnt_data}/gabriel/backup-gabriel.sh && cp -arf devels-work/mnt/backup-custom.sh /home/gabriel/backup-gabriel.sh && \
    sudo cp -arf devels-work/mnt/backup-devel.sh ${mnt_data}/devel/backup-devel.sh && \
    sudo cp -arf devels-work/mnt/backup-devel.sh ${mnt_data}/${_GABRIEL}/backup-devel.sh && \
    sudo cp -arf devels-work/mnt/backup-devel.sh /home/devel/backup-devel.sh && \
    # make rwx for owner and rx for group - none for others
    sudo chmod 750 -R ${mnt_data}/${_GABRIEL} && \
    sudo chmod 755 ${mnt_data}/${_GABRIEL} && \
    sudo chmod 750 -R ${mnt_data}/devel && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/README_ASAP      && \
    # echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/${_GABRIEL}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/gabriel/README_ASAP      && \
    sudo chown ${_GABRIEL}:${_HALOS} ${mnt_data}/README_ASAP ${mnt_data}/${_GABRIEL}/backup-${_GABRIEL}.sh
# wait to do this until we have WSL_DISTRO_NAME
# sh ${mnt_data}/backup-devel.sh
USER root
# set up basic utils
# install github, build-essentials, libssl, etc
RUN chown devel:horns -R /home/devel && chown ${_GABRIEL}:${_HALOS} /home/gabriel && \
    # # # For debug only
    # # # RUN sudo apt-get -y update && sudo apt-get -y install nvi curl git gh wget
    # # # RUN apt-get install -y lsb-release python3 python3-pip software-properties-common 
    # setup gh ssh login 
    sudo chmod +x devels-work/scripts/gh-auth-first-time-login.sh && \
    # make backup script executable
    sudo chmod ugo+x devels-work/mnt/backup-gabriel.sh && \
    sudo chmod ugo+x devels-work/mnt/backup-devel.sh && \
    sudo chmod ugo+x devels-work/mnt/backup-custom.sh
RUN sudo apt-get -y update && sudo apt-get -y install apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget

USER devel
# setup ssh gh login
RUN sh devels-work/scripts/gh-auth-first-time-login.sh && \
    # add symlinks for convenience
    ln -s devels-work dwork && ln -s devels-work/devels-play dplay && \
    ln -s linux devels-work/devels-play/linux && \
    ln -s docker devels-work/devels-play/docker && \
    ln -s devels-work/devels-play/docker/ub devels-work/devels-play/docker/ubuntu


# GIT
FROM dplay_skel as dplay_git

# PYTHON stuff
FROM dplay_git as dplay_python
USER ${_GABRIEL}
RUN sudo apt-get -y install jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv && \
    pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    sudo cp -rf /home/${_GABRIEL}/.local/bin /usr/local && \
    sudo cp -rf /home/${_GABRIEL}/.local /etc/skel/ &&  sudo rm /etc/skel/bak && \
    sudo cp -r /home/${_GABRIEL}/.local /home/devel/ && sudo chown -R devel:horns /home/devel
USER devel

# MICROSOFT stuff
FROM dplay_python as dplay_msdot
USER ${_GABRIEL}
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN sudo apt-get -y install lsb-release 
RUN sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
#  && \
## Register the Microsoft repository GPG keys
RUN sudo dpkg -i packages-microsoft-prod.deb 
RUN sudo apt-get -y update
RUN sudo apt-get -y install powershell dotnet-sdk-7.0
RUN sudo rm packages-microsoft-prod.deb
USER devel

# DOCKER IN DOCKER
FROM dplay_msdot as dplay_dind
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN sudo mkdir -p /etc/apt/keyrings   && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io
USER devel

# KERNEL builder
FROM dplay_dind as dplay_kernel
USER root
RUN echo exit 0 > /usr/sbin/policy-rc.d
#    && \
RUN sudo apt-get -y update && apt-get -y upgrade
# RUN  
# RUN DEBIAN_FRONTEND=noninteractive apt-get -y install 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade libldap-common libldap-2.5-0 dpkg
##########################################################################################
# RUN DEBIAN_FRONTEND=noninteractive RUN apt-get -y install zfs-utils 
# RUN yes $'23\n' | apt-get -y install --force-yes zfs-dracut >/dev/null 2>&1 
#  
RUN export DEBIAN_FRONTEND="noninteractive" && apt-get -y install gnupg apt-utils build-essential autoconf automake libtool gawk alien fakeroot dkms libblkid-dev uuid-dev libudev-dev libssl-dev \
    sysvinit-utils libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi libffi-dev flex bison snapd daemonize 
RUN apt-get update -y && apt-get -y upgrade
# 
# make this work eventually...
# 
# 
# #  && \
# RUN sudo apt-get -y update && sudo apt-get -y upgrade
# RUN sudo apt-get -y install zfsutils-linux 
# RUN sudo apt-get -y install zfsutils zlib1g-dev 
# RUN sudo apt-get -y update && sudo apt-get -y upgrade
#     #  && \
# RUN sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
# RUN exec sudo nsenter -t $(`echo pidof bash`) -a su - $LOGNAME
# RUN sudo systemctl unmask snapd.service && sudo systemctl enable snapd.service && sudo systemctl start snapd.service && \
#     sudo snap install lxd -y && sudo lxd init 
# RUN sudo systemctl unmask lxcfs.service && sudo systemctl enable lxcfs.service && sudo systemctl start lxcfs.service
# #  && \
# RUN  sudo systemctl enable snapd.service && sudo systemctl start snapd.service
# RUN  sudo systemctl enable snapd.service && sudo systemctl stop snapd.service
# #  && \
# WORKDIR $PATH/devels-work/devels-play/linux
# RUN echo -e "pwd:$PWD\n"sudo cp -f .config.new .config 
#     # && \
# RUN sudo make prepare scripts
# # && \
#  RUN cd ../zfs && sudo sh autogen.sh && \
#     sudo sh configure --prefix=/ --libdir=/lib --includedir=/usr/include --datarootdir=/usr/share --enable-linux-builtin=yes --with-linux=../linux --with-linux-obj=../linux && \
#     sudo sh copy-builtin ../linux
# RUN sudo make install && \
#     cd ../linux && sudo sed -i 's/# CONFIG_ZFS is not set/CONFIG_ZFS=y/g' .config && echo grep ZFS .config && \
#     sudo make && sudo make modules_install && sudo mkdir -p ../../../gabriel/kernels && sudo cp arch/x86/boot/bzImage ../../../gabriel/kernels/linux-kernel-626a5 && \
#     sudo cp arch/x86/boot/bzImage ../../mnt/linux-kernel-626a6
# && \
# # sudo make -j16 && sudo make modules_install
USER devel

# GUI - wsl2 required
FROM dplay_dind as dplay_gui
USER ${_GABRIEL}
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
RUN    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list 
# in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
RUN    sudo apt-get -yq update
RUN    sudo apt-get -y install brave-browser
# now no longeer need to add --disable-gpu flag everytime
# cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
# # change last line of this file - fix for brave-browser displaying empty windows
# head -n -1 /opt/brave.com/brave/brave-browser.old > /opt/brave.com/brave/brave-browser && \
# echo '"$HERE/brave" "$@" " --disable-gpu " || true' >> /opt/brave.com/brave/brave-browser && \
RUN cd /opt/brave.com/brave && \
    brave_old_line='"\$HERE/brave"\s"\$@"\s\|\|\strue"' && \
    brave_new_line='\"\$HERE/brave\" \"\$@\" \" --disable-gpu \ || true' && \
    sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/devel
RUN sudo apt-get -y install x11-apps xfce4
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -yq install gnome-session gdm3 gimp gedit nautilus vlc 
USER devel

FROM dplay_gui as dplay_cuda
USER ${_GABRIEL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER devel

