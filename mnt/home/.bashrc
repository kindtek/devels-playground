export PATH=$PATH:/home/$LOGNAME/.local/bin:/hel/dvlw/scripts:/home/dvl/dvlw/dvlp/scripts:WSL_DISTRO_NAME=$WSL_DISTRO_NAME:_AGL=${_AGL:-agl}
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_CLI_EXPERIMENTAL=enabled
export DEBIAN_FRONTEND=dialog
alias cdir='source cdir.sh'
alias grep='grep --color=auto'
alias powershell=pwsh
alias vi="vi -c 'set verbose showmode'"