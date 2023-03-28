# Idle Hands are the **Developer's Workshop**

## Import a Linux Docker image from the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) into WSL virtually without lifting a finger

---

---

## SETUP

### Easy as 1, 2, .., 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions, restart device, and repeat step one as needed
3. ??
4. KERNEL!

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell/dvl-works/download-everything-and-install.ps1 -OutFile install-kindtek-dvl-works.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-dvl-works.ps1"
```

---

## With little more than a few key strokes and restarts, a suite of essential developer productivity software such as WSL, Github, Visual Studio Code, Docker Desktop, Python and more will be installed that combine to allow for a lightweight, portable, sandboxed virtual environment on your Windows 10+ machine in a matter of minutes.

## Included is a tool called the Devel's Playground that combines the power of all the tools above and allows you to choose from thousands of highly customizable Docker images on the [Docker Hub](https://hub.docker.com/search?q=&image_filter=official) - all of which are free. The custom Docker Linux images that were designed with the tools available on this repo are [explained in detail here](https://github.com/kindtek/dvl-playg#image-tags). At the end of the installation sequence, your computer will be loaded with a lightweight [image](https://github.com/kindtek/dvl-playg#ubuntu-dind) that is built for lightning fast development - especially for teams

---

### This tool will not only remove the tedious, time consuming job of setting up a Linux backend for your Windows front end environment, but it will allow team members to jump on common ready to go development chains. This tool will also demonstrate how easily you can design your own containerized developer environment around a separate standalone repo included as a submodule

### Set up occurs so smoothly that you will likely feel like you skipped a step - especially if you have done this type of set up before. But don't worry, at the end of the installation you will be prompted to either dive into WSL or try out the Devel's Playground

---

---

&nbsp;

## Time for the fun stuff

### Import your Linux Docker image


### **Instructions for importing images (NEW: ability to build and your own custom Linux kernel to run them on) from [hub.docker.com](https://hub.docker.com/search?q=&image_filter=official) into WSL with the Devel's Playground are [found here](https://github.com/kindtek/dvl-playg#idle-minds-are-the-developers-playground)**

&nbsp;

#### NEW FEATURES
[ubuntu-kernel-builder](https://hub.docker.com/layers/kindtek/dvlp/ubuntu-kernel-builder/images/sha256-bd756e1775327d2b8ea51590ba471fdd0c4997a7d44e3f437999a60e59105a70?context=repo) image now includes: 
- pre-built Linux kernel 
- templates to build your own kernel
- enterprise grade ZFS filesystem and volume manager (Advanced: Even build/mount your own ZFS partition!)


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
