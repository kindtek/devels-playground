# to build, run: `username=mine groupname=ours docker run -d -i 
FROM Ubuntu:latest AS kindtek/dbp
ARG username
ARG groupname
RUN apt-get update -yq && \
apt-get upgrade && \
apt-get install -y build-essential sudo && \
addgroup --system --gid 1000 ${group:-dev} && \
adduser --system --home /home/${username:-dev0} --shell /bin/bash --uid 1000 --gid 1000 --disabled-password ${username:-dev0} 
RUN apt install python3 python3-pip && \
pip3 install cdir --user
RUN echo "alias cdir='source cdir.sh'" >> ~/.bashrc && \
source ~/.bashrc

# no time for passwords since this is a dev environment but a sudo guardrail is nice
sudo usermod -aG sudo ${username:-dev0} 

echo -e "[user]\ndefault=${username:-dev0}" >> /etc/wsl.conf
sudo passwd -d ${username:-dev0}
