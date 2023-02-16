@REM this is useful for when docker refuses to start due to a bad wsl distro set as default or ...
@REM ..if docker hangs when it tries to start
@REM also try deleting the .docker folder in user directory (C:\Users\xxxx)

SET prompt=prompt
:prompt

SET /p "prompt=[u]nregister docker desktop containers, [s]tart docker service (admin req), [r]eset wsl default distro, or [reboot] windows ?"
goto %prompt%

:u
@REM force restart for docker containers
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
"C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
goto prompt

:s
"C:\Windows\System32\net.exe" start "com.docker.service"
goto prompt

@REM reset default wsl distro
:r
wsl -s Ubuntu-20.04
goto prompt

:reboot
@REM restart windows
@REM shutdown -r -t 0