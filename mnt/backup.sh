#!/bin/bash

source /home/devel/.bashrc

if [ -z $_NIX_MNT_LOCATION ]
then 
    export _NIX_MNT_LOCATION='/mnt/n'
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

HEL_DESTINATION="$_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME"
HEL_BACKUP_SCRIPT="$_NIX_MNT_LOCATION/gabriel/backup-devel-$WSL_DISTRO_NAME.sh"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/gabriel/restore-devel-$WSL_DISTRO_NAME.sh"

echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

mkdir -p $HEL_DESTINATION
cp -arf --backup=$VERSION_CONTROL --update /home/devel $HEL_DESTINATION

echo "removing script $HEL_RESTORE_SCRIPT ..."

rm $HEL_RESTORE_SCRIPT

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo
source /home/devel/.bashrc

echo 'copying $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME to /home/devel-$WSL_DISTRO_NAME.restored ...'

echo 'moving /home/devel to home/devel.old ...'
mv --backup --version-control=$VERSION_CONTROL /home/devel /home/devel.old

echo 'restoring $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel to /home/devel ...'
cp --backup --version-control=$VERSION_CONTROL -arf $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel /home/devel" >> $HEL_RESTORE_SCRIPT

chown ${username:-gabriel}:${groupname:-arcans} "/home/devel-$WSL_DISTRO_NAME.restored"
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
