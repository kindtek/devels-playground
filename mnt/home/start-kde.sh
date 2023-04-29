#!/bin/bash
sudo apt-get update -y && sudo apt-get -y upgrade
sudo /etc/init.d/xrdp start
if [ ! -f ]
    sudo cp /mnt/data/%HOME%/Kubuntu-GUI.rdp /mnt/c/
fi
port_num=${1:-3390}
pwsh -Command /mnt/c/Windows/system32/mstsc.exe default.rdp /v:localhost:$port_num /admin /f /multimon || echo '
oops. no gui

 ¯\_(ツ)_/¯
'
