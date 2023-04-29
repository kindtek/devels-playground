if [ ! -f ]
    sudo cp /mnt/data/%HOME%/KEX-GUI.rdp /mnt/c/
fi
kex --win --start-client --sound
# stop: kex --win --stop