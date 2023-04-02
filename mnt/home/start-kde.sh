#!/bin/bash
su good
sudo /etc/init.d/xrdp start
port_num=${1:-3390}
pwsh -Command /mnt/c/Windows/system32/mstsc.exe default.rdp /v:localhost:$port_num /admin /f /multimon || echo '
oops. no gui

 ¯\_(ツ)_/¯
'
