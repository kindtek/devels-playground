#!/bin/bash
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list 
sudo apt-get update && \
sudo apt-get install -y brave-browser brave-browser gnome-session lightdm locales gimp gedit nautilus vlc x11-apps xfce4
sudo update-locale 
# echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.gen && \
sudo locale-gen
sudo cp /opt/brave.com/brave/brave-browser /opt/brave.com/brave/brave-browser.old
# change last line of this file - fix for brave-browser displaying empty windows
head -n -1 /opt/brave.com/brave/brave-browser.old | sudo tee /opt/brave.com/brave/brave-browser > /dev/null
# now no longeer need to add --disable-gpu flag everytime
echo '"$HERE/brave" "$@" " --disable-gpu " || true' | sudo tee --append /opt/brave.com/brave/brave-browser > /dev/null
