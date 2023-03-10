#!/bin/bash

source /home/devel/.bashrc

if [ -z $_NIX_MNT_LOCATION ]
then 
    # set $_MNT_LOCATION here if desired
    exit
elif [ -z $WSL_DISTRO_NAME ] 
then
    exit
fi

HEL_DESTINATION="$_NIX_MNT_LOCATION/devel-$WSL_DISTRO_NAME"
HEL_BACKUP_SCRIPT="$_NIX_MNT_LOCATION/backup-$WSL_DISTRO_NAME.sh"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/restore-$WSL_DISTRO_NAME.sh"

echo "backing up hel to: $HEL_DESTINATION ..."

if [ -d "$HEL_DESTINATION" ]
then 
    export VERSION_CONTROL=numbered; mv $HEL_DESTINATION $HEL_DESTINATION.old
fi

cp -arf /home/devel $HEL_DESTINATION

echo "removing script $HEL_RESTORE_SCRIPT ..."

rm $HEL_RESTORE_SCRIPT

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo
source /home/devel/.bashrc
cp -arf $_NIX_MNT_LOCATION/devel-$WSL_DISTRO_NAME /home/devel-$WSL_DISTRO_NAME.restored
mv /home/devel /home/devel.old
mv /home/devel-$WSL_DISTRO_NAME.restored /home/devel" >> $HEL_RESTORE_SCRIPT

chmod +x $HEL_RESTORE_SCRIPT