sudo apt-get install -y snapd daemonize
sudo daemonize /usr/bin/unshare --fork --pid --mount-proc /lib/systemd/systemd --system-unit=basic.target
sleep 8
exec sudo nsenter -t $(pidof systemd) -a su - $LOGNAME

sudo apt-get install -y autoconf automake libtool gawk alien apt-utils fakeroot dkms libblkid-dev uuid-dev libudev-dev \
    zlib1g-dev libaio-dev libattr1-dev libelf-dev python3-cffi libffi-dev flex bison bc dbus-user-session fontconfig

sudo apt-get -y remove zfsutils-linux zlib1g-dev zfs-dkms zstd zsys zfs-dracut zfs-zed

wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.7.tar.xz
tar -xvf linux-6.2.7.tar.xz
mv linux-6.2.7 linux
cd linux

wget https://github.com/openzfs/zfs/releases/download/zfs-2.1.9/zfs-2.1.9.tar.gz
tar -xvf zfs-2.1.9.tar.gz
mv zfs-2.1.9 zfs

# sudo apt install build-essential flex bison libssl-dev libelf-dev git dwarves
# git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
# mv WSL2-Linux-Kernel wsl2
# cd wsl2
# cp Microsoft/config-wsl .config
# make -j $(expr $(nproc) - 1)
wsl_username=$(wslvar USERNAME)
sudo cp /home/dvl/devels-work/devels-play/kernel/5_1519/.config_zfs .config && \
sudo chown $LOGNAME:$(id -gn) .config && \

yes "" | sudo make prepare scripts && \
cd ../zfs && sudo sh autogen.sh && \
sudo sh configure --prefix=/ --libdir=/lib --includedir=/usr/include --datarootdir=/usr/share --enable-linux-builtin=yes --with-linux=/hal/dls/wsl2 --with-linux-obj=/hal/dls/wsl2 && \
sudo sh copy-builtin ../wsl2 && \
yes "" | sudo make install  && \
cd ../wsl2/ && sudo sed -i 's/\# CONFIG_ZFS is not set/CONFIG_ZFS=y/g' .config && echo grep ZFS .config && \
yes "" | sudo make -j16 && sudo make modules_install && \
sudo mkdir -p ../../../gbl/kernels && sudo cp -f arch/x86/boot/bzImage ../../../gbl/kernels/linux-kernel-627a0 && \
sudo cp arch/x86/boot/bzImage /mnt/c/users/$wsl_username/linux-kernel-627a0
 
# RUN sudo systemctl unmask snapd.service && sudo systemctl enable snapd.service && sudo systemctl start snapd.service && \
#     sudo snap install lxd 