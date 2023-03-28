#!/bin/bash

backup_mnt_location=${1:-/mnt/data}
username=${2:-agl}
groupname=${3:-halo}

if [ -z $backup_mnt_location ]
then 
    export backup_mnt_location=/mnt/data/bak
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi

sudo mkdir -p ${backup_mnt_location}/${username}/${username}-orig && \
sudo mkdir -p ${backup_mnt_location}/${username}/${username}-orig && \
sudo mkdir -p ${backup_mnt_location}/${username}/dvl-orig && \
sudo mkdir -p ${backup_mnt_location}/dvl/dvl-orig && \
sudo chown ${username}:${groupname} ${backup_mnt_location}/${username} && \
sudo chown ${username}:${groupname} ${backup_mnt_location}/${username}/${username}-orig && \
sudo chown ${username}:halo ${backup_mnt_location}/${username} && \
sudo chown ${username}:halo ${backup_mnt_location}/${username}/${username}-orig && \
sudo chown dvl:hell ${backup_mnt_location}/dvl && \
sudo chown dvl:hell ${backup_mnt_location}/dvl/dvl-orig && \
# sudo chown dvl:hell ${backup_mnt_location}/${username}/dvl-orig && \
sudo chown dvl:hell ${backup_mnt_location}/${username}/dvl-orig && \
# sudo chown dvl:hell ${backup_mnt_location}/${username} && \
sudo chown dvl:hell ${backup_mnt_location}/${username}/dvl-orig && \
sudo chown dvl:hell ${backup_mnt_location}/${username}/dvl-orig && \

# copy newly pulled backup script to mount location and home dirs
sudo cp -arfv dvlw/mnt/backup-agl.sh ${backup_mnt_location}/agl/backup-agl.sh && cp -arfv dvlw/mnt/backup-agl.sh /home/agl/backup-agl.sh  && \
sudo cp -arfv dvlw/mnt/backup-custom.sh ${backup_mnt_location}/${username}/backup-${username}.sh && cp -arfv dvlw/mnt/backup-custom.sh /home/${username}/backup-${username}.sh && \
sudo cp -arfv dvlw/mnt/backup-dvl.sh ${backup_mnt_location}/dvl/backup-dvl.sh && \
sudo cp -arfv dvlw/mnt/backup-dvl.sh ${backup_mnt_location}/${username}/backup-dvl.sh && cp -arfv dvlw/mnt/backup-dvl.sh /home/${username}/backup-dvl.sh  && \
sudo cp -arfv dvlw/mnt/backup-dvl.sh ${backup_mnt_location}/agl/backup-dvl.sh && cp -arfv dvlw/mnt/backup-dvl.sh /home/agl/backup-dvl.sh
#  # make rwx for owner and rx for group - x for others
# sudo chmod 751 -R ${backup_mnt_location}/${username} && \
# sudo chmod 755 ${backup_mnt_location}/${username} && \
# sudo chmod 751 -R ${backup_mnt_location}/agl && \
# sudo chmod 755 ${backup_mnt_location}/agl && \
# sudo chmod 751 -R ${backup_mnt_location}/dvl && \
# # # add warning for the backup drive
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/${username}/README_ASAP      && \
# echo "!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!\n\nThe devel can/will delete your files if you save them in this directory. Keep files out of the devels grasp and in the *${username}* sub-directory.\n\n!!!!!!!!!!!!!!!!DO NOT SAVE YOUR FILES IN THIS DIRECTORY!!!!!!!!!!!!!!!!" | sudo tee ${backup_mnt_location}/agl/README_ASAP      && \
# sudo chown ${username}:${groupname} ${backup_mnt_location}/README_ASAP

HEL_DESTINATION="$backup_mnt_location/${username}/dvl-$WSL_DISTRO_NAME"
HEL_RESTORE_SCRIPT="$backup_mnt_location/dvl/restore-dvl-$WSL_DISTRO_NAME.sh"
# HEL_RESTORE_SCRIPT="$backup_mnt_location/agl/restore-dvl-$WSL_DISTRO_NAME.sh"


echo "backing the /hel up to: $HEL_DESTINATION ..."

export VERSION_CONTROL=numbered

# mkdir -p $HEL_DESTINATION
cp -arfv --backup=$VERSION_CONTROL --update /home/dvl $HEL_DESTINATION

echo "creating restore script and saving as $HEL_RESTORE_SCRIPT ..."

echo "#!/bin/bash
# run as sudo

echo 'restoring $_NIX_MNT_LOCATION/agl/dvl-$WSL_DISTRO_NAME/dvl to /home ...'
cp --backup=$VERSION_CONTROL --remove-destination -arfv $_NIX_MNT_LOCATION/agl/dvl-$WSL_DISTRO_NAME/dvl /home" > $HEL_RESTORE_SCRIPT

chown dvl:hell $HEL_RESTORE_SCRIPT
chmod +x $HEL_RESTORE_SCRIPT

echo "Backup complete."
