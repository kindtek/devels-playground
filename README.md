# Idle Minds are the **Developer's Playground**

## Setup Instructions

&nbsp;

### For **Windows Github** users with **WSL2** setup and **Docker Desktop** _running_, run this in a terminal to clone the repo and start the Docker import tool

```bat
git clone https://github.com/kindtek/devels-playground
scripts/wsl-docker-import
```

&nbsp;

### All other Windows users follow [these short instructions](https://github.com/kindtek/devels-workshop#idle-hands-are-the-developers-workshop)

&nbsp;

---

## Instructions for importing any image from [hub.docker.com](https://hub.docker.com/) into WSL

&nbsp;

## _0. [Example] When the program loads, at the main menu hit ENTER a few times to import and confirm the default ubuntu-phatter image (more details below) being imported on your WSL environment_

#### 1. At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

- source: [kindtek](https://hub.docker.com/u/kindtek)
- name: [dplay](https://hub.docker.com/r/kindtek/dplay/tags):[ubuntu-git](https://hub.docker.com/layers/kindtek/dplay/ubuntu-git/images/sha256-f0469de765c03873f8c5df55cf2d2ea3dda4a3eb98b575f00d29696193d6ca08?context=repo)

---

---

## **Note: This is for development use only. Use at your own risk**

&nbsp;

## _Feel free to fork this repo and build your own dev environment by using template Docker files ([[ubuntu](devels-playground/docker-compose.ubuntu.yaml)], [[alpine](devels-playground/docker-compose.alpine.yaml)]), ([[ubuntu](devels-playground/dockerfile.ubuntu.yaml)], [[alpine](devels-playground/dockerfile.alpine.yaml)])_

&nbsp;

---

## Summary of the Ubuntu images built with the Dockerfiles in this repo

#### `/hel` is symbolically linked to `/home/devel` (using `ln -s /home/devel /hel`). The devel user and those in the devels group are the owners of `/hel` and the current devel's workshop/playground gh repos are cloned there as well. Devel is the default user and you are not able to access anything in `/home/gabriel` or do anything outside of `/hel` that would require root permission. If you absolutely must use sudo use `su gabriel` and use your sudo powers from there. In theory the gates of `/hel` should hold in the powers of sudo and the devel. Since the devel is operating within the `/hel` or `/home/devel` directories, the rest of the environment is probably pretty safe. You never know what the devil developers can get into, though.

### Image Versions

#### **ubuntu-git**

#### All of the above functionality is standard in the lightweight **ubuntu-git** Ubuntu 22.04 image. It is free to use and the customization possibilities for a developer are endless. You can build your own with the Dockerfiles found at the root of the repository or use the images I made that are freely available on the [Kindtek Docker Hub repository](https://hub.docker.com/r/kindtek/dplay). Instructions for building and running the images are in the scripts directory in the docker-compose-**\_** files. And of course you are free to load any other image you want

#### `apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip vim`

#### All of the above features are included with all of the below listed images. All the essentials are included with ubuntu-git and even has the added bonus of the [cdir](https://github.com/kindtek/cdir) package which is a must-have for me and the inspiration for the automation of this entire process to begin with.

#### **ubuntu-phat**

#### This edition includes powershell which highly recommended for bridging the gap between Windows and the rest of the world. Be advised it is also referred to as powerhell often in the code of this repo and for good reason

#### **ubuntu-phatt**

`apt-get install -y gimp nautilus vlc x11-apps apt-transport-https software-properties-common`

#### **ubuntu-phatt*er***

# Dock*er* in Dock*er* (DIND) - the holy grail. It is solid on my system and works on every test device so far.. Using powerhell and the devel's workshop, it just might work for you too.

#### **ubuntu-phattest**

`apt-get install gnome-session gdm3 gimp nautilus vlc x11-apps apt-transport-https software-properties-common brave-browser`

Basically, if you want to run a GUI you can.

&nbsp;

#### **ubuntu-phatso**

`apt-get install nvidia-cuda-toolkit`

If CUDA is a must have for your developer needs your life just became easier

&nbsp;

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

## Anyways, welcome to /hel!
