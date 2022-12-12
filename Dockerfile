# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM ubuntu:latest AS dbp_base
ARG username=${username:-dev0}
ARG groupname=${groupname:-dev}
# set up group/user 

RUN addgroup --system --gid 1000 ${groupname} && \
  adduser --system --home /home/${username} --shell /bin/bash --uid 1000 --gid 1000 --disabled-password ${username}
# 
# make default user
RUN echo -e "[user]\ndefault=${username}" >> /etc/wsl.conf
RUN apt-get update -yq && \
apt-get upgrade -y && \
# install build-essentials
apt-get install -y build-essential
# best browser ever
# snapd
# RUN snap install brave

RUN passwd -d ${username} && \
# we will need to use sudo from now on
apt-get -y install sudo && \
sudo adduser ${username} sudo

USER ${username}
# biggest headache saver of all time - https://github.com/EskelinenAntti/cdir
RUN sudo apt-get install -y python3 python3-pip && \
  sudo pip3 install cdir --user
  # best browser of all time
  # sudo apt-get install -y brave-browser

# RUN echo "alias cdir='source cdir.sh'" >> ~/.bashrc && source ~/.bashrc


FROM dbp_base AS dbp_git
RUN sudo apt-get update -y && \
sudo apt-get install -y git gh

FROM dbp_git AS dbp_docker-git
# https://docs.docker.com/engine/install/ubuntu/
RUN sudo apt-get update -y &&  \
sudo apt-get install -y ca-certificates curl gnupg lsb-release
RUN sudo mkdir -p /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
