# DEV_BOILERPLATE

## To build a custom image for use in your WSL environment

```console
SET install_directory=wsl-distros\docker
SET username=dev00
SET groupname=develop
SET target=dbp_docker-git-cdir
REM ^^ optionally use image without docker and git by changing to dbp_git-cdir or dbp_cdir^^
SET distroprefix=ubuntu-dbp
RM ^^ edit for custom name of distro ^^

SET distro=%distroprefix%-%username%

cd C:\
mkdir %install_directory%
cd %install_directory%
docker save kindtek/%target% > %distro%.tar
wsl --shutdown
wsl --unregister
wsl --import %distro% %distro% .\%distro%.tar
wsl --set-default %distro%
wsl -l -v


```
