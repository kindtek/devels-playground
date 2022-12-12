# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM ubuntu:latest AS dbp_skinny
ARG username=${username:-dev0}
ARG groupname=${groupname:-dev}
# set up group/user 
RUN addgroup --system --gid 1000 ${groupname} && \
  adduser --system --home /home/${username} --shell /bin/bash --uid 1000 --gid 1000 --disabled-password ${username}
# 
# make default user
RUN echo -e "[user]\ndefault=${username}" >> /etc/wsl.conf
# ensure no passwd
RUN passwd -d ${username} && \
  apt-get update -yq && \
  apt-get upgrade -y && \
  # install github, build-essentials, libssl, etc
  apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip alpine-pkg-glibc musl
USER ${username}
# install cdir - an absolute lifesaver for speedy nav in an interactive cli (cannot be root for install)
RUN PATH=/home/${username}/.local/bin:$PATH
RUN pip3 install cdir --user && \
  echo "alias cdir='source cdir.sh'" >> ~/.bashrc
USER root
RUN mv /home/${username}/.local/bin /usr/local
# ${username} will need to use sudo from now on
RUN apt-get -y install sudo && \
  sudo adduser ${username} sudo
USER ${username}
WORKDIR /home/${username}

FROM dbp_skinny AS dbp_phat-dockerless
USER root
# for brave install - https://linuxhint.com/install-brave-browser-ubuntu22-04/
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
# for docker install - https://docs.docker.com/engine/install/ubuntu/
RUN sudo mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# brave browser/gui/media/docker support
RUN apt update -yq && \
  apt-get install -y gedit gimp nautilus vlc x11-apps apt-transport-https brave-browser
USER ${username}

# TODO: https://github.com/mbacchi/brave-docker

FROM dbp_phat-dockerless as dbp_phat
RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
