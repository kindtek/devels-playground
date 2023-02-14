@REM this is useful for when docker refuses to start due to a bad wsl distro set as default or ...
@REM ..if docker hangs when it tries to start
@REM also try deleting the .docker folder in user directory (C:\Users\xxxx)

wsl --unregister docker-desktop
wsl --unregister docker-desktop-data
@REM wsl -s Ubuntu 