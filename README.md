# Idle Minds are the Devel's Playground

# Import Docker images to WSL

## 0) [Example] hit ENTER a few times to import latest Ubuntu Docker image stored on the hub with default settings

## 1) instead of pressing ENTER, type "config" then hit ENTER to specify any Linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL and customize the save location, distro name, and WSL version. for example, if you want to install the [kindtek](https://hub.docker.com/u/kindtek) [ubuntu-skinny](https://hub.docker.com/layers/kindtek/d2w/ubuntu-skinny/images/sha256-8bd7bb3e551617bc25fbed830ecc70bb877d99b8013302336a6aea903b0cf753?context=repo) image use the format:

    - source: kindtek
    - name: d2w:ubuntu-skinny

## 2) fork this repo and modify the Docker (-compose) files to build your own custom Docker image, push the image to a repo on Docker Hub, and import the image onto any Windows machine that is running Docker Desktop (see #1 above) for a ready-to-go dev environment in WSL

### Requirements: WSL2, Github CLI, Docker Desktop (running)

### Recommended: Visual Studio Code

### FWIW: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])

&nbsp;
&nbsp;

### Note: This is for development use only. Use at your own risk
