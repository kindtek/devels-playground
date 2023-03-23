_AGL=${_AGL:-agl}

############################## ZFS 6.2.7 KERNEL ######################################

_AGL=${_AGL:-agl}
cd /home/${_AGL}/dls
wget https://github.com/openzfs/zfs/releases/download/zfs-2.1.9/zfs-2.1.9.tar.gz
tar -xvf zfs-2.1.9.tar.gz
mv zfs-2.1.9 zfs
cd /home/${_AGL}/dls && sudo rm -rf linux-6.2.7
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.7.tar.xz
tar -xvf linux-6.2.7.tar.xz
mv linux-6.2.7 linux
cd linux
kernel_tag=b

sudo apt install build-essential flex bison libssl-dev libelf-dev git dwarves
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
mv WSL2-Linux-Kernel wsl2
cd wsl2
# cp Microsoft/config-wsl .config
# make -j $(expr $(nproc) - 1)
wsl_username=$(wslvar USERNAME)
sudo cp /home/dvl/devels-work/devels-play/kernel/amd/5_1519/.config_zfs .config && \
sudo chown $LOGNAME:$(id -gn) .config && \

yes "" | sudo make prepare scripts && \
cd ../zfs && sudo sh autogen.sh && \
sudo sh configure --prefix=/ --libdir=/lib --includedir=/usr/include --datarootdir=/usr/share --enable-linux-builtin=yes --with-linux=/hal/dls/wsl2 --with-linux-obj=/hal/dls/wsl2 && \
sudo sh copy-builtin ../wsl2 && \
yes "" | sudo make install  && \
cd ../wsl2/ && sudo sed -i 's/\# CONFIG_ZFS is not set/CONFIG_ZFS=y/g' .config && echo grep ZFS .config && \
yes "" | sudo make -j16 && sudo make modules_install && \
sudo mkdir -p ../../../${_AGL}/kernels && sudo cp -f arch/x86/boot/bzImage ../../../${_AGL}/kernels/amd/5_1519/linux-5_1519_z$kernel_tag && \
sudo mkdir -p ../../../dvl/kernels && sudo cp -f arch/x86/boot/bzImage ../../../dvl/kernels/amd/5_1519/linux-5_1519_zfs && \
sudo cp -f arch/x86/boot/bzImage ../../../dvl/kernels/5_1519/amd/linux-5_1519_0 && \
sudo cp arch/x86/boot/bzImage /mnt/c/users/$wsl_username/amd/5_1519/linux-5_1519_z$kernel_tag
 
# RUN sudo systemctl unmask snapd.service && sudo systemctl enable snapd.service && sudo systemctl start snapd.service && \
#     sudo snap install lxd 


