# to build, run: 
# `_AGL=mine _HALOS=ours docker run -d -i`
FROM ubuntu:latest AS dvlp_init
ARG _AGL=${_AGL:-agl}
ARG _HALOS=${_HALOS:-halos}
ARG mnt_data=${mnt_data:-/mnt/data}
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections && \
    addgroup --gid 777 ${_HALOS} && \
    addgroup --gid 666 horns && \
    adduser --home /home/${_AGL} --ingroup ${_HALOS} --shell /bin/bash --uid 1000 --disabled-password ${_AGL} && \
    adduser --system --home /home/host --ingroup ${_HALOS} --shell /bin/bash --uid 76667 --disabled-password host && \
    adduser --home /home/dvl --ingroup horns --shell /bin/bash --uid 666 --disabled-password dvl && \
    # ensure no passwords
    passwd -d ${_AGL} && \
    passwd -d dvl && \
    passwd -d host && \
    passwd -d root && \
    passwd -l root

# HAL permissions/volume builder
FROM dvlp_init AS dvlp_hal
USER root
# add dvl and host users using custom user setup
# add only _AGL to the sudo list
RUN usermod -aG ${_HALOS} host && \
    # usermod -aG horns ${_AGL} && \
    usermod -aG sudo ${_AGL} && \
    # chown -Rv ${_AGL}:${_HALOS} /home/${_AGL} \
    chown -Rv host:${_HALOS} /home/host && \
    chown -Rv ${_AGL}:${_HALOS} /home/${_AGL} && \
    apt-get update -yq && \
    apt-get upgrade -y && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    # add ${_AGL} to sudo group
    sudo adduser ${_AGL} sudo && \
    # uncomment to add sudo privileges for host
    # sudo adduser host sudo && \
    # set up /hal folder as symbolic link to /home/agl 
    ln -s /home/${_AGL} /hal && \
    chown -Rv ${_AGL}:${_HALOS} /hal && \
    # TODO: add a "readme" here
    touch /hal/o.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /hal/.ssh /hal/dls && chmod 700 /hal/.ssh && \
    chown -Rv ${_AGL}:${_HALOS} /hal/.ssh /hal/dls && \
    # make dvl default wsl user 
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf
# mount stuff if needed
# echo "//${mnt_data}/${_AGL} /home/${_AGL} cifs _AGL=${_AGL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/dvl /home/dvl cifs _AGL=dvl, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
# copy to skel and /hel, add common paths
USER ${_AGL}
ENV PATH="$PATH:/home/${_AGL}/.local/bin:/hel/devels-work/scripts:/home/dvl/devels-work/devels-play/scripts"
RUN echo 'export WSL_DISTRO_NAME="$WSL_DISTRO_NAME"\nalias cdir="source cdir.sh"\nalias grep="grep --color=auto"\nalias powershell=pwsh\nalias vi="vi -c '"'set verbose showmode'"'"'  >> /home/${_AGL}/.bashrc && \
    sudo cp -rfv /home/${_AGL}/. /etc/skel/ && \
    sudo rm /etc/skel/.sudo_as_admin_successful 
USER dvl

# HEL volume/permissions builder
FROM dvlp_hal AS dvlp_hel
USER root
# set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
RUN ln -s /home/dvl /hel && \
    chown -Rv dvl:horns /home/dvl && chown -Rv dvl:horns /hel  && \
    chown -Rv dvl:horns /hel  && \
    # add an instructional "readme" here later
    touch /hel/lo.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /hel/.ssh /hel/dls && chmod 700 /hel/.ssh && \
    # set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
    chown -Rv dvl:horns /hel/.ssh /hel/dls
# uncomment to add sudo priveleges for host / dvl
# sudo adduser dvl sudo && \
USER dvl
# add common paths
ENV PATH="$PATH:/home/dvl/.local/bin:/hel/devels-work/scripts:/home/dvl/devels-work/devels-play/scripts"

# DATA helper
FROM dvlp_hel AS dvlp_data
USER root
# copy skel files to dvl
RUN cp -rpv /etc/skel/. /home/dvl/ && chown -Rv dvl:horns /home/dvl && \
    apt-get -y install git
USER dvl
WORKDIR /home/dvl
# add safe directories
RUN git config --global --add safe.directory /home/dvl && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/dvl/devels-play && \
    # clone fresh repos and give dvl ownership
    git clone https://github.com/kindtek/devels-work --depth=1 --single-branch --progress
# RUN git clone https://github.com/kindtek/devels-work --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/dvl/devels-work
RUN git pull && git submodule update --init --remote --depth=1 --progress
WORKDIR /home/dvl
# && \
# if [ -d "${mnt_data}/dvl" ]; then \
# if [ ! -fv "${mnt_data}/dvl/backup-docker.sh" ]; then \
# echo "#!/bin/bash" > dvl/backup-docker.sh; \
# fi \
# fi && \
# # RUN if [ -d "${mnt_data}/${_AGL}" ]; then \
# #         if [ ! -fv "${mnt_data}/${_AGL}/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> ${_AGL}/backup-docker.sh; \
# #         fi \
# #     fi \
# #     if [ -d "${mnt_data}/agl" ]; then \
# #         if [ ! -fv "${mnt_data}/agl/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> agl/backup-docker.sh; \
# #         fi \
# #     fi
# chown -Rv dvl:horns /home/dvl && chown -Rv ${_AGL}:${_HALOS} /home/${_AGL}
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/agl/backup-docker.sh
# RUN sudo .${mnt_data}/agl/backup-docker.sh
USER dvl

# SKELETON framework
FROM dvlp_data AS dvlp_skel
# RUN with halos ownership
USER ${_AGL}
# RUN sudo chown ${_AGL}:${_HALOS} -Rv ${mnt_data}/${_AGL} /home/${_AGL}  \
#     git config --global --add safe.directory /home/agl && \
#     git config --global --add safe.directory /hal 
RUN sudo apt-get -y update && \
    sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    sudo apt-get install -y tzdata && \
    sudo dpkg-reconfigure --frontend noninteractive tzdata && \
    sudo dpkg --configure -a && \
    # sudo apt-get upgrade -y libsnmp40 && \
    sudo apt-get -y install apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget wslu && \
    # make gh files executable
    sudo chmod +x devels-work/devels-play/mnt/bak/*/backup-*.sh && \
    sudo chmod +x devels-work/scripts/gh-auth-first-time-login.sh && \
    # copy gh files to mount location and home dirs
    sudo mkdir -p ${mnt_data} && sudo cp -arfv devels-work/devels-play/mnt/bak/** ${mnt_data} && sudo chown ${_AGL}:${_HALOS} -Rv ${mnt_data} && \
    sudo mv -unv ${mnt_data}/custom ${mnt_data}/${_AGL} && \
    sudo ln -s ${mnt_data}/agl /home/agl/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/agl/bak && \
    sudo ln -sf ${mnt_data}/${_AGL} /home/${_AGL}/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/${_AGL}/bak && \
    sudo ln -s ${mnt_data}/dvl /home/dvl/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/dvl/bak && \
    # make rwx for owner and rw for group - x/rx for others
    sudo chmod 754 -Rv ${mnt_data}/${_AGL} && \
    sudo chmod 751 ${mnt_data}/${_AGL} && sudo chmod 751 ${mnt_data}/agl && sudo chmod 751 ${mnt_data}/dvl && \
    sudo chmod 754 -Rv ${mnt_data}/dvl && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/README_ASAP      && \
    # echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/${_AGL}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/agl/README_ASAP      && \
    sudo chown agl:halos ${mnt_data}/README_ASAP ${mnt_data}/${_AGL}/backup-agl.sh && \
    sudo chown ${_AGL}:${_HALOS} ${mnt_data}/${_AGL}/backup-${_AGL}.sh ${mnt_data}/dvl/backup-dvl.sh && \
    sudo chown dvl:horns -RPv /home/dvl && sudo chown ${_AGL}:${_HALOS} -RPv /home/agl 
USER dvl
# setup ssh gh login
# add symlinks for convenience
RUN ln -s devels-work dvlw && \
    ln -s devels-work/devels-play dvlp && \
    ln -s devels-play devels-work/dvlp && \
    ln -s devels-work/devels-play/linux linux && \
    ln -s devels-work/devels-play/docker/ubuntu ub && \
    ln -s devels-work/devels-play/kernel kernel && \
    ln -s docker devels-work/devels-play/docker docker
# sh devels-work/scripts/gh-auth-first-time-login.sh

# GIT
FROM dvlp_skel as dvlp_git
WORKDIR /home/dvl
USER root
# copy and set ownership
RUN cp -rfv devels-work/scripts/gh-auth-first-time-login.sh /home/dvl && \
    cp -rfv devels-work/scripts/gh-auth-first-time-login.sh /home/${_AGL}  && \
    chmod og+x /home/dvl/gh-auth-first-time-login.sh && chmod og+x /home/${_AGL}/gh-auth-first-time-login.sh && \
    chown dvl:horns /home/dvl/gh-auth-first-time-login.sh && chown ${_AGL}:${_HALOS} /home/${_AGL}/gh-auth-first-time-login.sh 
USER dvl
WORKDIR /home/dvl

# PYTHON stuff
FROM dvlp_git AS dvlp_python
USER ${_AGL}
RUN sudo apt-get -y install apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv && \
    pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    sudo cp -rfv /home/${_AGL}/.local/bin /usr/local && \
    sudo cp -afv /home/${_AGL}/.local /etc/skel/ && \
    sudo cp -afv /home/${_AGL}/.local /home/dvl/ && sudo chown -Rv dvl:horns /home/dvl
USER dvl

# MICROSOFT stuff
FROM dvlp_python AS dvlp_msdot
USER ${_AGL}
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
FROM dvlp_msdot AS dvlp_dind
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN sudo mkdir -pv /etc/apt/keyrings   && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io
USER dvl

# KERNEL builder
############################## DEFAULT MICROSOFT WSL 5_1519 KERNEL ######################################
FROM dvlp_dind AS dvlp_kernel-phat
USER root
RUN echo exit 0 > /usr/sbin/policy-rc.d && \
    sudo apt-get -y update && apt-get -y upgrade && \
    apt-get -y install alien autoconf bison dbus-user-session daemonize dwarves fakeroot flex fontconfig gawk libblkid-dev libffi-dev \
    lxcfs libudev-dev libssl-dev libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi snapd sysvinit-utils uuid-dev

# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER ${_AGL}
WORKDIR /home/${_AGL}/dls
RUN sudo apt install build-essential flex bison libssl-dev libelf-dev git dwarves && \
    git clone https://github.com/microsoft/WSL2-Linux-Kernel.git --progress --depth=1 --single-branch   && \
    mv -v WSL2-Linux-Kernel wsl2
WORKDIR /home/${_AGL}/dls/wsl2
RUN sudo cp -fv /home/dvl/devels-work/devels-play/kernel/5_1519/amd/.config_0 /home/${_AGL}/dls/wsl2/.config && \
    sudo chown ${_AGL}:${_HALOS} .config && \
    yes "" | sudo make -j $(expr $(nproc) - 1) && sudo make modules_install && \
    sudo mkdir -pv ../../../${_AGL}/kernels && sudo mkdir -pv ../../../dvl/kernels && \
    sudo cp -fv arch/x86/boot/bzImage ../../../${_AGL}/kernels/linux-kernel-5_1519_0a && \
    sudo cp -fv arch/x86/boot/bzImage ../../../dvl/kernels/linux-kernel-5_1519_0a && \
    sudo rm -rfv /hal/dls/* && \
    echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc

WORKDIR /home/dvl
USER dvl

# Kernel only
FROM dvlp_dind AS dvlp_kernel
COPY --from=dvlp_kernel-phat /home/agl/kernels /home/agl
COPY --from=dvlp_kernel-phat /home/dvl/kernels /home/dvl

# GUI - wsl2 required
FROM dvlp_kernel AS dvlp_gui
USER ${_AGL}
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list && \ 
    # in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
    sudo apt-get -yq update && \
    sudo apt-get -y install brave-browser && \
    # now no longeer need to add --disable-gpu flag everytime
    sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old && \
    # change last line of this file - fix for brave-browser displaying empty windows
    head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null && \
    echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null && \
    # this is a better way to do this but needs work
    # cd /opt/brave.com/brave && \
    # brave_old_line='\"\$HERE\/brave\"\s\"\$\@\"\s\|\|\strue' && \
    # brave_new_line='"\$HERE/brave" "\$@" " " --disable-gpu " || true' && \
    # sudo sed -i 's/$brave_old_line/$brave_new_line/g' /opt/brave.com/brave/brave-browser && cd /home/dvl && \
    sudo apt-get -y install x11-apps xfce4 && \
    sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -yq install gnome-session gdm3 gimp gedit nautilus vlc 
USER dvl

FROM dvlp_gui AS dvlp_gui-phat
COPY --from=dvlp_kernel-phat ./ ./

FROM dvlp_gui AS dvlp_cuda
USER ${_AGL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER dvl

FROM dvlp_gui-phat AS dvlp_cuda-phat
USER ${_AGL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
USER dvl

