# Easy WSL Dev Setup

## Set up your Windows 10+ dev environment with WSL, Github, VSCode, Docker Desktop, Windows Terminal (with upgraded Powershell) all with one of line code. macOS will be supported soon
&nbsp;

## More info and screenshots to come. For now, run the following command in any terminal
### (doesn't matter if CMD or Powershell - but preferably with admin privileges)

`powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/docker-to-wsl/install.ps1 -OutFile install-kindtek-docker-to-wsl.ps1; powershell -executionpolicy remotesigned -File install-kindtek-docker-to-wsl.ps1"`

<br/><br/><br/><br/><br/><br/><br/><br/>
## *The following is for the Dev Boilerplate tool only which will automatically launch once all dependencies are installed*
<br/><br/>
# Import Docker images to WSL

## In Windows, clone this repo with git and run [WSL import tool script](scripts/wsl-import.bat)

`git clone https://github.com/kindtek/docker-to-wsl`

`scripts\wsl-import`

## 0) [Example] Continually hit ENTER to import latest ubuntu docker image stored on the hub with default settings

## 1) instead of pressing ENTER, type "config" then hit ENTER to specify any linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL and customize the save location, distro name, and WSL version

## 2) fork this repo and modify the Docker (-compose) files to build your own custom Docker image, push the image to a repo on Docker Hub, and import the image onto any Windows machine that is running Docker Desktop (see #1 above) for a ready-to-go dev environment in WSL

### Requirements: github, WSL2, Docker Desktop (running), Visual Studio Code (optional)

### fwiw: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])
