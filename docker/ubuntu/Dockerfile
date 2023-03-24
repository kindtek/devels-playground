# to build, run: 
# `_AGL=mine _HALO=ours docker run -d -i`
FROM ubuntu:latest AS dvlp_init
SHELL ["/bin/bash", "-c"]
RUN chsh -s /bin/bash
ARG _AGL=${_AGL:-agl}
ARG _HALO=${_HALO:-halo}
ARG _CONFIG_FILE=../kernels/ubuntu/x86/generic/.config_wsl0
ARG mnt_data=${mnt_data:-/mnt/data}
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections && \
    addgroup --gid 777 ${_HALO} && \
    addgroup --gid 666 hel && \
    adduser --home /home/${_AGL} --ingroup ${_HALO} --shell /bin/bash --uid 1000 --disabled-password ${_AGL} && \
    adduser --system --home /home/host --ingroup ${_HALO} --shell /bin/bash --uid 76667 --disabled-password host && \
    adduser --home /home/dvl --ingroup hel --shell /bin/bash --uid 666 --disabled-password dvl && \
    # ensure no passwords
    passwd -d ${_AGL} && \
    passwd -d dvl && \
    passwd -d host && \
    passwd -d root && \
    passwd -l root && \
    apt-get update -yq && \
    apt-get upgrade -y && \
    # non-root will need to use sudo from now on
    apt-get -y install sudo && \
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf

# HALO permissions/volume builder
FROM scratch AS dvlp_halo
USER root
# add dvl and host users using custom user setup
# add only _AGL to the sudo list
RUN usermod -aG ${_HALO} host && \
    # usermod -aG hel ${_AGL} && \
    usermod -aG sudo ${_AGL} && \
    # chown -Rv ${_AGL}:${_HALO} /home/${_AGL} \
    chown -Rv host:${_HALO} /home/host && \
    chown -Rv ${_AGL}:${_HALO} /home/${_AGL} && \
    # add ${_AGL} to sudo group
    sudo adduser ${_AGL} sudo && \
    # uncomment to add sudo privileges for host
    # sudo adduser host sudo && \
    # set up /halo folder as symbolic link to /home/agl 
    ln -s /home/${_AGL} /halo && \
    chown -Rv ${_AGL}:${_HALO} /halo && \
    # TODO: add a "readme" here
    touch /halo/o.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /halo/.ssh /halo/dls && chmod 700 /halo/.ssh && \
    chown -Rv ${_AGL}:${_HALO} /halo/.ssh /halo/dls && \
    # make dvl default wsl user 
    # mount stuff if needed
    # echo "//${mnt_data}/${_AGL} /home/${_AGL} cifs _AGL=${_AGL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/dvl /home/dvl cifs _AGL=dvl, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
    # copy to skel and /hel, add common paths
    USER ${_AGL}
RUN chsh -s /bin/bash
ENV PATH="$PATH:/home/${_AGL}/.local/bin:/hel/dvl-works/scripts:/home/dvl/dvl-works/dvlp/scripts"
RUN echo 'export WSL_DISTRO_NAME="$WSL_DISTRO_NAME"\nalias cdir="source cdir.sh"\nalias grep="grep --color=auto"\nalias powershell=pwsh\nalias vi="vi -c '"'set verbose showmode'"'"'  >> /home/${_AGL}/.bashrc && \
    sudo cp -rfv /home/${_AGL}/. /etc/skel/ && \
    sudo rm /etc/skel/.sudo_as_admin_successful 
USER dvl
RUN chsh -s /bin/bash

# HEL volume/permissions builder
FROM scratch AS dvlp_hel
USER root
# set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
RUN ln -s /home/dvl /hel && \
    # chown -Rv dvl:hel /home/dvl && chown -Rv dvl:hel /hel  && \
    # chown -Rv dvl:hel /hel  && \
    # add an instructional "readme" here later
    touch /hel/lo.world && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    mkdir -pv /hel/.ssh /hel/dls && chmod 700 /hel/.ssh && \
    # set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
    # chown -Rv dvl:hel /hel/.ssh /hel/dls
    # uncomment to add sudo priveleges for host / dvl
    # sudo adduser dvl sudo && \
    USER dvl
# add common paths
ENV PATH="$PATH:/home/dvl/.local/bin:/hel/dvl-works/scripts:/home/dvl/dvl-works/dvlp/scripts"

# DATA helper
FROM dvlp_hel AS dvlp_data
USER root
WORKDIR /
COPY --from=dvlp_init . .
COPY --from=dvlp_halo --chown=${_AGL}:${_HALO} . .
COPY --from=dvlp_hel --chown=dvl:hel . .

# copy skel files to dvl
RUN cp -rpv /etc/skel/. /home/dvl/ && chown -Rv dvl:hel /home/dvl && \
    apt-get -y install git
USER dvl
WORKDIR /home/dvl
# add safe directories
RUN git config --global --add safe.directory /home/dvl && \
    git config --global --add safe.directory /hel && \
    git config --global --add safe.directory /home/dvl/dvlp && \
    # clone fresh repos and give dvl ownership
    git clone https://github.com/kindtek/dvl-works --depth=1 --single-branch --progress
# RUN git clone https://github.com/kindtek/dvl-works --verbose --progress --recurse-submodules --remote-submodules --shallow-submodules --no-tags --filter=blob:limit=102400 depth=1
# --filter=combine:tree:depth:1+blob:limit=10240000  --recurse-submodules --remote-submodules  --single-branch  --no-tags --filter=blob:limit=1024000 --single-branch --branch main
WORKDIR /home/dvl/dvl-works
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
# chown -Rv dvl:hel /home/dvl && chown -Rv ${_AGL}:${_HALO} /home/${_AGL}
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/agl/backup-docker.sh
# RUN sudo .${mnt_data}/agl/backup-docker.sh
USER dvl

# SKELETON framework
FROM dvlp_data AS dvlp_skel
# RUN with halo ownership
USER ${_AGL}
# RUN sudo chown ${_AGL}:${_HALO} -Rv ${mnt_data}/${_AGL} /home/${_AGL}  \
#     git config --global --add safe.directory /home/agl && \
#     git config --global --add safe.directory /halo 
RUN sudo apt-get -y update && \
    sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    sudo apt-get install -y tzdata && \
    sudo dpkg-reconfigure --frontend noninteractive tzdata && \
    sudo dpkg --configure -a && \
    # sudo apt-get upgrade -y libsnmp40 && \
    sudo apt-get -y install apt-transport-https build-essential ca-certificates cifs-utils curl git gh gnupg2 libssl-dev nvi wget wslu && \
    # make gh files executable
    sudo chmod +x dvl-works/dvlp/mnt/bak/*/backup-*.sh && \
    sudo chmod +x dvl-works/scripts/gh-auth-first-time-login.sh && \
    # copy gh files to mount location and home dirs
    sudo mkdir -p ${mnt_data} && sudo cp -arfv dvl-works/dvlp/mnt/bak/** ${mnt_data} && sudo chown ${_AGL}:${_HALO} -Rv ${mnt_data} && \
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
    sudo chown agl:halo ${mnt_data}/README_ASAP ${mnt_data}/${_AGL}/backup-agl.sh && \
    sudo chown ${_AGL}:${_HALO} ${mnt_data}/${_AGL}/backup-${_AGL}.sh ${mnt_data}/dvl/backup-dvl.sh && \
    sudo chown dvl:hel -RPv /home/dvl && sudo chown ${_AGL}:${_HALO} -RPv /home/agl 
USER root
# copy and set ownership
RUN cp -rfv dvl-works/scripts/gh-auth-first-time-login.sh /home/dvl && \
    cp -rfv dvl-works/scripts/gh-auth-first-time-login.sh /home/${_AGL}  && \
    chmod og+x /home/dvl/gh-auth-first-time-login.sh && chmod og+x /home/${_AGL}/gh-auth-first-time-login.sh && \
    chown dvl:hel /home/dvl/gh-auth-first-time-login.sh && chown ${_AGL}:${_HALO} /home/${_AGL}/gh-auth-first-time-login.sh 
USER dvl
# setup ssh gh login
# add symlinks for convenience
RUN ln -s dvl-works dvlw && \
    ln -s dvl-works/dvlp dvlp && \
    ln -s dvl-works/dvlp/linux linux && \
    ln -s dvl-works/dvlp/docker/ubuntu udocker && \
    ln -s dvl-works/dvlp/kernels/ubuntu/x86/amd u64amdkernels && \
    ln -s dvl-works/dvlp/kernels/ubuntu ukernels && \
    ln -s dvl-works/dvlp/docker docker
WORKDIR /home/dvl
USER dvl

# GIT
FROM dvlp_skel as dvlp_git

# PYTHON stuff
FROM dvlp_init AS dvlp_python_lite
USER ${_AGL}
RUN sudo apt-get -y install apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv && \
    pip3 install cdir --user  && \
    pip3 install pip --upgrade --no-warn-script-location --no-deps && \
    sudo python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install --upgrade --no-warn-script-location --no-deps && \
    sudo cp -rfv /home/${_AGL}/.local/bin /usr/local && \
    sudo cp -afv /home/${_AGL}/.local /etc/skel/ && \
    sudo cp -afv /home/${_AGL}/.local /home/dvl/ && sudo chown -Rv dvl:hel /home/dvl && \
    sudo apt-get -y autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_python_lite AS dvlp_python
WORKDIR / 
COPY --from=dvlp_skel . .
WORKDIR /home/dvl

# MICROSOFT stuff
FROM dvlp_skel AS dvlp_msdot_lite
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
    sudo rm packages-microsoft-prod.deb && \
    sudo apt-get -y remove lsb_release && \
    sudo apt-get -y autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_msdot_lite AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_skel . .
COPY --from=dvlp_python . .
WORKDIR /home/dvl

# DOCKER IN DOCKER
FROM dvlp_skel AS dvlp_dind_lite
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN sudo apt-get -y install lsb-release && \
    sudo mkdir -pv /etc/apt/keyrings   && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io && \
    sudo apt-get remove -y lsb_release && \
    sudo apt-get -y autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_dind_lite AS dvlp_dind
WORKDIR /
COPY --from=dvlp_skel . .
COPY --from=dvlp_python_lite . .
COPY --from=dvlp_msdot_lite . .
WORKDIR /home/dvl
USER dvl

# KERNEL builder
FROM dvlp_skel AS dvlp_kernel
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
RUN if ! [ ${_CONFIG_FILE} -f ]; then sudo cp -fv /home/dvl/dvl-works/dvlp/kernels/ubuntu/x86/generic/.config_wsl0 /home/${_AGL}/dls/wsl2/.config; else cp -fv ${_CONFIG_FILE} /home/${_AGL}/dls/wsl2/.config && \
    sudo chown ${_AGL}:${_HALO} .config && \
    yes "" | sudo make -j $(expr $(nproc) - 1) && sudo make modules_install && \
    sudo mkdir -pv ../../../${_AGL}/kernels && sudo mkdir -pv ../../../dvl/kernels && \
    sudo cp -fv arch/x86/boot/bzImage ../../../${_AGL}/linux-kernel-5_1519_0a && \
    sudo cp -fv arch/x86/boot/bzImage ../../../dvl/linux-kernel-5_1519_0a && \
    sudo rm -rfv /halo/dls/* && \
    echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
WORKDIR /home/dvl
USER dvl

FROM dvlp_kernel AS dvlp_kernel-phat
WORKDIR /
COPY --from=dvlp_skel . .
COPY --from=dvlp_python_lite . .
COPY --from=dvlp_msdot_lite . .
COPY --from=dvlp_dind_lite . .
WORKDIR /home/dvl
USER dvl

# Kernel only
FROM dvlp_skel AS dvlp_kernel-lite
WORKDIR /
COPY --from=dvlp_skel . .
WORKDIR /home/agl
COPY --from=dvlp_kernel-phat /home/agl .
WORKDIR /home/dvl/dvl-works/dvlp/kernels
COPY --from=dvlp_kernel-phat /home/dvl/dvl-works/dvlp/kernels .
WORKDIR /home/dvl
USER dvl

# GUI - wsl2 required
FROM dvlp_skel AS dvlp_gui
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
WORKDIR /home/dvl
USER dvl

FROM dvlp_gui AS dvlp_gui-phat
WORKDIR /
COPY --from=dvlp_skel . .
COPY --from=dvlp_python_lite . .
COPY --from=dvlp_msdot_lite . .
COPY --from=dvlp_dind_lite . .
COPY --from=dvlp_kernel-phat . .
WORKDIR /home/dvl
USER dvl

FROM dvlp_gui AS dvlp_cuda
USER ${_AGL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
WORKDIR /home/dvl
USER dvl

FROM dvlp_gui-phat AS dvlp_cuda-phat
WORKDIR /
COPY --from=dvlp_skel . .
COPY --from=dvlp_python_lite . .
COPY --from=dvlp_msdot_lite . .
COPY --from=dvlp_dind_lite . .
COPY --from=dvlp_kernel-phat . .
COPY --from=dvlp_cuda . .
WORKDIR /home/dvl
USER dvl

