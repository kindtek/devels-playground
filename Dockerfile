# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM ubuntu:latest AS dbp-essential
ARG username
ARG groupname
RUN apt-get update -yq && \
apt-get upgrade -y && \
apt-get install -y build-essential sudo && \
addgroup --system --gid 1000 ${group:-dev} && \
adduser --system --home /home/${username:-dev0} --shell /bin/bash --uid 1000 --gid 1000 --disabled-password ${username:-dev0} 
# biggest headache saver of all time - https://www.tecmint.com/cdir-navigate-folders-and-files-on-linux/
RUN sudo apt install -y python3 python3-pip && \
pip3 install cdir --user
RUN echo "alias cdir='source cdir.sh'" >> ~/.bashrc \
source ~/.bashrc
# no time for passwords since this is a dev environment but a sudo guardrail is nice
RUN sudo usermod -aG sudo ${username:-dev0} 
RUN echo -e "[user]\ndefault=${username:-dev0}" >> /etc/wsl.conf
RUN sudo passwd -d ${username:-dev0}

FROM dbp-essential AS dbp-git
RUN sudo apt-get update -y && \
apt-get install -y git gh

