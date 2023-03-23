############################# Latest Release Candidate #######################################
_GBL=${_GBL:-gbl}
cd /home/${_GBL}/dls && sudo rm -rf linux linux-6.3-rc3 && \
wget https://git.kernel.org/torvalds/t/linux-6.3-rc3.tar.gz && \
tar -xvf linux-6.3-rc3.tar.gz && \
mv linux-6.3-rc3 linux && \
cd linux && \
kernel_tag=c

# wsl_username=$(wslvar USERNAME)
sudo cp /hel/devels-work/devels-play/kernel/6_3-rc/amd/.config_0 .config && \
sudo chown $LOGNAME:$(id -gn) .config && \
yes "" | sudo make prepare scripts && \
sudo make -j16 && sudo make modules_install && \
sudo mkdir -p ../../../${_GBL}/kernels/6_3-rc/amd && sudo cp -f arch/x86/boot/bzImage ../../../${_GBL}/kernels/6_3-rc/amd/linux-6_3rc_$kernel_tag && \
sudo mkdir -p ../../../dvl/kernels/6_3-rc/amd && sudo cp -f arch/x86/boot/bzImage ../../../dvl/devels-work/devels-play/kernel/6_3-rc/amd/linux-6_3rc_0 && \
sudo cp -f arch/x86/boot/bzImage ../../../dvl/kernels/6_3-rc/amd/linux-6_3rc_0 && \
sudo cp arch/x86/boot/bzImage /mnt/c/users/$wsl_username/linux-6_3rc_$kernel_tag
