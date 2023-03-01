# Idle Hands are the **Devel's Workshop**

## Take a clean (or dirty) Windows 10+ environment and install a suite of development tools (including WSL!!) with only a few keystrokes. Effortlessly set up your environment with Github, VSCode, Docker Desktop, Windows Terminal (with upgraded Powershell), WinGet, and more. More updates coming soon including macOS support.

&nbsp;
&nbsp;

### Easy as 1, 2, 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions by hitting the ENTER and 'y' keys a few times
3. ??
4. Profit

``` bash
# run this script again if reboot needed
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/devels-workshop/install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

<!-- ###### also found in [[copypasta.bat](scripts/powershell-remote/copypasta.bat)] -->

&nbsp;

-------

## Devel's Playground  

### **Instructions for importing any image from [hub.docker.com](https://hub.docker.com/) into WSL**

#### *0. [Example] When the program loads, at the main menu hit ENTER a few times to import latest Ubuntu Docker image stored on the hub with default settings*

#### 1. At the main menu, type "config" then hit ENTER to specify any Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

- source: [kindtek](https://hub.docker.com/u/kindtek)
- name: [d2w](https://hub.docker.com/r/kindtek/d2w/tags):[ubuntu-skinny](https://hub.docker.com/layers/kindtek/d2w/ubuntu-skinny/images/)

-------

#### **Note: This is for development use only. Use at your own risk**

#### *FWIW: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])*

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
