# Idle Hands are the **Developer's Workshop**

## One line of code will free up your time and energy to do more productive things when you need to set up a developer environment. With little more than a few key strokes you will have a suite of development tools at your fingertips. Notable Windows features turned on in the process will be WSL2, Hyper-V, Windows Terminal (with upgraded powershell). Notable developer applications include Github CLI, VSCode, Docker Desktop, and WinGet

&nbsp;

## When all the above software is finished installing, there will be an option to launch the Devel's Playground WSL Docker import tool. It demonstrates how easy it is to wrap this portable containerized developer environment around a separate standalone repo. More updates coming soon including macOS support

&nbsp;

### Easy as 1, 2, 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions and restart program/device as needed
3. ??
4. Profit

```bat
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

<!-- ###### also found in [[copypasta.cmd](scripts/powerhell-remote/copypasta.cmd)] -->

&nbsp;

---

## Devel's Playground

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
