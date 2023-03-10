#!/bin/bash
source /home/devel/.bashrc

HEL_DESTINATION="/mnt/w/devel-$WSL_DISTRO_NAME"
HEL_BACKUP_SCRIPT="/mnt/w/backup-$WSL_DISTRO_NAME"

echo "backing up hel to: $HEL_DESTINATION"

cp -arf /home/devel $HEL_DESTINATION
rm -f /mnt/w/

echo "creating restore script and saving as $HEL_BACKUP_SCRIPT"

echo "#!/bin/bash
# run as sudo
cp -arf /mnt/w/devel /home/devel.restored
mv /home/devel /home/devel.old
mv /home/devel.restored /home/devel" >> $HEL_BACKUP_SCRIPT