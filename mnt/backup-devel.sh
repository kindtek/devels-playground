#!/bin/bash

backup_mnt_location=${1:-/mnt/data}
_GABRIEL=${2:-gabriel}
_HALOS=${3:-halos}

if [ -z $_NIX_MNT_LOCATION ]
then 
    export _NIX_MNT_LOCATION=/mnt/data
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

sudo mkdir -p ${backup_mnt_location}/${_GABRIEL}/${_GABRIEL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GABRIEL}/${_GABRIEL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GABRIEL}/devel-orig && \
sudo mkdir -p ${backup_mnt_location}/devel/devel-orig && \
sudo chown ${_GABRIEL}:${_HALOS} ${backup_mnt_location}/${_GABRIEL} && \
sudo chown ${_GABRIEL}:${_HALOS} ${backup_mnt_location}/${_GABRIEL}/${_GABRIEL}-orig && \
sudo chown ${_GABRIEL}:halos ${backup_mnt_location}/${_GABRIEL} && \
sudo chown ${_GABRIEL}:halos ${backup_mnt_location}/${_GABRIEL}/${_GABRIEL}-orig && \
sudo chown devel:horns ${backup_mnt_location}/devel && \
sudo chown devel:horns ${backup_mnt_location}/devel/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/${_GABRIEL}/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/${_GABRIEL}/devel-orig && \
# sudo chown devel:horns ${backup_mnt_location}/${_GABRIEL} && \
sudo chown devel:horns ${backup_mnt_location}/${_GABRIEL}/devel-orig && \
sudo chown devel:horns ${backup_mnt_location}/${_GABRIEL}/devel-orig && \

# copy newly pulled backup script to mount location and home dirs
sudo cp -arf dwork/mnt/backup-gabriel.sh ${backup_mnt_location}/gabriel/backup-gabriel.sh && cp -arf dwork/mnt/backup-gabriel.sh /home/gabriel/backup-gabriel.sh  && \
sudo cp -arf dwork/mnt/backup-custom.sh ${backup_mnt_location}/${_GABRIEL}/backup-${_GABRIEL}.sh && cp -arf dwork/mnt/backup-custom.sh /home/${_GABRIEL}/backup-${_GABRIEL}.sh && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/devel/backup-devel.sh && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/${_GABRIEL}/backup-devel.sh && cp -arf dwork/mnt/backup-devel.sh /home/${_GABRIEL}/backup-devel.sh  && \
sudo cp -arf dwork/mnt/backup-devel.sh ${backup_mnt_location}/gabriel/backup-devel.sh && cp -arf dwork/mnt/backup-devel.sh /home/gabriel/backup-devel.sh
#  # make rwx for owner and rx for group - x for others
# sudo chmod 751 -R ${backup_mnt_location}/${_GABRIEL} && \
# sudo chmod 755 ${backup_mnt_location}/${_GABRIEL} && \
# sudo chmod 751 -R ${backup_mnt_location}/gabriel && \
# sudo chmod 755 ${backup_mnt_location}/gabriel && \
# sudo chmod 751 -R ${backup_mnt_location}/devel && \
# # # add warning for the backup drive
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/${_GABRIEL}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GABRIEL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/gabriel/README_ASAP      && \
# sudo chown ${_GABRIEL}:${_HALOS} ${backup_mnt_location}/README_ASAP

HEL_DESTINATION="$_NIX_MNT_LOCATION/${_GABRIEL}/devel-$WSL_DISTRO_NAME"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/devel/restore-devel-$WSL_DISTRO_NAME.sh"
HEL_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/gabriel/restore-devel-$WSL_DISTRO_NAME.sh"


echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

# mkdir -p $HEL_DESTINATION
cp -arf --backup=$VERSION_CONTROL --update /home/devel $HEL_DESTINATION

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel to /home ...'
cp --backup=$VERSION_CONTROL --remove-destination -arf $_NIX_MNT_LOCATION/gabriel/devel-$WSL_DISTRO_NAME/devel /home" > $HEL_RESTORE_SCRIPT

chown devel:horns $HEL_RESTORE_SCRIPT
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
