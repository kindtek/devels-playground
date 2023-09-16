---
---

# Idle Minds are the **Developer's Playground**

## Import a Linux environment _virtually_ without thinking

&nbsp;

---

## NEW FEATURES

### Build a kernel and pop into a Kali GUI

### Build and customize your own kernel 

### images are built using a Dockerfile, Docker compose file, and various shell scripts

---

#### all images built with a kernel (images ending in -kernel) will include:

- the latest bleeding edge Linux kernel
- a ([script](kernels/linux/build-export-kernel.sh)) that will build a kernel with your custom .config file ([example](kernels/linux/x86/amd/5_15901/.config_wsl0)) using a filepath or url or automaticlly select the best available configuration for your architecture
- a ([script](mnt/HOME_NIX/setup.sh)) that will import your kernel into WSL and set up your system
- a ([script](kernels/linux/install-kernel.sh)) that will allow you to rotate through multiple kernel builds
- powerhell scripts to do all of the above seamlessly in windows
- enterprise grade ZFS compression/decompression tool and volume manager built into the kernel (Advanced: Even mount your Linux filesystem from a ZFS partition!)


---

---

## **INSTRUCTIONS**


---

### For all Linux users (easy)

Paste one line into a bash shell

```bash
# linux cheat code
wget -O - https://raw.githubusercontent.com/kindtek/k-home/main/HOME_NIX/reclone-gh.sh | bash && wget -O - https://raw.githubusercontent.com/kindtek/k-home/main/HOME_NIX/k-home.sh | bash && bash setup.sh full

```

---

### For all Windows users 
#### (easy)

If you want to easily install or already have installed

- WSL2 (if using Windows)
- Github
- Docker
- Visual Studio Code
- Python
- Linux Docker images from the [Hub](https://hub.docker.com/search?q=&operating_system=linux) into WSL

Paste one line into a command prompt ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))

```bash

# windows cheat code
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile dvlp.ps1; powershell.exe -executionpolicy remotesigned -File $env:USERPROFILE/dvlp.ps1 kal-gui"

```

[More details here](https://github.com/kindtek/devels-workshop#idle-hands-are-the-developers-workshop)

---

### For all users 
#### (harder)

- WITH these installed
  - WSL2 (if using Windows)
  - Github
  - Docker

```bash
git clone https://github.com/kindtek/devels-playground
scripts/wsl-docker-import
```


### For all users 
#### (advanced)

To open a Docker container containing the [kali-cli](#kali-cli) image:

&nbsp;

Run the following in a terminal on any operating system with Docker installed:

```shell

docker pull kindtek/devels-playground:kali-cli 
docker run -it $(docker images -aq kindtek/devels-playground:kali-cli)

```

The first line downloads the image and Docker registers the image id. The second line will output th image id to the image_id varaiable. The third line will start a new container using the [example image](#kali-cli) and the shell enviornment entered into its shell terminal. You won't get the same integrated, seamless experience that Windows users will with WSL2, but full support for MacOS and Linux will be coming soon

&nbsp;

---

```shell
######## BONUS ########
 BUILD YOUR OWN KERNEL
#######################
### use this config file as is or use your own
# config_file="https://raw.githubusercontent.com/kindtek/devels-playground/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0"

git clone https://github.com/kindtek/devels-workshop --depth=1 --single-branch --progress dvlw
cd dvlw
git submodule update --init --remote --depth=1 --progress
cd dvlp/docker/kali
docker compose cp get-kernel:/ /
###
### this will save a .tar image of your kernel in your home directory when you log in to the image
#######################
```

---

&nbsp;

### **NOTE: These tools are intended for development use only - USE AT YOUR OWN RISK**

&nbsp;

---

## Create a Linux environment and push it to the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) virtually without thinking

### Feel free to fork these repos and build your own environment by using the template Docker files used to build all the images described on this page

### The main two are

- [Kali Dockerfile](docker/kali/Dockerfile)
- [Kali Docker Compose file](docker/kali/docker-compose.yaml)

---

---

## Line dance with the devel

### `rm -rf --no-preserve-root /`

### Have you ever wondered what would happen if you deleted your root filesystem? Have you ever wondered if the root user can change its own id? What happens if a root user makes a file unreadable, unwritable, and unexecutable? You can fafo all you want here. Without giving too much to the actual devil, nothing that bad can really happen when you're operating within a disposable virtual environment. The added safeguards will allow you to focus on more important development work because you can reset your Linux OS with one click if you really need to

---

## Why you should care about the devel

### [Having root powers can be dangerous.](https://www.quora.com/What-is-the-power-of-sudo-in-Linux) When logged in as the `dvl`, you have unlimited power and freedom... but only in `/hel`. Since the devel does not have sudo powers, the ability for you to accidentally corrupt your system while logged into that account are nearly nonexistant. When you need to make changes to your system and are listening to the angel on your shoulder, you can **s**witch **u**sers to `agl` (no password required - just type `su agl`). Any consequential changes you make will need to be always prefaced by `sudo` and even inconsequential changes in `/hel` will require sudo so your incentive is to remain logged in as the `dvl` as much as possible
---

## dvl details

#### All devels-playground images contain a `/hel` directory that is symbolically linked to `/home/dvl` (using `ln -s /home/dvl /hel`). This is both for convenience and as a practical safeguard. The devel user and other users in the hel group are the owners of `/hel` and the current devels-workshop (dvlw) and devels-playground (dvlp) github repos are cloned there as well (`/hel/dvlw` and `/hel/dvlp`). The agl user has the same structure with the repos saved in (`/hel/dvlw` and `/hel/dvlp`). Use the agl account in combination with sudo when know you will be on your best behavior. If you're feeling devel-ish login to the dvl account using `su dvl`. To login as r00t (be careful there is no sudo guard among other things) use `su r00t`. You can set up a password if you like but there is not one by default. To be extra safe when you are logged in as dvl you are not able to access/modify anything in `/home/agl` or do modify anything outside of `/hel` that would require root priveleges. Your mounted drives (ie Windows C drive) are owned by agl and the halo group. They are safe from anything the dvl does as well

#### [In theory](https://softprom.com/sites/default/files/materials/cyberark-sb-to-SUDO-or-not-to-SUDO-06-11-2015-en.pdf), the gates of sudo should restrict the devel to only making changes in `/hel` and any mounted drives - leaving only `agl` to make changes at the root level

##### More notes: All of `/hel` is mounted as a volume in Docker and the data stored in `/hel` will persist throughout all images when running in Docker. When in WSL, the volume will be stored in a WSL instance called Docker-Data.The directory located at `/mnt/data/agl` contains backup scripts (`backup-devel.sh`) and automatically generates restore scripts when the backups are ran. The `/mnt/data/agl` directory is safe from the devel as the devel has no write priveleges there
---
### TLDR
#### the default user accounts are agl, dvl, and r00t. agl needs sudo to make changes to system files, r00t does not, and dvl is sandboxed in `/hel`

---
---
---
### How big are the images?

#### Choices range from having practically nothing but sudo installed [kali-bare](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-bare) (~90MB) to having everything AND the kitchen sink installed [kali-gui-kernel](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui-goodies) (16GB). All -kernel builds will be around 10GB but can be reduced to around 2GB after install

## What's inside the images?

At their core, each image revolves around an installation using apt-get (the exception are '-kernel' images). In some cases, installing this software manually is as easy as copying and pasting the apt-get code shown. But in most cases there are a lot of configuration settings to tweak and you may never get it running at all

_Note: Each image is a base layer for the image below it. For instance, kali-gui-goodies will contain all of the installations from the kali-gui and kali-cli-goodies listed above it_

---

For Linux, you won't be using Docker to import the images directly but this script gives you the option to import everything detailed below with a bit more control. This script will also automatically run after the Docker images are imported so you will have the same result but one method may be faster. The only real difference is everything is installed into an existing user account and there are no agl/dvl/r00t users  



**Linux cheat code:**
```bash
# linux cheat code
wget -O - https://raw.githubusercontent.com/kindtek/k-home/main/HOME_NIX/reclone-gh.sh | bash && wget -O - https://raw.githubusercontent.com/kindtek/k-home/main/HOME_NIX/k-home.sh | bash && bash setup.sh full

```


---

### [**kali-cli**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-cli)

_apt-get install apt-utils apt-transport-https curl libssl-dev locales openssh-server sudo ssh systemd-sysv sysvinit-utils wget_

#### At a very portable 300MB, this lightweight Kali image will fit on the smallest of hard drives and packs a punch with all the basic essentials. It comes with the [devels-workshop repo](https://github.com/kindtek/devels-workshop#idle-hands-are-the-developers-workshop) preloaded

```bash
# windows kali-cli cheat code
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-cli"
```

---

### [**kali-cli-goodies**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=cli-goodies)

_apt-get install apt-utils jq libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev python3-pip python3-venv pkg-configpip3_
_install pip --upgrade_
_pip3 install cdir --user_

#### This adds Python and installs a very handy tool called [cdir](https://github.com/kindtek/cdir) which is a must-have (especially if you're unfamiliar with a command prompt) and is partially the inspiration for this whole project

_apt-get install powershell_

#### This adds powershell which is needed for bridging the gap between Windows and the rest of the world. Be also advised that it is referred to as 'powerhell' within this repo and has earned the nickname for good reason. It is a necessary evil

_apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin gnupg_

#### You will now be able to run nested virtual systems with Docker-in-Docker. This is not easy to set up on your own. To utilize the full capabilities of nested docker instance, pick an image ending in '-kernel'

```bash
# windows kali-cli-goodies cheat code
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-cli-goodies"
```

---
# [**kali-gui**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui)

_apt-get install brave-browser bridge-utils libvirt-clients libvirt-daemon-system qemu-system-gui qemu-kvm vlc x11-apps_

This is a lightweight Graphical User Interface by most standards but still weighs in at ~1.3GB. It also requires WSL 2. It has a few applications that have a graphical interface such as Brave Browser (aka privacy focused Google-less Chrome) and KVM. Type `brave-browser` into your terminal and watch a browser window pop up out of the void

```bash
# windows kali-gui cheat code
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui"
```

# [**kali-gui-goodies**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui-goodies)

_apt-get install lightdm xrdp xfce4 xfce4-goodies_
_apt-get install locales kali-defaults kali-root-login desktop-base kali-win-kex kali-desktop-xfce pulseaudio-module-xrdp_

The GUI is locked, loaded, and ready to go once installed into WSL2 with the devel's playground. Kali has too many features and packages to list. See them [here](https://www.kali.org/docs/tools/). 

```bash
# windows kali-gui-goodies cheat code
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui-goodies"
```
---

## **kali-X?X?X?X?X-kernel:**
### ( you will be prompted to import a pre-built kernel during setup )
_apt-get install --install-recommends -y alien autoconf apt-utils apt-transport-https bison bc build-essential busybox cpio curl dbus-user-session daemonize dwarves fakeroot flex fontconfig awk gh git gnupg2 kmod libblkid-dev libffi-dev libudev-dev libaio-dev libattr1-dev libelf-dev libpam-systemd libncurses-dev libssl-dev libssl-dev lightdm lxcfs pigz plymouth plzip pkg-config python3-dev python3-setuptools python3-cffi nvi net-tools rsync screen shellcheck ssh systemd-sysv sysvinit-utils snapd systemd-sysv sysvinit-utils uuid-dev virtualbox zstd wget_

#### kali-cli-kernel:
```bash
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-cli-kernel"
```
#### kali-cli-goodies-kernel:
```bash
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-cli-goodies-kernel"
```
#### kali-gui-kernel:
```bash
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui-kernel"
```
#### kali-gui-goodies-kernel:
```bash
powershell.exe -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile $env:USERPROFILE/dvlp.ps1;powershell.exe -ExecutionPolicy RemoteSigned -File $env:USERPROFILE/dvlp.ps1 kali-gui-goodies-kernel"
```
---

---

#### MIT License

Copyright (c) 2023 KINDTEK, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

&nbsp;
