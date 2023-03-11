# Idle Hands are the **Developer's Workshop**

&nbsp;

## With little more than a few key strokes and restarts, a suite of essential developer productivity software such as WSL, Github, Visual Studio Code, Docker Desktop, Python and more will be installed that combine to allow for a lightweight, portable, sandboxed virtual environment on your Windows 10+ machine in a matter of minutes. Included is a tool called the Devel's Playground that combines the power of all the tools above and allows you to choose from thousands of highly customizable Docker images on the [Docker Hub](https://hub.docker.com/repositories) - all of which are free. The custom Docker Linux images that were designed with the tools available on this repo are [explained in detail below](https://github.com/kindtek/devels-workshop#image-versions). At the end of the installation sequence, your computer will be loaded with a lightweight image that is built for lightning fast development - especially for teams

## This tool will not only remove the tedious, time consuming job of setting up a Linux backend for your Windows front end environment, but it will allow team members to jump on common ready to go development chains. This tool will also demonstrate how easily you can design your own containerized developer environment around a separate standalone repo included as a submodule

&nbsp;

## Easy as 1, 2, .., 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions, restart device, and repeat step one as needed
3. ??
4. Profit

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

&nbsp;

## Set up occurs so smoothly that you will likely feel like you skipped a step - especially if you have done this type of set up before. But don't worry - at the end it will ask you if you'd like to dive into WSL or try out the Devel's Playground for fun. So now it is time for the fun stuff

&nbsp;

---

---

## [Devel's Playground](https://github.com/kindtek/devels-playground)

### **Instructions for importing images from [hub.docker.com](https://hub.docker.com/) into WSL**

#### _0. [Example] When the program loads, at the main menu hit ENTER a few times to import and confirm the default [ubuntu-dind image](https://hub.docker.com/layers/kindtek/dplay/ubuntu-dind/images/sha256-d4b592c32d92db53e8380a5556bdd771063d946e5614d0ebc953359941be5263?context=explore) ([see details below](https://github.com/kindtek/devels-workshop#ubuntu-dind)) being imported on your WSL environment_

#### 1. At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

* source: [kindtek](https://hub.docker.com/u/kindtek)

* name: [dplay](https://hub.docker.com/r/kindtek/dplay/tags):[ubuntu-msdot](https://hub.docker.com/layers/kindtek/dplay/ubuntu-msdot/images/sha256-816677a90ae498b8873fdb54e9c1d71455089f400a41de01221d29068937bab7?context=explore)

---

&nbsp;

### **NOTE: These environments are intended for development use only - USE AT YOUR OWN RISK**

&nbsp;
___

### Feel free to fork these repos and build your own environment by using the template Docker files used to build all the images described on this page

### The main two are

* [Ubuntu Dockerfile](devels-playground/dockerfile.ubuntu.yaml)
* [Ubuntu Docker Compose file](devels-playground/docker-compose.ubuntu.yaml)

#### There are some lightly tested Alpine images available if you dig around as well

---

---

## Line dance with the devel

### `rm -rf --no-preserve-root /`

### Once you get an image installed, try destroying your environment just for fun by running the script above (...even on the root directory!!!). Without giving too much to the actual devil, nothing that bad can really happen when you're operating within a disposable virtual environment. The added safeguards will allow you to focus on more important development work because you can reset your Linux OS with one click if you really need to

&nbsp;

## Why you should care about the devel

### [Having root powers can be dangerous.](https://www.quora.com/What-is-the-power-of-sudo-in-Linux) When logged in as the `devel`, you have unlimited power and freedom... but only in `/hel`. Since the devel does not have sudo powers, the ability for you to accidentally corrupt your system while logged into that account are nearly nonexistant. When you need to make changes to your system, you can **s**witch **u**sers to `gabriel` (no password required - just type `su gabriel`). Any consequential changes you make will need to be always prefaced by `sudo` and even inconsequential changes in `/hel` will require sudo so your incentive is to remain logged in as the `devel` as much as possible

### Hint: if you properly set up a your Docker image you will rarely ever need to use sudo because all your favorite packages will be pre-installed

---

### Devel details

#### All images contain a `/hel` directory that is symbolically linked to `/home/devel` (using `ln -s /home/devel /hel`). This is both for convenience and as a practical safeguard. The devel user and other users in the horns group are the owners of `/hel` and the current devel's workshop and devel's playground github repos are cloned there as well (`/hel/dwork` and `/hel/dplay`). Devel is the default user and as the devel you are not able to access anything in `/home/gabriel` or do anything outside of `/hel` that would require root priveleges

#### [In theory](https://softprom.com/sites/default/files/materials/cyberark-sb-to-SUDO-or-not-to-SUDO-06-11-2015-en.pdf), the gates of sudo should restrict the devel to only making changes in `/hel` and any mounted drives - leaving only `gabriel` to make changes at the root level

##### More notes: All images are built with the [Dockerfiles in the devels-playground repo root](devels-playground). All of `/hel` is mounted as a volume in Docker and the data stored in `/hel` will persist throughout all images when running in Docker. Although this particular feature does not work with WSL, the directory located at `/mnt/n/gabriel` contains backup scripts (`backup-devel.sh`) and automatically generates restore scripts when the backups are ran. The `/mnt/n/gabriel` directory is safe from the devel as the devel has no write priveleges there -- only read and execute. Do NOT confuse this with `/mnt/n`. The devel still has write priveleges there -- because, yes, even as destructive as devels can be, devels still want to make backups and restore them as well. If you mount a permissioned NTFS partition on Windows and give it the drive letter "N:/", everything should line up and you can share this mounted drive seamlessly between your Linux Docker images and Windows

&nbsp;

---

### Image Versions

&nbsp;

#### [**ubuntu-git**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-git/images/sha256-c6fdf507e9af5a864578a835ed38ebcb314b0c7488e22dc2a4d04510921cf1a3?context=explore)

#### `apt-get install -y git gh build-essential libssl-dev ca-certificates wget curl gnupg lsb-release python3 python3-pip vim`

#### At just 300MB, this lightweight Ubuntu 22.04 image packs a punch with all the basic essentials pre-loaded. It even has the added bonus of the [cdir](https://github.com/kindtek/cdir) package which is a must-have and is partialy the inspiration for theis whole project. These are also included with the heavier Docker images below as well

&nbsp;

#### [**ubuntu-msdot**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-msdot/images/sha256-816677a90ae498b8873fdb54e9c1d71455089f400a41de01221d29068937bab7?context=explore)

#### `apt-get install powershell dotnet-sdk-7.0`

#### This edition includes power(s)hell which is highly recommended for bridging the gap between Windows and the rest of the world. Be also advised that it is referred to as 'powerhell' often within this repo and has earned the nickname for good reason. Its size (~550MB) doubles that of the ubuntu-git image but is very worth it. Microsoft .NET 7 SDK, another necessary evil from Microsoft, is also pre-loaded with this image

&nbsp;

#### [**ubuntu-dind**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-dind/images/sha256-cba70a7cf5c005b2522156c495a0036c44138f77fdf1a4fd0f57ae813e377cb9?context=explore)

#### `apt-get install -y docker-compose-plugin docker-ce docker-ce-cli containerd.io`

# Docker in Docker (DIND) - the holy grail. It is solid on my system and works on every test device so far.. Assembled with powerhell and the devel's workshop, it should work for you too. This image is the default image downloaded and installed by the Devel's Playground. It is very lightweight at just under 700MB. This has everything you need as a developer and if you don't know which image to choose, just choose this one

### But if you need a GUI or CUDA then keep reading..

&nbsp;

#### [**ubuntu-gui**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-gui/images/sha256-b55f2582363d995f9fffe67b5845df06607c1ecb6d12d795b428be66b6904db2?context=explore)

#### `apt-get install gnome-session gdm3 gimp nautilus vlc x11-apps apt-transport-https software-properties-common brave-browser`

This is a lightweight Graphical User Interface by most standards but still weighs in at ~1.3GB. It also requires WSL 2. One of the coolest things ever is to type `brave-browser` into your command prompt and watch as an internet browser pops up

&nbsp;

#### [**ubuntu-cuda**](https://hub.docker.com/layers/kindtek/dplay/ubuntu-cuda/images/sha256-2c22d060e3a35474a469a61357b4d020b057260b67db83f0ebc9fbb5f90171ea?context=explore)

#### `apt-get install nvidia-cuda-toolkit`

If CUDA is a must have for your developer needs your life just became easier. This image will use approximately 4GB of space.

&nbsp;

##### Note: Each version is built on top of the image documented above it. For instance, ubuntu-dind will contain all of the features from the above ubuntu-git and ubuntu-msdot versions

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
