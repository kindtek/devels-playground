# Idle Hands are the Devel's Workshop

## Take a clean (or dirty) Windows 10+ environment and install a suite of dev tools (including WSL!!) with only a few keystrokes. Effortlessly set up your environment with Github, VSCode, Docker Desktop, Windows Terminal (with upgraded Powershell), WinGet, and more.  More updates coming soon including macOS support.
&nbsp;
&nbsp;
### Easy as 1, 2, 4
1. Run the command listed below command in a terminal (CMD or Powershell )
2. Confirm installations actions by hitting the ENTER key a few times
3. ??
4. Profit

```
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powershell-remote/docker-to-wsl/install.ps1 -OutFile install-kindtek-docker-to-wsl.ps1; powershell -executionpolicy remotesigned -File install-kindtek-docker-to-wsl.ps1"
```
<!-- ###### also found in [[copypasta.bat](scripts/powershell-remote/copypasta.bat)] -->

<br/><br/><br/><br/><br/><br/><br/><br/>
## *The following is for the Dev Boilerplate tool only. This will automatically launch once all dependencies are installed*
<br/><br/>
# Import Docker images to WSL

## In Windows, clone this repo with git and run [WSL import tool script](scripts/wsl-import.bat)

```
git clone https://github.com/kindtek/docker-to-wsl`
scripts\wsl-import
```

## 0) [Example] Continually hit ENTER to import latest ubuntu docker image stored on the hub with default settings

## 1) instead of pressing ENTER, type "config" then hit ENTER to specify any linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL and customize the save location, distro name, and WSL version

## 2) fork this repo and modify the Docker (-compose) files to build your own custom Docker image, push the image to a repo on Docker Hub, and import the image onto any Windows machine that is running Docker Desktop (see #1 above) for a ready-to-go dev environment in WSL

### Requirements: github, WSL2, Docker Desktop (running), Visual Studio Code (optional)

### fwiw: fork this repo and build your own dev environment by using template Docker files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]), ([[ubuntu](dockerfile.ubuntu.yaml)], [[alpine](dockerfile.alpine.yaml)])

&nbsp;
&nbsp;
### Note: This is for development use only. Use at your own risk
