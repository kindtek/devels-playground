# Idle Minds are the **Devel's Playground**

## Setup Instructions

&nbsp;

### For **Windows Github** users with **WSL2** setup and **Docker Desktop** _running_, run this in a terminal to clone the repo and start the Docker import tool

```bat
git clone https://github.com/kindtek/devels-playground
scripts\wsl-import-docker-image
```

&nbsp;

### All other Windows users follow [these short instructions](https://github.com/kindtek/devels-workshop#idle-hands-are-the-devels-workshop)

&nbsp;

---

## Instructions for importing any image from [hub.docker.com](https://hub.docker.com/) into WSL

&nbsp;

### _0. [Example default Ubuntu WSL setup] When the program loads, at the main menu hit ENTER when prompted a few times to import latest Ubuntu Docker image stored on the hub with default settings_

### 1. At the main menu, type "config" then hit ENTER to specify any Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL. The format is

- source: [kindtek](https://hub.docker.com/u/kindtek)
- name: [d2w](https://hub.docker.com/r/kindtek/d2w/tags):[ubuntu-skinny](https://hub.docker.com/layers/kindtek/d2w/ubuntu-skinny/images/)

---

#### **Note: This is for development use only. Use at your own risk**

#### _FWIW: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])_

&nbsp;
&nbsp;&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
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
