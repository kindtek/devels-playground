# Idle Hands are the **Developer's Workshop**

## Import a Linux Docker image from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) into WSL *virtually* without lifting a finger

---

---

## SETUP

### Easy as 1, 2, .., 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions, restart device, and repeat step one as needed
3. ??
4. WSL, DOCKER-IN-DOCKER, KERNEL, GUI.

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/devels-workshop/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

---

## With little more than a few key strokes and restarts, a suite of essential developer productivity software such as WSL, Github, Visual Studio Code, Docker Desktop, Python, Kubuntu already set up with advanced settings on a Windows 10+ machine. 

### Set up occurs so smoothly that you will likely feel like you skipped step 3 -- especially if you've been tripped up by any of these tricky procedures *(ie : installing WSL, Github, Docker, seting up SSH logins with Github and Docker, manually adding new app registries, building a kernel, installing a GUI on Linux)* in the past. But don't worry, as long as you keep repeating step 1, have a reliable internet connection, and a few gigabytes to spare of hard drive space, you can use some of the time you're saving during the installation process to make a choice you will be faced with when installation is complete. Either you can try out the Devel's playground and any of the thousands of Linux images on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) for a spin or you can continue on to using your WSL environment for the first time and go straight to `/hel` in a [sandboxed user environment](https://github.com/kindtek/devels-playground#line-dance-with-the-devel). There's no wrong choice. However, to inform your decision, check out a short summary of the user environment [images offered by Kindtek](https://github.com/kindtek/devels-playground#image-tags) that you can set as your main WSL environment with the devels-playground

### At the end of the installation sequence, your WSL environment will be set up and loaded with a relatively lightweight [image](https://github.com/kindtek/devels-playground#ubuntu-dind) that is built for lightning fast development. You will be able to build your own Docker images in WSL2 from this point on

---

### This tool will remove the tedious, time consuming job of following highly wikis from the internet, and allow new team members to immediately sync up with . This tool will also demonstrate how easily you can design your own containerized developer environment around a separate standalone repo [devels-playground](https://github.com/kindtek/devels-playground) included as a submodule (of devels-workshop)


### The included devels-playground combines the power of all the tools you are installing to allow you to choose from thousands of highly customizable Docker images on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) - all of which are free. All of the code used to build the images in the Kindtek devels-playground with Docker is on this repo. Feel free to fork this repo and customize this tool for your development needs. The Docker Linux images [created by Kindtek](https://github.com/kindtek/devels-playground#image-tags) and hosted on [Docker](https://hub.docker.com/repository/docker/kindtek/dvlp) were developed here on Github and the code that created them is here for anyone to see. 

### Got an idea, suggestion, need help, or find a bug? Feel free to start a new issue or pull request


---

&nbsp;

## All in a day's work

## Now time for the fun stuff

# Import your Linux Docker image


## **Instructions for importing images from [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) and the official [kindtek devel's playground docker hub repo](https://hub.docker.com/r/kindtek/dvlp/tags) into WSL with the Devel's Playground are [found here](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground)**

&nbsp;
## NEW FEATURES

## Build a kernel and pop into a Kubuntu GUI with [ubuntu-gui-plus](https://hub.docker.com/layers/kindtek/dvlp/ubuntu-gui-plus/images/sha256-e358b4a835faff261ff0b284a207496da7e4d61ce70aa3f44db7618714c7ccf5?context=repo)

( No setup necessary. Kubuntu GUI also included with [ubuntu-gui](https://hub.docker.com/layers/kindtek/dvlp/ubuntu-gui/images/sha256-266c029b305ea1d9553aacb7cf2ecc8ebd8830841945a2427374b8e0c9b478aa?context=repo), [ubuntu-cuda](https://hub.docker.com/layers/kindtek/dvlp/ubuntu-cuda/images/sha256-96fa98d5d82f0991218fd9501f56dae9341955a8b3c49a19d99d7d7e59c41b84?context=repo), and [ubuntu-cuda-plus](https://hub.docker.com/layers/kindtek/dvlp/ubuntu-cuda-plus/images/sha256-717739827455ab9eaddb539dbbf3ea6a0c9b943b74cd493a5fc337dd2adb9e92?context=repo) ) 


### [CLICK for more details](https://github.com/kindtek/devels-playground#idle-minds-are-the-developers-playground)


---

---

&nbsp;

MIT License

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
