---
---

# Idle Minds are the **Developer's Playground**

## Import a Linux environment into WSL from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) _virtually_ without thinking

&nbsp;

## NEW FEATURES

## Build a kernel and pop into a Kali GUI

( No setup necessary !!! )

### Build and customize your own kernel 

### images are built using a Dockerfile, Docker compose file, and various shell scripts

#### all images built with a kernel (images ending in -kernel) will include:

- the latest bleeding edge Linux kernel
- a ([script](kernels/linux/build-import-kernel.sh)) that will build a kernel with your custom .config file ([example](kernels/linux/x86/amd/5_15901/.config_wsl0)) using a filepath or url or automaticlly select the best available configuration for your architecture
- a ([script](mnt/HOME_NIX/setup.sh)) that will import your kernel into WSL and set up your system
- a ([script](kernels/linux/install-kernel.sh)) that will allow you to rotate through multiple kernel builds
- powerhell scripts to do all of the above seamlessly in windows
- enterprise grade ZFS compression/decompression tool and volume manager built into the kernel (Advanced: Even mount your Linux filesystem from a ZFS partition!)

### More image selections

#### Choices range from having nothing but sudo installed [kali-bare](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-bare) (~90MB) to having everything AND the kitchen sink installed [kali-gui-kernel](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui) (12GB). All -kernel builds will be around 10GB but can be reduced to around 2GB  after install

#### Coming Soon

- better documentation
- ~~generate optimized kernels embedded via Docker image into WSL2 (very soon)~~
- ~~simplify Windows -> WSL2 -> Kali GUI conversion with a copypasta line for each image tag~~
- ~~sync Linux and ZFS repos with latest releases~~
- automated Docker builds with Github Actions
- automated drive partition and dual bootloader install
- MacOS support

---

---

## **INSTRUCTIONS**

---

### [ SETUP ]

### _At the main menu hit ENTER to import and confirm the image ([see details below](#kali-git)) being imported on your WSL environment_

( if you use the [devel's workshop](https://github.com/kindtek/devels-workshop#idle-hands-are-the-developers-workshop), the import will happen automatically the first time - use 'i' or 'i!' after that )

&nbsp;

### PLAY TIME

### At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) you would like to use with WSL. The format is

#### - source: [kindtek](https://hub.docker.com/u/kindtek)

#### - name: devel's playground:[image name here](https://hub.docker.com/repository/docker/kindtek/devels-playground)

&nbsp;

---

---

## **SETUP**

---



### For all Windows users (easy)

If you want to easily install or already have installed

- WSL
- Github
- Docker
- Visual Studio Code
- Python
- Linux Docker images from the [Hub](https://hub.docker.com/search?q=&operating_system=linux) into WSL

Paste one line into a command prompt ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/devel-spawn.ps1 -OutFile dvlp.ps1; powershell.exe -executionpolicy remotesigned -File $env:USERPROFILE/dvlp.ps1 kal-gui"

```

[More details here](https://github.com/kindtek/devels-workshop#idle-hands-are-the-developers-workshop)

---

### For all Windows users (harder)

- WITH these installed
  - WSL
  - Github
  - Docker

```bat
git clone https://github.com/kindtek/devels-playground
scripts/wsl-docker-import
```

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
docker buildx build -t dvlp_kernel-make --output type=tar,dest=example-kali-kernel-linux-kernel.tar  --build-arg KERNEL_TYPE=basic KERNEL_FEATURE=zfs CONFIG_FILE=$config_file .
###
### this will save a .tar image of your kernel in your home directory when you log in to the image
#######################
```


### For all Windows users (advanced)

To open a Docker container containing the [kali-dind](#kali-dind) image:

&nbsp;

Run the following in a terminal on any operating system with Docker installed:

```shell
docker pull kindtek/devels-playground:kali-dind
```

The above line downloads the image and Docker registers the image id. You will now get that image id by running:

```shell
docker images -aq kindtek/devels-playground:kali-dind
```

The above code will output your image id to the screen. Replace \<image_id\> in the code below with this image id and run it:

```shell
docker run -it <image_id>
```

&nbsp;

This will start a new container using the [example image](#kali-dind) and the shell enviornment entered into its shell terminal. You will not enjoy the same integrated, seamless experience that Windows users will with WSL2, but full support for MacOS and Linux will be coming soon

&nbsp;

---

---

&nbsp;

### **NOTE: These environments are intended for development use only - USE AT YOUR OWN RISK**

&nbsp;

---

## Create a Linux environment and push it to the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) virtually without thinking

### Feel free to fork these repos and build your own environment by using the template Docker files used to build all the images described on this page

### The main two are

- [Kali Dockerfile](docker/kali/Dockerfile)
- [Kali Docker Compose file](docker/kali/docker-compose.yaml)

#### There are some lightly tested Alpine images available if you dig around as well

---

---

## Line dance with the devel

### `rm -rf --no-preserve-root /`

### Have you ever wondered what would happen if you deleted your root filesystem? Have you ever wondered if the root user can change its own id? What happens if a root user makes a file unreadable, unwritable, and unexecutable? You can fafo all you want here. Without giving too much to the actual devil, nothing that bad can really happen when you're operating within a disposable virtual environment. The added safeguards will allow you to focus on more important development work because you can reset your Linux OS with one click if you really need to

---

## Why you should care about the devel

### [Having root powers can be dangerous.](https://www.quora.com/What-is-the-power-of-sudo-in-Linux) When logged in as the `dvl`, you have unlimited power and freedom... but only in `/hel`. Since the devel does not have sudo powers, the ability for you to accidentally corrupt your system while logged into that account are nearly nonexistant. When you need to make changes to your system and are listening to the angel on your shoulder, you can **s**witch **u**sers to `agl` (no password required - just type `su agl`). Any consequential changes you make will need to be always prefaced by `sudo` and even inconsequential changes in `/hel` will require sudo so your incentive is to remain logged in as the `dvl` as much as possible

### TIP: If you make your own Docker image you will rarely ever need to use sudo - all your favorite packages will be pre-installed

---

## Devel details

#### All images contain a `/hel` directory that is symbolically linked to `/home/dvl` (using `ln -s /home/dvl /hel`). This is both for convenience and as a practical safeguard. The devel user and other users in the hel group are the owners of `/hel` and the current devel's workshop and devel's playground github repos are cloned there as well (`/hel/dvlw` and `/hel/dvlp`). Devel is the default user and as the devel you are not able to access anything in `/home/agl` or do anything outside of `/hel` that would require root priveleges

#### [In theory](https://softprom.com/sites/default/files/materials/cyberark-sb-to-SUDO-or-not-to-SUDO-06-11-2015-en.pdf), the gates of sudo should restrict the devel to only making changes in `/hel` and any mounted drives - leaving only `agl` to make changes at the root level

##### More notes: All of `/hel` is mounted as a volume in Docker and the data stored in `/hel` will persist throughout all images when running in Docker. When in WSL, the volume will be stored in a WSL instance called Docker-Data.The directory located at `/mnt/data/agl` contains backup scripts (`backup-devel.sh`) and automatically generates restore scripts when the backups are ran. The `/mnt/data/agl` directory is safe from the devel as the devel has no write priveleges there -- only read and execute

---

---

---

## Image Tags

_Note: Each image forms the base layer for the image described below it. For instance, kali-dind will contain all of the features from the kali-git and kali-msdot tags listed above it. You could install a lot of this software manually on a Debian system by copying and pasting the line of code shown. Others, like Brave Browser, require you to add its respective repository registry first which gets messy. Not having to do this is one of the many ways that running Docker images makes a developer's life easier_

---

### [**kali-git**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-git)

#### `apt-get install apt-transport-https build-essential ca-certificates curl git gh gnupg2 libssl-dev nvi wget wslu`

#### At just 300MB, this lightweight Kali image packs a punch with all the basic essentials and of course has this Github repo pre-loaded

---
# **kali-git-kernel:**
## ( and all kali-{base_name}-kernel images  - not saved to Docker Hub )
## `apt-get install alien autoconf apt-utils apt-transport-https bison bc build-essential cpio curl dbus-user-session daemonize dwarves fakeroot flex fontconfig gawk gh git gnupg2 kmod libblkid-dev libffi-dev lxcfs libudev-dev libaio-dev libattr1-dev libelf-dev libpam-systemd libncurses-dev libssl-dev libssl-dev pigz plzip pkg-config python3-dev python3-setuptools python3-cffi nvi net-tools rsync screen shellcheck ssh systemd-sysv sysvinit-utils snapd systemd-sysv sysvinit-utils uuid-dev zstd wget`

### kernel saved conveniently in `/kache`

---

### [**kali-python**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-python)

#### `apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv`

#### This edition comes with Python and installs a very handy tool called [cdir](https://github.com/kindtek/cdir) which is a must-have (especially if you're unfamiliary with a command prompt) and is partially the inspiration for this whole project

---

### [**kali-msdot**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-msdot)

#### `apt-get install powershell dotnet-sdk-7.0`

#### This edition includes power$hell which is needed for bridging the gap between Windows and the rest of the world. Be also advised that it is referred to as 'powerhell' within this repo and has earned the nickname for good reason. It is a necessary evil and it is combined with Microsoft .NET 7 SDK in this image. The [lite flavor](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-msdot-lite) has only powershell

---

## [**kali-dind**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-dind)

### `apt-get install docker-compose-plugin docker-ce docker-ce-cli containerd.io`

### Docker in Docker (DIND) - the holy grail.

#### You will now be able to run nested virtual systems with Docker-in-Docker. This is not easy to set up on your own. To utilize the full capabilities of nested vm, install a kernel. This has most everything you need as a developer

---
# [**kali-gui-lite**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui-lite)


### `apt-get install brave-browser virtualbox vlc x11-apps `

This is a lightweight Graphical User Interface by most standards but still weighs in at ~1.3GB. It also requires WSL 2. It has a few applicaations that have a graphical interface such as Brave Browser (aka privacy focused Google-less Chrome). One of the coolest things ever is to type `brave-browser` into your shell terminal and watch a browser window pop up out of the void

# [**kali-gui**](https://hub.docker.com/repository/docker/kindtek/devels-playground/tags?name=kali-gui)

## `apt-get install lightdm xrdp xfce4 xfce4-goodies`
## `apt-get install locales kali-defaults kali-root-login desktop-base kali-win-kex kali-desktop-xfce pulseaudio-module-xrdp `

The GUI is locked, loaded, and ready to go once installed into WSL2 with the devel's playground. Kali has too many features and packages to list. See them [here](https://www.kali.org/docs/tools/). 

---

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
