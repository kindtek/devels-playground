# Idle Hands are the **Developer's Workshop**

&nbsp;

## One line of code pasted into a terminal will set up a ready to go developer environment on a Windows 10+ (macOS support coming soon) machine. With little more than a few key strokes, a suite of developer productivity software such as Github, VSCode, Docker Desktop will be installed on top of setting up your machine with Hyper-V, WSL, and other Virtual Machine optimization features

&nbsp;

## When set up is complete, there will be an option to launch the Devel's Playground WSL Docker import tool. Not only does it make it easy for you to import your own custom Docker images onto WSL, it demonstrates how easy it is to wrap this portable containerized developer environment around a separate standalone repo

&nbsp;

### Easy as 1, 2, 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions and restart program/device as needed
3. ??
4. Profit

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

<!-- ###### also found in [[copypasta.cmd](scripts/powerhell-remote/copypasta.cmd)] -->

&nbsp;

---

## [Devel's Playground](https://github.com/kindtek/devels-playground)

### **Instructions for importing images from [hub.docker.com](https://hub.docker.com/) into WSL**

#### _0. [Example] When the program loads, at the main menu hit ENTER a few times to import latest Ubuntu Docker image stored on the hub with default settings_

#### 1. At the main menu, type "config" then hit ENTER to specify any compatible Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

- source: [kindtek](https://hub.docker.com/u/kindtek)
- name: [d2w](https://hub.docker.com/r/kindtek/d2w/tags):[ubuntu-skinny](https://hub.docker.com/layers/kindtek/d2w/ubuntu-skinny/images/)

---

#### **Note: This is for development use only. Use at your own risk**

#### _FWIW: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])_

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
