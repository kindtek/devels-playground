@echo off
SETLOCAL EnableDelayedExpansion

@REM this is useful for when docker refuses to start due to a bad wsl distro set as default or ...
@REM ..if docker hangs when it tries to start
@REM also try deleting the .docker folder in user directory (C:\Users\xxxx)

SET prompt=prompt
:prompt
ECHO [s]soft docker restart (admin req)
ECHO [u]nregister docker desktop containers
ECHO [h]ard docker service start (admin req)
ECHO [r]eset wsl default distro
ECHO [reboot] windows (^!^!)
ECHO [q]uit

SET /p "prompt=$ "
goto !prompt!

:s
net stop docker
net stop com.docker.service
taskkill /IM "dockerd.exe" /F
taskkill /IM "Docker for Windows.exe" /F
net start docker
net start com.docker.service
"C:\Program Files\Docker\Docker\Docker for Windows.exe"
goto prompt

:u
@REM force restart for docker containers
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
goto prompt

:h
"C:\Windows\System32\net.exe" start "com.docker.service"
goto prompt

@REM reset default wsl distro
:r
wsl -s Ubuntu-20.04
goto prompt

:reboot
@REM restart windows
@REM shutdown -r -t 0

:q
:quit
:exit
:end
:x