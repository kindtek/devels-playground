############################## STABLE 6.2.7 KERNEL ######################################

_GBL=${_GBL:-gbl}
cd /home/${_GBL}/dls && sudo rm -rf linux-6.2.7
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.7.tar.xz
tar -xvf linux-6.2.7.tar.xz
mv linux-6.2.7 linux
cd linux
kernel_tag=f

wsl_username=$(wslvar USERNAME)
sudo cp /home/dvl/devels-work/devels-play/kernel/6_27/amd/.config_0 .config && \
sudo chown $LOGNAME:$(id -gn) .config && \
yes "" | sudo make prepare scripts && \
sudo sed -i 's/\# CONFIG_ZFS is not set/CONFIG_ZFS=y/g' .config && echo grep ZFS .config && \
yes "" | sudo make -j16 && sudo make modules_install && \
sudo mkdir -p ../../../${_GBL}/kernels/6_27/amd && sudo cp -f arch/x86/boot/bzImage ../../../${_GBL}/kernels/6_27_0/amd/linux-6_27_0$kernel_tag && \
sudo mkdir -p ../../../dvl/kernels/6_27/amd && sudo cp -f arch/x86/boot/bzImage ../../../dvl/devels-work/devels-play/kernel/6_27/amd/linux-6_27_0 && \
sudo cp -f arch/x86/boot/bzImage ../../../dvl/kernels/6_27/amd/linux-6_27_0 && \
sudo cp arch/x86/boot/bzImage /mnt/c/users/$wsl_username/linux-6_27_0$kernel_tag

