#!/bin/bash

backup_mnt_location=${1:-/mnt/data}
_GBL=${2:-gbl}
_HALOS=${3:-halos}

if [ -z $backup_mnt_location ]
then 
    export backup_mnt_location=/mnt/data
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

sudo mkdir -p ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo mkdir -p ${backup_mnt_location}/${_GBL}/dvl-orig && \
sudo mkdir -p ${backup_mnt_location}/dvl/dvl-orig && \
sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/${_GBL} && \
sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo chown ${_GBL}:halos ${backup_mnt_location}/${_GBL} && \
sudo chown ${_GBL}:halos ${backup_mnt_location}/${_GBL}/${_GBL}-orig && \
sudo chown dvl:horns ${backup_mnt_location}/dvl && \
sudo chown dvl:horns ${backup_mnt_location}/dvl/dvl-orig && \
# sudo chown dvl:horns ${backup_mnt_location}/${_GBL}/dvl-orig && \
sudo chown dvl:horns ${backup_mnt_location}/${_GBL}/dvl-orig && \
# sudo chown dvl:horns ${backup_mnt_location}/${_GBL} && \
sudo chown dvl:horns ${backup_mnt_location}/${_GBL}/dvl-orig && \
sudo chown dvl:horns ${backup_mnt_location}/${_GBL}/dvl-orig && \

# copy newly pulled backup script to mount location and home dirs
sudo cp -arfv dwork/mnt/backup-gbl.sh ${backup_mnt_location}/gbl/backup-gbl.sh && cp -arfv dwork/mnt/backup-gbl.sh /home/gbl/backup-gbl.sh  && \
sudo cp -arfv dwork/mnt/backup-custom.sh ${backup_mnt_location}/${_GBL}/backup-${_GBL}.sh && cp -arfv dwork/mnt/backup-custom.sh /home/${_GBL}/backup-${_GBL}.sh && \
sudo cp -arfv dwork/mnt/backup-dvl.sh ${backup_mnt_location}/dvl/backup-dvl.sh && \
sudo cp -arfv dwork/mnt/backup-dvl.sh ${backup_mnt_location}/${_GBL}/backup-dvl.sh && cp -arfv dwork/mnt/backup-dvl.sh /home/${_GBL}/backup-dvl.sh  && \
sudo cp -arfv dwork/mnt/backup-dvl.sh ${backup_mnt_location}/gbl/backup-dvl.sh && cp -arfv dwork/mnt/backup-dvl.sh /home/gbl/backup-dvl.sh
#  # make rwx for owner and rx for group - x for others
# sudo chmod 751 -R ${backup_mnt_location}/${_GBL} && \
# sudo chmod 755 ${backup_mnt_location}/${_GBL} && \
# sudo chmod 751 -R ${backup_mnt_location}/gbl && \
# sudo chmod 755 ${backup_mnt_location}/gbl && \
# sudo chmod 751 -R ${backup_mnt_location}/dvl && \
# # # add warning for the backup drive
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/${_GBL}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${_GBL}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/gbl/README_ASAP      && \
# sudo chown ${_GBL}:${_HALOS} ${backup_mnt_location}/README_ASAP

HEL_DESTINATION="$backup_mnt_location/${_GBL}/dvl-$WSL_DISTRO_NAME"
HEL_RESTORE_SCRIPT="$backup_mnt_location/dvl/restore-dvl-$WSL_DISTRO_NAME.sh"
HEL_RESTORE_SCRIPT="$backup_mnt_location/gbl/restore-dvl-$WSL_DISTRO_NAME.sh"


echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

# mkdir -p $HEL_DESTINATION
cp -arfv --backup=$VERSION_CONTROL --update /home/dvl $HEL_DESTINATION

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/gbl/dvl-$WSL_DISTRO_NAME/dvl to /home ...'
cp --backup=$VERSION_CONTROL --remove-destination -arfv $_NIX_MNT_LOCATION/gbl/dvl-$WSL_DISTRO_NAME/dvl /home" > $HEL_RESTORE_SCRIPT

chown dvl:horns $HEL_RESTORE_SCRIPT
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
