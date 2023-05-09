#!/bin/bash
sudo apt-get update -y && sudo apt-get -y upgrade
win_user=${1:-'no-user-selectedlkadjfasdf'}
port_num=${2:-3390}

while [ ! -d "/mnt/c/users/$win_user" ]; do
    echo " 


    save connection to which Windows home directory?

        C:\\users\\__________\\Kubuntu-GUI.rdp 

        choose from:
    " 
    ls -da /mnt/c/users/*/ | tail -n +4 | sed -r -e 's/^\/mnt\/c\/users\/([ A-Za-z0-9]*)*\/+$/\t\1/g'
    read -r -p "
" win_user
done
sudo /etc/init.d/xrdp start
if [ ! -f "/mnt/c/users/$win_user/KEX-GUI.rdp" ]; then
    sudo cp /mnt/data/HOME%/KEX-GUI.rdp /mnt/c/users/$win_user/KEX-GUI.rdp
fi
pwsh -Command /mnt/c/Windows/system32/mstsc.exe /mnt/c/"$win_user"/Kubuntu-GUI.rdp /v:localhost:"$port_num" /admin /f /multimon || echo '
oops. no gui

 ¯\_(ツ)_/¯
'

kex --win --start-client --sound
# stop: kex --win --stop