if [ -z $_NIX_MNT_LOCATION ]
then 
    export _NIX_MNT_LOCATION=/mnt/n
fi
if [ -z $WSL_DISTRO_NAME ] 
then
    export WSL_DISTRO_NAME=orig
fi
if [ ! -z $1 ]
then
    HALO_DESTINATION="$_NIX_MNT_LOCATION/$1/devel-$WSL_DISTRO_NAME";
    HALO_RESTORE_SCRIPT="$_NIX_MNT_LOCATION/$1/restore-devel-$WSL_DISTRO_NAME.sh";

    echo "backing the /halo up to: $HALO_DESTINATION ...";

    export VERSION_CONTROL=numbered;

    mkdir -p $HALO_DESTINATION;
    cp -arf --backup=$VERSION_CONTROL --update /home/devel $HALO_DESTINATION;

    echo "creating restore script and saving as $HALO_RESTORE_SCRIPT ...";

    echo "#!/bin/bash;
    # run as sudo

    echo 'restoring $_NIX_MNT_LOCATION/$1/devel-$WSL_DISTRO_NAME/devel to /home ...';
    cp --backup=$VERSION_CONTROL --remove-destination -arf $_NIX_MNT_LOCATION/$1/devel-$WSL_DISTRO_NAME/devel /home" > $HALO_RESTORE_SCRIPT;

    chown devel:horns $HALO_RESTORE_SCRIPT;
    chmod +x $HALO_RESTORE_SCRIPT;

    echo "Backup complete.";
fi
