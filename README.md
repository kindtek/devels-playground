# Import Docker images to WSL

## 1) In Windows (using WSL version 2 and Docker Desktop installed), run [WSL import tool script](scripts/wsl-import.bat) and hit ENTER to import docker image built with this repo's docker compose files ([[ubuntu](docker-compose.ubuntu.yaml)], [[alpine](docker-compose.alpine.yaml)]) and dockerfiles ([[ubuntu](dockerfile.ubuntu)], [[alpine](docker-file.alpine)])

## 2) instead of pressing ENTER, type "config" then hit ENTER to specify any linux distro on [hub.docker.com](https://hub.docker.com/) you would like to use with WSL

## 3) fork this repo and modify the docker (compose) files to build your own custom docker image(s) to use with the WSL import tool