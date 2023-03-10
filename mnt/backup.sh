#!/bin/bash

if [ -z $_NIX_MNT_LOCATION ]
then 
    export _NIX_MNT_LOCATION='/mnt/n'
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

HEL_DESTINATION="$_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/gabriel/restore-devel-$WSL_DISTRO_NAME.sh"

echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

mkdir -p $HEL_DESTINATION
cp -arf --backup=$VERSION_CONTROL --update /home/devel $HEL_DESTINATION

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel to /home ...'
cp --backup=$VERSION_CONTROL --remove-destination -arf $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel /home" > $HEL_RESTORE_SCRIPT

chown devel:devels $HEL_RESTORE_SCRIPT
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
