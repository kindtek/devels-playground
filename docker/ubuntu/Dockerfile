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

FROM dplay_init AS dplay_halo

# switch back to root to setup
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
    # uncomment to add sudo priveleges for host
    # sudo adduser host sudo && \
    # set up /halo folder as symbolic link to /home/gabriel 
    ln -s /home/${_GABRIEL} /halo && chown -R ${_GABRIEL}:${_HALOS} /halo && \
    # add a "readme" here later
    touch /halo/.world && \
    mkdir -p /halo/.ssh && chmod 700 /halo/.ssh && chown -R ${_GABRIEL}:${_HALOS} /halo/.ssh && \
    # make devel default wsl user 
    echo "[user]\ndefault=devel" >> /etc/wsl.conf
# mount stuff
# echo "//${mnt_data}/${_GABRIEL} /home/${_GABRIEL} cifs _GABRIEL=${_GABRIEL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/devel /home/devel cifs _GABRIEL=devel, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
# copy to skel and /hel

# add common paths
USER ${_GABRIEL}
ENV PATH=$PATH:/home/${_GABRIEL}/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/${_GABRIEL}/.bashrc && \
    sudo cp -rf /home/${_GABRIEL}/. /etc/skel/ && \
    sudo cp -rf /home/${_GABRIEL}/. /home/devel/ 

# backup location or optionally a mount partition
# partition letter set up for n:/ - use this guide to set up partition https://allthings.how/how-to-partition-a-hard-drive-on-windows-11/

FROM dplay_halo AS dplay_hel

USER root
# set up /devel folder as symbolic link to /home/devel for cloning repository(ies)
RUN ln -s /home/devel /hel && chown -R devel:horns /home/devel && chown -R devel:horns /hel  && \
    # add an instructional "readme" here later
    touch /hel/lo.world && \
    # make sure .ssh has proper permissions
    mkdir -p /home/devel/.ssh && chown -R devel:horns /home/devel/.ssh && chmod 700 /home/devel/.ssh
# uncomment to add sudo priveleges for host / devel
# sudo adduser devel sudo && \

USER devel

# add common paths
ENV PATH=$PATH:/home/devel/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts
RUN echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${mnt_data}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> /home/devel/.bashrc


FROM dplay_hel AS dplay_data

USER root

RUN cp -rp /etc/skel/. /home/devel/ && \
    if [ -d "${mnt_data}/devel" ]; then \
    if [ ! -f "${mnt_data}/devel/backup-docker.sh" ]; then \
    echo "#!/bin/bash" > devel/backup-docker.sh; \
    fi \
    fi && \
    # RUN if [ -d "${mnt_data}/${_GABRIEL}" ]; then \
    #         if [ ! -f "${mnt_data}/${_GABRIEL}/backup-docker.sh" ]; then \
    #             echo "#!/bin/bash" >> ${_GABRIEL}/backup-docker.sh; \
    #         fi \
    #     fi \
    #     if [ -d "${mnt_data}/gabriel" ]; then \
    #         if [ ! -f "${mnt_data}/gabriel/backup-docker.sh" ]; then \
    #             echo "#!/bin/bash" >> gabriel/backup-docker.sh; \
    #         fi \
    #     fi
    chown -R devel:horns /home/devel && chown -R ${_GABRIEL}:${_HALOS} /home/${_GABRIEL}


# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/gabriel/backup-docker.sh
# RUN sudo .${mnt_data}/gabriel/backup-docker.sh


FROM dplay_data AS dplay_skel
# set up basic utils
# install github, build-essentials, libssl, etc
# apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip nvi apt-transport-https software-properties-common 
RUN apt-get install -y apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget
# apt-get install -y apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg libssl-dev lsb-release nvi software-properties-common wget && \
# set up group/user 
# addgroup --system --gid 1001 ${_HALOS} && \
# adduser --system --home /home/${_GABRIEL} --shell /bin/bash --uid 1001 --gid 1001 --disabled-password ${_GABRIEL} 

FROM dplay_skel AS dplay_git
WORKDIR /home/devel
USER devel

# add safe directories
RUN git config --global --add safe.directory /home/devel && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/devel/devels-playground && \
    # clone fresh repos and give devel ownership
    git clone https://github.com/kindtek/devels-workshop && \
    cd devels-workshop && git pull && git submodule update --force --recursive --init --remote && cd .. && \
    chown devel:horns -R /home/devel/devels-workshop /home/devel/devels-workshop/.git && \
    # make backup script executable
    chmod +x devels-workshop/mnt/backup.sh && \
    chmod +x devels-workshop/mnt/backup-devel.sh && \
    chmod +x devels-workshop/mnt/backup-gabriel.sh && \
    chmod +x devels-workshop/mnt/backup-custom.sh && \
    # add symlinks for convenience
    ln -s devels-workshop dwork && ln -s devels-workshop/devels-playground dplay && \
    ./devels-workshop/scripts/gh-auth-first-time-login.sh 

# mount with halos ownership
USER ${_GABRIEL}
# set up shared backup drive structure 
RUN sudo mkdir -p ${mnt_data}/${_GABRIEL}/${_GABRIEL}-orig && \
    sudo mkdir -p ${mnt_data}/${_GABRIEL}/devel-orig && \
    sudo mkdir -p ${mnt_data}/devel/devel-orig && \
    sudo chown ${_GABRIEL}:${_HALOS} -R ${mnt_data}/${_GABRIEL} && \
    sudo chown devel:horns -R ${mnt_data}/devel && \
    sudo chown devel:horns ${mnt_data}/${_GABRIEL}/devel-orig && \
    # copy newly pulled backup script to mount location and home dirs
    sudo cp -arf dwork/mnt/backup-gabriel.sh ${mnt_data}/gabriel/backup-gabriel.sh && cp -arf dwork/mnt/backup-gabriel.sh /home/gabriel/backup-gabriel.sh  && \
    sudo cp -arf dwork/mnt/backup-custom.sh ${mnt_data}/${_GABRIEL}/backup-${_GABRIEL}.sh && cp -arf dwork/mnt/backup-custom.sh /home/${_GABRIEL}/backup-${_GABRIEL}.sh && \
    # sudo cp -arf dwork/mnt/backup-custom.sh ${mnt_data}/gabriel/backup-gabriel.sh && cp -arf dwork/mnt/backup-custom.sh /home/gabriel/backup-gabriel.sh && \
    sudo cp -arf dwork/mnt/backup-devel.sh ${mnt_data}/devel/backup-devel.sh && \
    sudo cp -arf dwork/mnt/backup-devel.sh ${mnt_data}/${_GABRIEL}/backup-devel.sh && cp -arf dwork/mnt/backup-devel.sh /home/${_GABRIEL}/backup-devel.sh  && \
    sudo cp -arf dwork/mnt/backup-devel.sh /home/devel/backup-devel.sh && \
    # make rwx for owner and rx for group - none for others
    sudo chmod 750 -R ${mnt_data}/${_GABRIEL} && \
    sudo chmod 755 ${mnt_data}/${_GABRIEL} && \
    sudo chmod 750 -R ${mnt_data}/devel && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/${_GABRIEL}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/gabriel/README_ASAP      && \
    sudo chown ${_GABRIEL}:${_HALOS} ${mnt_data}/README_ASAP
# wait to do this until we have WSL_DISTRO_NAME
# sh ${mnt_data}/backup-devel.sh

USER devel

#python stuff
FROM dplay_git as dplay_python

USER ${_GABRIEL}
RUN sudo apt-get install -y jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv && \
    # sudo python3 -m pip install --upgrade pip cryptography oauthlib openssl pyjwt setuptools wheel && \
    pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    sudo cp -r /home/${_GABRIEL}/.local/bin /usr/local

USER devel

# microsoft stuff
FROM dplay_python as dplay_msdot

USER ${_GABRIEL}
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN sudo apt-get install -y lsb-release && \
    sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    ## Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo rm packages-microsoft-prod.deb && \
    sudo apt-get update -yq && \
    sudo apt-get install -y powershell dotnet-sdk-7.0

USER devel


# for error "no valid drivers found: Cannot connect to the Docker daemon at tcp://localhost:2375":
# try running `unset DOCKER_HO`
FROM dplay_msdot as dplay_dind

USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-compose-plugin docker-ce docker-ce-cli containerd.io  && \
    chown -R devel:horns ../../../

USER gabriel
RUN cd linux && \
    sudo cp .config.new .config && \
    sudo make prepare scripts && \
    cd ../zfs && sudo sh autogen.sh && \
    sudo sh configure --prefix=/ --libdir=/lib --includedir=/usr/include --datarootdir=/usr/share --enable-linux-builtin=yes --with-linux=../linux --with-linux-obj=../linux && \
    sudo sh copy-builtin ../linux
RUN sudo make install && \
    cd ../linux/ && sudo sed -i 's/# CONFIG_ZFS is not set/CONFIG_ZFS=y/g' .config && echo grep ZFS .config && \
    sudo make && sudo make modules_install && sudo mkdir -p ../../../gabriel/kernels && sudo cp arch/x86/boot/bzImage ../../../gabriel/kernels/linux-kernel-626a5 && \
    sudo cp arch/x86/boot/bzImage ../../mnt/linux-kernel-626a6 && \
    sudo make -j16 && sudo make modules_install

USER devel

# for heavy gui (wsl2 required)
FROM dplay_dind as dplay_gui
USER root
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list  && \
    # in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
    apt-get update -yq && \
    apt-get install -y brave-browser && \
    cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    # change last line of this file - fix for brave-browser displaying empty windows
    head -n -1 /opt/brave.com/brave/brave-browser.old > /opt/brave.com/brave/brave-browser && \
    # now no longeer need to add --disable-gpu flag everytime
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' >> /opt/brave.com/brave/brave-browser && \
    # GNOME
    DEBIAN_FRONTEND=noninteractive apt-get -yq install daemonize gnome-session gdm3 gimp gedit gnupg nautilus snapd vlc x11-apps xfce4 zfsutils-linux && \
    daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target && \
    exec sudo nsenter -t $(pidof systemd) -a su - $LOGNAME && \
    systemctl restart snapd && \
    snap install lxd && \
    apt install -yqq build-essential autoconf automake libtool gawk alien fakeroot dkms libblkid-dev uuid-dev libudev-dev libssl-dev \
    zlib1g-dev libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi libffi-dev flex bison && \
    cp config-wsl linux-5.5.10/.config 



USER devel

FROM dplay_gui as dplay_cuda

USER ${_GABRIEL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER devel
