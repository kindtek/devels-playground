# Idle Hands are the **Developer's Workshop**

&nbsp;

## One line of code pasted into a terminal will set up a ready to go developer environment on a Windows 10+ (macOS support coming soon) machine. With little more than a few key strokes, a suite of developer productivity software such as Github, VSCode, Docker Desktop will be installed on top of setting up your machine with Hyper-V, WSL, and other Virtual Machine optimization features

&nbsp;

### Easy as 1, 2, 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions, restart device, and repeat step one as needed
3. ??
4. Profit

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

&nbsp;

## When set up is complete, there will be an option to launch the Devel's Playground WSL Docker import tool. Not only does it make it easy for you to import your own custom Docker images onto WSL, it demonstrates how easy it is to wrap this portable containerized developer environment around a separate standalone repo

<!-- ###### also found in [[copypasta.cmd](scripts/powerhell-remote/copypasta.cmd)] -->

&nbsp;

---

## [Devel's Playground](https://github.com/kindtek/devels-playground)

### **Instructions for importing images from [hub.docker.com](https://hub.docker.com/) into WSL**

## _0. [Example] When the program loads, at the main menu hit ENTER a few times to import and confirm the default [ubuntu-phatter image](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phatter/images/sha256-d4b592c32d92db53e8380a5556bdd771063d946e5614d0ebc953359941be5263?context=explore) ([see details below](https://github.com/kindtek/devels-workshop#ubuntu-phatter)) being imported on your WSL environment_

## 1. At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

## - source: [kindtek](https://hub.docker.com/u/kindtek)

## - name: [dplay](https://hub.docker.com/r/kindtek/dplay/tags):[ubuntu-phat](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phat/images/sha256-638debdde2528366c7beb3c901fc709f1162273783d22a575d096753abd157ad?context=explore)

---

&nbsp;

## **Note: This is for development use only. Use at your own risk**

## _Feel free to fork this repo and build your own dev environment by using template Docker files ([ubuntu](devels-playground/dockerfile.ubuntu.yaml), [alpine](devels-playground/dockerfile.alpine.yaml)) and Docker Compose files ([ubuntu](devels-playground/docker-compose.ubuntu.yaml), [alpine](devels-playground/docker-compose.alpine.yaml))_

&nbsp;

---

&nbsp;

## Designed for messy testing in a sandboxed environment

&nbsp;

### Summary of custom docker images

#### All images contain a `/hel` directory that is symbolically linked to `/home/devel` (using `ln -s /home/devel /hel`). The devel user and those in the devels group are the owners of `/hel` and the current devel's workshop/playground gh repos are cloned there as well (`/hel/dwork` and `/hel/dplay`). Devel is the default user and as the devel you are not able to access anything in `/home/gabriel` or do anything outside of `/hel` that would require root permission. If you absolutely require root permissions, change user to gabriel at any time (`su gabriel`) and use your sudo powers (no password required) from there. Just don't forget to change back to the devel user once you're done. That shouldn't be too hard to remember since you'll need sudo make any changes in `/hel`

#### In theory, the gates of sudo should restrict the devel to only making changes to `/hel` and any mounted drives - leaving only `gabriel` to make changes at the root level. Since the devel is operating within the `/hel` or `/home/devel` directories, the rest of the environment is probably pretty safe. You never know what the devil developers can get into, though

##### More notes: All images are built with the Dockerfiles in the devels-playhouse repo [root](devels-playground).  `/hel` is mounted as a volume in Docker and the data stored in `/hel` will persist throughout all images when running in Docker. This feature does not work with WSL, however

---

### Image Versions

&nbsp;

#### [**ubuntu-git**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-git/images/sha256-e4f654379613e580d57899a4027372de3fb4b593d4056a2aff1ea00577a5a7c1?context=explore)

#### `apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip vim`

#### All of the above functionality is standard in the lightweight Ubuntu 22.04 image. All the basic lightweight essentials for Ubuntu are included with ubuntu-git and it even has the added bonus of the [cdir](https://github.com/kindtek/cdir) package which is a must-have for me and the inspiration for the automation of this entire process to begin with

&nbsp;

#### [**ubuntu-phat**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phat/images/sha256-638debdde2528366c7beb3c901fc709f1162273783d22a575d096753abd157ad?context=explore)

#### `apt-get install powershell dotnet-sdk-7.0`

#### This edition includes everything from ubuntu-git and includes powershell which highly recommended for bridging the gap between Windows and the rest of the world. Be advised it is also referred to as powerhell often in the code of this repo and for good reason. Microsoft .NET 7 SDK is also installed

&nbsp;

#### [**ubuntu-phatt*er***](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phatter/images/sha256-d4b592c32d92db53e8380a5556bdd771063d946e5614d0ebc953359941be5263?context=explore)

#### `apt-get install -y docker-compose-plugin docker-ce docker-ce-cli containerd.io `

# Dock*er* in Dock*er* (DIND) - the holy grail. It is solid on my system and works on every test device so far.. Using powerhell and the devel's workshop, it should work for you too. This image is recommended and is the default image downloaded and installed by the devel's playground

&nbsp;

#### [**ubuntu-phattest**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phattest/images/sha256-7b0b84ea76eb2ef418e4614d3bd843f3781b6014e1cbb4076127858f3e0a8f32?context=explore)

#### `apt-get install gnome-session gdm3 gimp nautilus vlc x11-apps apt-transport-https software-properties-common brave-browser`

Basically, if you want to run a GUI you can. This requires WSL 2

&nbsp;

#### [**ubuntu-phatso**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-phatso/images/sha256-3a7fab2b8d29fb737ef85367e063f6e2d538b5703cab552c6d0e2ad13f4fd7fc?context=explore)

#### `apt-get install nvidia-cuda-toolkit`

If CUDA is a must have for your developer needs your life just became easier

&nbsp;

##### Note: Each version is built on top of the image documented above it. For instance, ubuntu-phatter will contain all of the features from the above ubuntu-git and ubuntu-phat versions

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
