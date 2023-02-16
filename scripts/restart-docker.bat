@REM this is useful for when docker refuses to start due to a bad wsl distro set as default or ...
@REM ..if docker hangs when it tries to start
@REM also try deleting the .docker folder in user directory (C:\Users\xxxx)

@REM force restart for docker containers
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon

@REM switch to wsl distro named "Ubuntu"
@REM wsl -s Ubuntu 

@REM restart windows
@REM shutdown -r -t 0