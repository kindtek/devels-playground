# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM ubuntu:latest AS dplay_skel
ARG username=${username:-gabriel}
ARG groupname=${groupname:-arcans}
ARG backup_mnt_location='/mnt/n'
# mount w drive - set up drive w in windows using https://allthings.how/how-to-partition-a-hard-drive-on-windows-11/
# RUN sudo mkdir /mnt/n && sudo mount -t drvfs w: /mnt/n

# set up basic utils
RUN apt-get update -yq && \
    apt-get upgrade -y && \
    # install github, build-essentials, libssl, etc
    apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip nvi apt-transport-https software-properties-common 
RUN python3 -m pip install --upgrade pip cryptography oauthlib pyjwt setuptools wheel

# # set up group/user 
# RUN addgroup --system --gid 1001 ${groupname} && \
#     adduser --system --home /home/${username} --shell /bin/bash --uid 1001 --gid 1001 --disabled-password ${username}  
# set up groups
RUN addgroup --gid 111 ${groupname} && \
    addgroup --gid 888 halos && \
    addgroup --gid 666 horns 

RUN adduser --home /home/${username} --shell /bin/bash --uid 1011 --disabled-password ${username}

# make default user 
RUN echo "[user]\ndefault=devel" >> /etc/wsl.conf

# custom user setup
USER ${username}
# enable cdir on nonroot shell - an absolute lifesaver for speedy nav in an interactive cli (cannot be root for install)
# also add powershell alias
RUN pip3 install cdir --user && \
    echo "export WSL_DISTRO_NAME=\$WSL_DISTRO_NAME\nexport _NIX_MNT_LOCATION='${backup_mnt_location}'\nalias cdir='source cdir.sh'\nalias grep='grep --color=auto'\nalias powershell=pwsh\nalias vi='vi -c \"set verbose showmode\"'" >> ~/.bashrc
# add common paths
ENV PATH="$PATH:~/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts"
# switch back to root to setup
USER root

# add devel and host users using custom user setup
RUN adduser --system --home /home/host --shell /bin/bash --uid 888 --disabled-password host
RUN adduser --system --home /home/devel --shell /bin/bash --uid 666 --disabled-password devel

# enable regexp matching
# RUN shopt -s extglob && \
RUN cp -r ./home/${username}/.local/bin /usr/local && \
    cp -r /home/${username}/. /etc/skel/ && \
    cp -rp /etc/skel/. /home/devel/

# add username only to sudo
RUN usermod -aG halos host && usermod -aG halos ${username} 
RUN usermod -aG horns devel && usermod -aG horns ${username} 
RUN usermod -aG sudo ${username}

# RUN sed -e 's;^# \(%sudo.*NOPASSWD.*\);\1;g' -i /etc/sudoers
# RUN chown -R ${username}:halos /home/host
RUN chown -R host:halos /home/host
RUN chown -R devel:horns /home/devel


# need to use sudo from now on
RUN apt-get -y install sudo && \
    # add devel and ${username} to sudo group
    sudo adduser ${username} sudo 
    # uncomment to add sudo priveleges for host and devel
    # && \
    # sudo adduser devel sudo && \
    # sudo adduser host sudo

# ensure no password and sudo runs as root
RUN passwd -d ${username} && passwd -d devel && passwd -d root && passwd -l root
RUN passwd -d ${username} && passwd -d host && passwd -d root && passwd -l root

# set up /devel folder as symbolic link to /home/devel for cloning repository(ies)
RUN ln -s /home/devel /hel && chown -R devel:horns /hel
RUN touch /hel/lo.world
RUN mkdir /hel/.ssh && chmod 700 /hel/.ssh && chown -R devel:horns /hel/.ssh
# add common paths
ENV PATH="$PATH:~/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts"
USER devel
ENV PATH="$PATH:~/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts"
USER ${username}
ENV PATH="$PATH:~/.local/bin:/hel/devels-workshop/scripts:/hel/devels-workshop/devels-playground/scripts"


FROM dplay_skel AS dplay_data
RUN \
if [ -d "/gabriel" ]; then \
    if [ ! -f "/gabriel/backup-docker.sh" ]; then \
            echo "#!/bin/bash " >> /gabriel/backup-docker.sh \
    fi  \
fi

RUN echo "# # # # Docker # # # # " >> /gabriel/backup-docker.sh
RUN sudo ./gabriel/backup-docker.sh


FROM dplay_data AS dplay_git

WORKDIR /hel
USER devel

# add safe directories
RUN git config --global --add safe.directory /home/devel
RUN git config --global --add safe.directory /hel
RUN git config --global --add safe.directory /home/devel/devels-playground
RUN git config --global --add safe.directory *
RUN git clone https://github.com/kindtek/devels-workshop
RUN cd devels-workshop && git pull && git submodule update --force --recursive --init --remote && cd ..
RUN chown devel:horns -R /home/devel/devels-workshop /home/devel/devels-workshop/.git
RUN ln -s devels-workshop dwork && ln -s devels-workshop/devels-playground dplay
# make backup script executable
RUN chmod +x dwork/mnt/backup.sh

# mount with halos ownership
USER ${username}
RUN sudo mkdir -p ${backup_mnt_location}/${username}/devel-orig && \
    sudo chown ${username}:${groupname} ${backup_mnt_location}/${username} && \
    sudo chown devel:horns ${backup_mnt_location}/${username}/devel-orig && \
    sudo cp -arf dwork/mnt/backup.sh ${backup_mnt_location}/${username}/backup-devel.sh && \
    # make rwx for owner and rx for group/others
    sudo chmod 755 -R ${backup_mnt_location}/${username} \
    echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel will delete your files if you save them in this directory. Store ALL files you care about in the gabriel directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP.txt  && \
    sudo chown ${username}:${groupname} ${backup_mnt_location}/README_ASAP.txt
    # wait to do this until we have WSL_DISTRO_NAME
    # sh ${backup_mnt_location}/backup-devel.sh


# microsoft stuff
FROM dplay_git as dplay_phell

# for powershell install - https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.3
## Download the Microsoft repository GPG keys
USER ${username}
RUN sudo wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"

## Register the Microsoft repository GPG keys
RUN sudo dpkg -i packages-microsoft-prod.deb
RUN sudo rm packages-microsoft-prod.deb
RUN sudo apt-get update -yq && \
    sudo apt-get install -y powershell dotnet-sdk-7.0

# for docker in docker
FROM dplay_phell as dplay_dind
USER root
# for docker install - https://docs.docker.com/engine/install/ubuntu/
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# DOCKER
RUN apt-get update && apt-get install -y docker-compose-plugin docker-ce docker-ce-cli containerd.io 

USER devel
RUN echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && . ~/.bashrc

USER ${username}
RUN echo "export DOCKER_HOST=tcp://localhost:2375" >> ~/.bashrc && . ~/.bashrc


# for heavy gui (wsl2 required)
FROM dplay_dind as dplay_gui
USER root
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list

# in order to get 'brave-browser' to work you may need to run 'brave-browser --disable-gpu'
RUN apt-get update -yq && \
    apt-get install -y brave-browser 

RUN cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old
# change last line of this file - fix for brave-browser displaying empty windows
RUN head -n -1 /opt/brave.com/brave/brave-browser.old > /opt/brave.com/brave/brave-browser
# orig: "$HERE/brave" "$@" " --disable-gpu " || true
RUN echo '"$HERE/brave" "$@" " --disable-gpu " || true' >> /opt/brave.com/brave/brave-browser
    
# GNOME
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install gnome-session gdm3 gimp gedit nautilus vlc x11-apps xfce4
USER ${username}

FROM dplay_gui as dplay_cuda
# CUDA
RUN sudo apt-get -y install nvidia-cuda-toolkit
