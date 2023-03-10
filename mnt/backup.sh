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

if [ -d "$HEL_DESTINATION" ]
then 
    export VERSION_CONTROL=numbered; mv $HEL_DESTINATION $HEL_DESTINATION.old
fi

mkdir -p $HEL_DESTINATION
cp -arf /home/devel $HEL_DESTINATION

echo "removing script $HEL_RESTORE_SCRIPT ..."

rm $HEL_RESTORE_SCRIPT

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo
source /home/devel/.bashrc
cp -arf $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME /home/devel-$WSL_DISTRO_NAME.restored
mv /home/devel /home/devel.old
mv /home/devel-$WSL_DISTRO_NAME.restored /home/devel" >> $HEL_RESTORE_SCRIPT

chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
