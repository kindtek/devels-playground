# to build, run: 
# `_AGL=mine _HALO=ours docker run -d -i`
FROM ubuntu:latest AS dvlp_init
ARG _AGL=${_AGL:-agl}
ARG _HALO=${_HALO:-halo}
ARG _CONFIG_FILE=../kernels/ubuntu/x86/generic/.config_wsl0

ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'tzdata tzdata/Areas select America' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/America select Los Angeles' | debconf-set-selections && \
    apt-get update -yq && \
    apt-get upgrade -y && \
    apt-get -y install sudo && \
    # adduser --system --home /home/host --ingroup ${_HALO} --shell /bin/bash --uid 76667 --disabled-password host && \
    # usermod -aG ${_HALO} host && \
    # ensure no passwords
    # passwd -d host && \
    addgroup --gid 777 ${_HALO}  && \
    adduser --home /home/${_AGL} --ingroup ${_HALO} --shell /bin/bash --uid 1000 --disabled-password --gecos GECOS ${_AGL} && \
    passwd -d ${_AGL} && \
    # usermod -aG hel ${_AGL} && \
    usermod -aG sudo ${_AGL} && \
    addgroup --gid 666 hel && \
    adduser --home /home/dvl --ingroup hel --shell /bin/bash --uid 666 --disabled-password --gecos GECOS dvl && \
    passwd -d dvl && \
    passwd -d root && \
    passwd -l root && \
    # non-root will need to use sudo from now on
    echo "[user]\ndefault=dvl" >> /etc/wsl.conf

# HALO permissions/volume builder
FROM dvlp_init AS dvlp_halo
ARG _AGL=${_AGL:-agl}
ARG _HALO=${_HALO:-halo}
# add dvl and host users using custom user setup
# add only _AGL to the sudo list

# chown -Rv ${_AGL}:${_HALO} /home/${_AGL} \
# chown -Rv host:${_HALO} /home/host && \
RUN ln -s /home/${_AGL} /halo && \
    # set up .ssh and dls directories and make sure .ssh has proper permissions
    # mkdir -pv /home/${_AGL}/.ssh /home/${_AGL}/dls && chmod 700 /home/${_AGL}/.ssh
    # chown -Rv ${_AGL}:${_HALO} /home/${_AGL}/.ssh /home/${_AGL}/dls
    # make dvl default wsl user 
    # mount stuff if needed
    # echo "//${mnt_data}/bak/${_AGL} /home/${_AGL} cifs _AGL=${_AGL}, file_mode=0777,dir_mode=0777 0 0\n/${mnt_data}/bak/dvl /home/dvl cifs _AGL=dvl, file_mode=0777, dir_mode=0777 0 0" >> /etc/fstab && \
    # copy to skel and /hel, add common paths
    echo 'export PATH=$PATH:/home/${_AGL}/.local/bin:/hel/dvl-works/scripts:/home/dvl/dvl-works/dvlp/scripts:WSL_DISTRO_NAME="$WSL_DISTRO_NAME"\nalias cdir="source cdir.sh"\nalias grep="grep --color=auto"\nalias powershell=pwsh\nalias vi="vi -c '"'set verbose showmode'"'"'  >> /home/${_AGL}/.bashrc && \
    cp -rfv /home/${_AGL}/. /etc/skel/

# HEL volume/permissions builder
FROM dvlp_init AS dvlp_hel
# chsh -s /bin/bash && \
# set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
RUN ln -s /home/dvl /hel && \
    cp -rpv /etc/skel/. /home/dvl/ 

# chown -Rv dvl:hel /home/dvl && chown -Rv dvl:hel /hel  && \
# chown -Rv dvl:hel /hel  && \
# add an instructional "readme" here later
# set up .ssh and dls directories and make sure .ssh has proper permissions
# mkdir -pv /home/dvl/.ssh /home/dvl/dls && chmod 700 /home/dvl/.ssh 
# set up /dvl folder as symbolic link to /home/dvl for cloning repository(ies)
# chown -Rv dvl:hel /hel/.ssh /hel/dls
# uncomment to add sudo priveleges for host / dvl
# sudo adduser dvl sudo && \
USER dvl
# add common paths

# DATA helper
FROM dvlp_init AS dvlp_data
USER root
WORKDIR /
COPY --from=dvlp_halo --chown=${_AGL}:${_HALO} ./home/${_AGL} ./home/${_AGL}
COPY --from=dvlp_hel --chown=dvl:hel  ./home/dvl ./home/dvl
# copy skel files to dvl
RUN apt-get -y install git
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
# if [ -d "${mnt_data}/bak/dvl" ]; then \
# if [ ! -fv "${mnt_data}/bak/dvl/backup-docker.sh" ]; then \
# echo "#!/bin/bash" > dvl/backup-docker.sh; \
# fi \
# fi && \
# # RUN if [ -d "${mnt_data}/bak/${_AGL}" ]; then \
# #         if [ ! -fv "${mnt_data}/bak/${_AGL}/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> ${_AGL}/backup-docker.sh; \
# #         fi \
# #     fi \
# #     if [ -d "${mnt_data}/bak/agl" ]; then \
# #         if [ ! -fv "${mnt_data}/bak/agl/backup-docker.sh" ]; then \
# #             echo "#!/bin/bash" >> agl/backup-docker.sh; \
# #         fi \
# #     fi
# chown -Rv dvl:hel /home/dvl && chown -Rv ${_AGL}:${_HALO} /home/${_AGL}
# RUN echo "# # # # Docker # # # # " >> ${mnt_data}/bak/agl/backup-docker.sh
# RUN sudo .${mnt_data}/bak/agl/backup-docker.sh
USER dvl

# SKELETON framework
FROM scratch AS dvlp_skel
ARG _AGL=${_AGL:-agl}
ARG _HALO=${_HALO:-halo}
ARG mnt_data=${mnt_data:-/mnt/data}
COPY --from=dvlp_init --chown=root:root ./ ./
COPY --from=dvlp_data --chown=dvl:hel ./home/dvl ./home/dvl
COPY --from=dvlp_data --chown=${_AGL}:${_HALO} ./home/${_AGL} ./home/${_AGL}
COPY --from=dvlp_data --chown=${_AGL}:${_HALO} ./home/dvl/dvl-works/dvlp/mnt .${mnt_data}
COPY --from=dvlp_hel --chown=dvl:hel ./home/dvl ./home/dvl
COPY --from=dvlp_halo --chown=${_AGL}:${_HALO} ./home/${_AGL} ./home/${_AGL}
WORKDIR /home/dvl
# RUN with halo ownership
USER ${_AGL}
# RUN sudo chown ${_AGL}:${_HALO} -Rv ${mnt_data}/bak/${_AGL} /home/${_AGL}  \
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
    sudo chmod -R +x dvl-works/dvlp/mnt/bak && \
    sudo chmod +x dvl-works/scripts/gh-auth-first-time-login.sh && \
    # copy gh files to mount location and home dirs
    sudo mkdir -p ${mnt_data}/bak && sudo cp -arfv dvl-works/dvlp/mnt/bak ${mnt_data} && sudo chown ${_AGL}:${_HALO} -Rv ${mnt_data}/bak && \
    # sudo mv -unv ${mnt_data}/bak/custom ${mnt_data}/bak/${_AGL} && \
    sudo ln -s ${mnt_data}/bak/agl /home/agl/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/agl/bak && \
    sudo ln -sf ${mnt_data}/bak/${_AGL} /home/${_AGL}/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/${_AGL}/bak && \
    sudo ln -s ${mnt_data}/bak/dvl /home/dvl/bak && sudo chown -Rv ${_AGL}:${_HALO} /home/dvl/bak && \
    # make rwx for owner and rw for group - x/rx for others
    sudo chmod 754 -Rv ${mnt_data}/bak/${_AGL} && \
    sudo chmod 751 ${mnt_data}/bak/${_AGL} && \
    sudo chmod 751 ${mnt_data}/bak/agl && sudo chmod 751 ${mnt_data}/bak/dvl && \
    sudo chmod 754 -Rv ${mnt_data}/bak/dvl && \
    # # add warning for the backup drive
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/README_ASAP      && \
    # echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/${_AGL}/README_ASAP      && \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_AGL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${mnt_data}/bak/agl/README_ASAP && \
    sudo chown agl:halo ${mnt_data}/bak/README_ASAP ${mnt_data}/bak/${_AGL}/backup-agl.sh && \
    sudo chown ${_AGL}:${_HALO} ${mnt_data}/bak/${_AGL}/backup-${_AGL}.sh ${mnt_data}/bak/dvl/backup-dvl.sh && \
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
FROM dvlp_init AS dvlp_python-lite
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

FROM dvlp_git AS dvlp_python
WORKDIR / 
COPY --from=dvlp_python-lite ./ ./
WORKDIR /home/dvl

# MICROSOFT stuff
FROM dvlp_init AS dvlp_msdot-lite
USER ${_AGL}
# for powerhell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
RUN sudo apt-get -y install lsb-release wget
RUN sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    #  && \
    ## Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb && \
    sudo apt-get -y update && \
    sudo apt-get -y install powershell dotnet-sdk-7.0 && \
    # sudo rm packages-microsoft-prod.deb
    # RUN sudo apt-get -y remove lsb_release
    sudo apt-get clean all && \
    sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_python AS dvlp_msdot
WORKDIR /
COPY --from=dvlp_msdot-lite ./ ./
WORKDIR /home/dvl

# DOCKER IN DOCKER
FROM dvlp_init AS dvlp_dind-lite
USER root
# DOCKER - https://docs.docker.com/engine/install/ubuntu/
RUN sudo apt-get -y install lsb-release curl gpg && \
    sudo apt-get clean all && \
    sudo mkdir -pv /etc/apt/keyrings && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get -y update && sudo apt-get -y install docker-compose-plugin docker-ce docker-ce-cli containerd.io && \
    # sudo apt-get remove -y lsb-release && \
    sudo apt-get clean all && \
    sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

FROM dvlp_msdot AS dvlp_dind
WORKDIR /
COPY --from=dvlp_dind-lite ./ ./
WORKDIR /home/dvl
USER dvl

# KERNEL builder
FROM dvlp_init AS dvlp_kernel
USER ${_AGL}
# RUN echo exit 0 > /usr/sbin/policy-rc.d 
RUN sudo apt-get -y update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y install alien autoconf bison && \
    sudo apt-get -y install dbus-user-session daemonize dwarves && \
    sudo apt-get -y install fakeroot flex fontconfig gawk libblkid-dev libffi-dev && \
    sudo apt-get -y install lxcfs libudev-dev libssl-dev libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi snapd sysvinit-utils uuid-dev
# RUN sudo apt-get -y install zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed
USER ${_AGL}
WORKDIR /home/${_AGL}/dls
RUN sudo apt-get -y install build-essential flex bison libssl-dev libelf-dev git dwarves 
WORKDIR /home/dvl-works/dvlp/kernels/ubuntu
RUN sudo apt-get clean all && \
    sudo apt-get autoremove --purge
WORKDIR /home/dvl
USER dvl

# Kernel only
FROM dvlp_dind AS dvlp_kernel-phat
WORKDIR /
COPY --from=dvlp_kernel ./ ./
WORKDIR /home/dvl/dvlp/kernels/ubuntu
USER ${_AGL}
SHELL ["/bin/bash", "-c"]
RUN sudo chmod +x build-basic-wsl-kernel.sh
RUN sudo sh build-basic-wsl-kernel.sh '' ${_AGL}
RUN echo '# sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target\n# exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME\n# echo "exec sudo nsenter -t $(pidof -s systemd) -a su - $LOGNAME" > /dev/null && wait -n\n' >> /home/${_AGL}/.bashrc
USER dvl

FROM dvlp_dind AS dvlp_kernel-lite
WORKDIR /
COPY --from=dvlp_kernel-phat ./home/dvl/dvl-works/dvlp/kernels ./home/dvl/dvl-works/dvlp/kernels
WORKDIR /home/dvl
USER dvl

# GUI - wsl2 required
FROM dvlp_init AS dvlp_gui
WORKDIR /
COPY --from=dvlp_kernel-lite ./ ./
USER ${_AGL}
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list && \ 
    # in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
    sudo apt-get -yq update && \
    sudo apt-get -y install brave-browser && \
    sudo apt-get clean all && \
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

FROM dvlp_kernel-phat AS dvlp_gui-phat
WORKDIR /
COPY --from=dvlp_gui ./ ./
WORKDIR /home/dvl
USER dvl

FROM dvlp_init AS dvlp_cuda
USER ${_AGL}
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
WORKDIR /home/dvl
USER dvl

FROM dvlp_gui-phat AS dvlp_cuda-phat
WORKDIR /
COPY --from=dvlp_cuda ./ ./
WORKDIR /home/dvl
USER dvl

