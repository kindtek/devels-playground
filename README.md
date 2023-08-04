---
---

# Idle Minds are the **Developer's Playground**

## Import a Linux environment into WSL from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) _virtually_ without thinking

&nbsp;

## NEW FEATURES

## Build a kernel and pop into a Kubuntu GUI with [kali-gui-kernel](https://hub.docker.com/layers/kindtek/dvlp/kali-gui-kernel/images/sha256-e358b4a835faff261ff0b284a207496da7e4d61ce70aa3f44db7618714c7ccf5?context=repo)

( No setup necessary. Kubuntu GUI also included with [kali-gui](https://hub.docker.com/layers/kindtek/dvlp/kali-gui/images/sha256-266c029b305ea1d9553aacb7cf2ecc8ebd8830841945a2427374b8e0c9b478aa?context=repo), [kali-cuda](https://hub.docker.com/layers/kindtek/dvlp/kali-cuda/images/sha256-96fa98d5d82f0991218fd9501f56dae9341955a8b3c49a19d99d7d7e59c41b84?context=repo), and [kali-cuda-kernel](https://hub.docker.com/layers/kindtek/dvlp/kali-cuda-kernel/images/sha256-717739827455ab9eaddb539dbbf3ea6a0c9b943b74cd493a5fc337dd2adb9e92?context=repo) )

### Build and customize your own kernel

#### [kali-basic-wsl-kernel-builder](https://hub.docker.com/layers/kindtek/dvlp/kali-basic-wsl-kernel-builder/images/sha256-bd756e1775327d2b8ea51590ba471fdd0c4997a7d44e3f437999a60e59105a70?context=repo) and all "-kernel" named images include:

- Linux kernel - use a generic prebuilt kernel or use ...
- .config templates to optimize your kernel ([example](kernels/linux/x86/amd/5_15901/.config_wsl0))
- scripts that build the kernel with the .config templates ([example](kernels/linux/build-basic-wsl-kernel.sh))
- enterprise grade ZFS filesystem and volume manager built into the kernel (Advanced: Even build/mount your own ZFS partition!)

### More image selections

#### Choices range from having nothing but sudo installed [kali-bare](https://hub.docker.com/layers/kindtek/dvlp/kali-bare/images/sha256-92d7012da7ae667613f9a52ed1e330eac17134b5a0e7d8e66231efc0e594ef97?context=repo) (~90MB) to having everything AND the kitchen sink installed [kali-cuda-kernel](https://hub.docker.com/layers/kindtek/dvlp/kali-cuda-kernel/images/sha256-717739827455ab9eaddb539dbbf3ea6a0c9b943b74cd493a5fc337dd2adb9e92?context=repo) (6GB+)

#### Coming Soon

- better documentation
- generate optimized kernels embedded via Docker image into WSL2 (very soon)
- simplify Windows -> WSL2 -> Kubuntu GUI conversion with a copypasta line for each image tag
- sync Linux and ZFS repos with latest releases
- automated drive partition and dual bootloader install
- automated Docker builds with Github Actions
- MacOS support so that a dev team can hit the ground running with a common platform no matter the OS

---

---

## **INSTRUCTIONS**

---

### [ OPTIONAL TEST ]

### _When the Devel's Playground loads, at the main menu hit ENTER a few times to import and confirm the default [kali-dind image](https://hub.docker.com/layers/kindtek/dvlp/kali-dind/images/sha256-d4b592c32d92db53e8380a5556bdd771063d946e5614d0ebc953359941be5263?context=explore) ([see details below](#kali-dind)) being imported on your WSL environment_

&nbsp;

### PLAY TIME

### At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) you would like to use with WSL. The format is

#### - source: [kindtek](https://hub.docker.com/u/kindtek)

#### - name: [dvlp](https://hub.docker.com/r/kindtek/dvlp/tags):[kali-gui](https://hub.docker.com/layers/kindtek/dvlp/kali-gui/images/sha256-266c029b305ea1d9553aacb7cf2ecc8ebd8830841945a2427374b8e0c9b478aa?context=repo)

&nbsp;

---

---

## **SETUP**

---

### For all Windows users

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
cd dvlp/docker/ubuntu
docker buildx build -t dvlp_kernel-make --output type=tar,dest=example-ubuntu22-kernel-linux-kernel-6_28.tar  --build-arg KERNEL_TYPE=stable-wsl-zfs CONFIG_FILE=$config_file .
###
### this will save a .tar image of your kernel in your home directory when you log in to the image
#######################
```

---

### For all other Windows users

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

### For everyone else

If you prefer not to use the easy install script, things are not quite so simple and seamless, but you can run the images referenced in this repo as a Docker container on your system. For example, to open a Docker container containing the [kali-dind](#kali-dind) image:

&nbsp;

Run the following in a terminal on any operating system with Docker installed:

```shell
docker pull kindtek/dvlp:kali-dind
```

The above line downloads the image and Docker registers the image id. You will now get that image id by running:

```shell
docker images -aq kindtek/dvlp:kali-dind
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

- [Ubuntu Dockerfile](docker/ubuntu/Dockerfile)
- [Ubuntu Docker Compose file](docker/ubuntu/docker-compose.yaml)

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

### [**kali-git**](https://hub.docker.com/layers/kindtek/dvlp/kali-git/images/sha256-6cb1ae8ea632598d3fc9e0ad742b178346f6b3a146af31e9fe14fbbc93a326c2?context=explore)

#### `apt-get install apt-transport-https build-essential ca-certificates curl git gh gnupg2 libssl-dev nvi wget wslu`

#### At just 300MB, this lightweight Ubuntu 22.04 image packs a punch with all the basic essentials and of course has this Github repo pre-loaded

---

### [**kali-python**](https://hub.docker.com/layers/kindtek/dvlp/kali-py/images/sha256-c0e62053f5364278c5190b64619e0ccf3e6dc34129e485e3037bde28177af13f?context=explore)

#### `apt-utils jq libdbus-1-3 libdbus-1-dev libcairo2-dev libgirepository1.0-dev libpython3-dev pkg-config python3-pip python3-venv`

#### This edition comes with Python and installs a very handy tool called [cdir](https://github.com/kindtek/cdir) which is a must-have (especially if you're unfamiliary with a command prompt) and is partially the inspiration for this whole project

---

### [**kali-msdot**](https://hub.docker.com/layers/kindtek/dvlp/kali-msdot/images/sha256-1dbf76db650ac81d8b6294fae035f837851d5dca928f57a04ce7530141f4fd38?context=explore)

#### `apt-get install powershell dotnet-sdk-7.0`

#### This edition includes power$hell which is needed for bridging the gap between Windows and the rest of the world. Be also advised that it is referred to as 'powerhell' within this repo and has earned the nickname for good reason. It is a necessary evil and it is combined with Microsoft .NET 7 SDK in this image. The [lite flavor](https://hub.docker.com/layers/kindtek/dvlp/kali-msdot-lite/images/sha256-eeaf6a63b2f47bce765b0d4256cdaaeaf682caf149accc84397a6d65ed4aa60d?context=explore) has only powershell

---

## [**kali-dind**](https://hub.docker.com/layers/kindtek/dvlp/kali-dind/images/sha256-f3bd25b349e47370482baf411c6e54d8c141ba38dc8e6029161a34cd5141f403?context=explore)

### `apt-get install docker-compose-plugin docker-ce docker-ce-cli containerd.io`

### Docker in Docker (DIND) - the holy grail.

#### You will now be able to run nested virtual systems with Docker-in-Docker. This is not easy to set up on your own. This image is the default image installed by the devel's playground. It is reasonably lightweight at just under 700MB. This has most everything you need as a developer

---

# [**kernel-builder**](https://hub.docker.com/layers/kindtek/dvlp/kali-basic-wsl-kernel-builder/images/sha256-dc29a6491faf9fce15b768e399b521b15e43fa54e7e1700b42af19b3f9590f94?context=explore) and -kernel images:

## `apt-get install alien autoconf automake bc bison build-essential dbus-user-session daemonize dwarves fakeroot flex fontconfig gawk gnupg libtooldkms libblkid-dev libffi-dev lxcfs libudev-dev libssl-dev libaio-dev libattr1-dev libelf-dev python3 python3-dev python3-setuptools python3-cffi snapd sysvinit-utils uuid-dev`

### This pre-built image (and those below) comes with a kernel saved conveniently in both `/hel/kernels` and `/halo/kernels`.

If you build this yourself (ie: run `docker compose build kernel-builder --build-arg CONFIG_FILE=<url or path to config file>` in the `devels-workshop/dvlp/docker/ubuntu` directory) a basic 5.15.90 kernel built with your machine is included. If you don't include a config file the default is a generic configuration sourced from https://github.com/microsoft/WSL2-Linux-Kernel.git. If you own a machine with an AMD processor you are in luck and there are already configuration files and kernels saved in the [repository](kernel). If you want to optimize your kernel for your hardware it is not hard to do it yourself with the template config files and scripts already made. To do this and/or partition a hard drive with [ZFS](<(https://zfsonlinux.org/)>) built in to the latest kernels released by [Linux](https://www.kernel.org/), you will need either the kernel-kernel, gui-kernel, or cuda-kernel images. Read up on what the gui and cuda images include below

If you end up building your own kernel, please consider contributing to this project by making a pull request with your .config file and/or kernel. If you are using a kernel-builder or (gui/cuda)-kernel image, a copy of both the config file and the kernel will automatically be saved in your local copy of your repository (devels-workshop/dvlp/kernels/linux/<CPU architecture>/<CPU vendor>/<kernel version/linux-<kernel version>>) in the directory that matches your system so all you have to do is click the "Commit && Create make pull request" button

If you don't need/want to save or import a large docker image, you can build the kernel only by installing docker and running:
`docker buildx build -t dvlp_basic-wsl-kernel-builder --build-arg CONFIG_FILE="https://raw.githubusercontent.com/kindtek/dvl-playg/615b895f27a5c6827e468c0f5b92f4881e386208/kernels/linux/x86/amd/6_3rc4/.config_wsl-zfs0" --target=built-kernels --output type=local,dest=$(pwd)/out/ .` inside a local copy of the devels-playground repo in the docker/ubuntu directory. When the build is finished it will save a zip file with the kernel, a sample wslconfig file, and a kernel config file as built-kernels.zip. You will need to update your wslconfig file with the filename of your kernel and you can change it to whatever you want.

The CONFIG_FILE argument is optional. If you don't include it or leave it blank it will default the source url/path of the Microsoft WSL2-Linux-Kernel configuration as mentioned above. Don't forget the period at the end or the script won't run.

``

---

## [**kali-gui-lite**](https://hub.docker.com/layers/kindtek/dvlp/kali-gui/images/sha256-ca41db9a7ffc60a29f9201f7ac2690ac2c4251a7ebf7899ac8393498f7540442?context=explore)

### `apt-get install brave-browser gimp gedit nautilus vlc x11-apps `

This is a lightweight Graphical User Interface by most standards but still weighs in at ~1.3GB. It also requires WSL 2. It has a few applicaations that have a graphical interface such as Brave Browser (aka privacy focused Google-less Chrome). One of the coolest things ever is to type `brave-browser` into your shell terminal and watch a browser window pop up out of the void

# [**kali-gui-kernel**](https://hub.docker.com/layers/kindtek/dvlp/kali-gui-kernel/images/sha256-e358b4a835faff261ff0b284a207496da7e4d61ce70aa3f44db7618714c7ccf5?context=explore) and [kali-gui](https://hub.docker.com/layers/kindtek/dvlp/kali-gui/images/sha256-266c029b305ea1d9553aacb7cf2ecc8ebd8830841945a2427374b8e0c9b478aa?context=explore)

# `apt-get install lightdm xrdp xfce4 xfce4-goodies`

# `apt-get install --no-install-recommends -y kubuntu-desktop`

These images has everything but CUDA. You can build your own kernel with the kali-gui-kernel image. The GUI is locked, loaded, and ready to go once installed into WSL2 with the devel's playground. Kubuntu has too many features and packages to list. See them [here](https://packages.ubuntu.com/jammy/kubuntu-desktop). The red packages come installed with this image. To keep the size of the image down, the recommended packages (in green) are not installed. Install them with sudo `apt-get install kubuntu-desktop` if you like

---

## [**kali-cuda-kernel**](https://hub.docker.com/layers/kindtek/dvlp/kali-cuda-kernel/images/sha256-717739827455ab9eaddb539dbbf3ea6a0c9b943b74cd493a5fc337dd2adb9e92?context=explore) and [**kali-cuda**](https://hub.docker.com/layers/kindtek/dvlp/kali-cuda/images/sha256-a58446b7bee69471309a8cfd0020a6c70f4a102aecccd86ae9026d945651ede0?context=explore)

### `apt-get install nvidia-cuda-toolkit`

If CUDA is a necessity for your developer needs your life just became easier. These images are fully loaded and use approximately 6GB of space. You can build your own kernel with the kali-cuda-kernel image.

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
