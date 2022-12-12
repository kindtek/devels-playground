# to build, for exemple, run: 
# `username=mine groupname=ours docker run -d -i`
FROM alpine:latest AS dbp_skinny
ARG username=${username:-dev0}
ARG groupname=${groupname:-dev}
RUN addgroup -S ${groupname} && adduser -S -s /bin/ash -h /home/${username} -G ${groupname} ${username}
# set up group/user 
# RUN addgroup --system --gid 1000 ${groupname} && \
#   adduser --system --home /home/${username} --shell /bin/bash --uid 1000 --gid 1000 --disabled-password ${username}
# 
# make default user
RUN echo -e "[user]\ndefault=${username}" >> /etc/wsl.conf
# ensure no passwd
RUN passwd -d ${username} && \
  apk update && \
  apk upgrade && \
# install github, build-essentials, libssl, etc
  apk add git github-cli build-base libressl-dev ca-certificates wget curl gnupg lsb-release python3 py3-pip
USER ${username}
# install cdir - an absolute lifesaver for speedy nav in an interactive cli (cannot be root for install)
RUN PATH=/home/${username}/.local/bin:$PATH
RUN pip3 install cdir --user && \
  echo "alias cdir='source cdir.sh'" >> ~/.bashrc
USER root
RUN cp -r /home/${username}/.local/bin /usr/local
# ${username} will need to use sudo from now on
RUN apk add sudo
# RUN sudo adduser ${username} sudo
USER ${username}
WORKDIR /home/${username}

FROM dbp_skinny AS dbp_phat-dockerless
USER root
RUN sudo apk add dpkg gnupg
# TODO: make brave work
# for brave install - https://linuxhint.com/install-brave-browser-alpine/
# RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
# for docker install - https://docs.docker.com/engine/install/alpine/
# RUN sudo mkdir -p /etc/apt/keyrings && \
#   curl -fsSL https://download.docker.com/linux/alpine/gnupg | sudo gnupg --dearmor -o /etc/apt/keyrings/docker.gpg
# RUN echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/alpine \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# brave browser/gui/media/docker support
# RUN apk update && \
#   apk add gedit gimp nautilus vlc x11-apps apt-transport-https brave-browser
USER ${username}

# TODO: https://github.com/mbacchi/brave-docker

FROM dbp_phat-dockerless as dbp_phat
COPY --chown=0:0 --from=alpinelinux/docker-alpine . .
# RUN sudo -S apk add docker-ce docker-ce-cli containerd.io docker-compose-plugin
