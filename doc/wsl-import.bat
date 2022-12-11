@echo off
:redo
ECHO  ___________________________________________________________________ 
ECHO /                          DEV BOILERPLATE                          \
ECHO \___________________    WSL image import tool    ___________________/
ECHO   .................................................................
ECHO   .............    Default options in (parentheses)   .............
ECHO   .................................................................

ECHO Press ENTER to continue.
@REM ECHO Enter any other key to exit.

SET /p "continue=(continue) > "

@REM IF NOT "%continue%"=="(continue) > "  ( goto quit ) 


SET username=dev0
ECHO username:
SET /p "username=(%username%) > "

SET groupname=dev
ECHO group name:
SET /p "groupname=(%groupname%) > "

SET image_repo=kindtek
SET /p "image_repo=image repository: (%image_repo%) > "

SET image_name=dbp_docker-git-cdir
SET /p "image_name=image name in %image_repo%: (%image_name%) > "

SET install_directory=wsl-distros
SET /p "install_directory=installation folder: %mount_drive%:\(%install_directory%) > "
SET save_directory=docker
SET /p "save_directory=download folder: %mount_drive%:\%install_directory%\(%save_directory%) > "


SET install_location=%mount_drive%:\%install_directory%
SET save_location=%install_location%\%save_directory%

SET distro_orig=%image_name%-%username%
SET distro=%distro_orig%
SET /p "distro=Save image as: %save_location%\(%distro%).tar > "
SET %image_save_path%=%save_location%\(%distro%).tar



@REM directory structure: 
@REM %mount_drive%:\%install_directory%\%save_directory%
@REM ie: C:\wsl-distros\docker

SET mount_drive=C

ECHO setting up install directory (%install_directory%)...
mkdir %install_location%
ECHO DONE
ECHO setting up save directory (%save_directory%)...
mkdir %save_location%
ECHO DONE
ECHO -----------------------------------------------------------------------------------------------------
wsl --list
ECHO -----------------------------------------------------------------------------------------------------
ECHO Check the list of current WSL distros installed on your system above. 
ECHO If %distro% is already listed above it will be REPLACED.
ECHO Use CTRL-C to quit now if this is not what you want.
ECHO -----------------------------------------------------------------------------------------------------
ECHO CONFIRM YOUR SETTINGS
ECHO username: %username%
ECHO group name: %groupname%
ECHO image source/name: %image_repo%/%image_name%
ECHO image destination: %image_save_path%
ECHO WSL alias: %distro%
ECHO -----------------------------------------------------------------------------------------------------

ECHO pulling image (%image_name%) from repo (%image_repo%)...
ECHO saving as %image_save_path%...
docker save %image_repo%/%image_name% > %image_save_path%

ECHO DONE

:askagain

ECHO Would you still like to continue (yes/no/redo)?
SET /p "continue="


IF %continue%==yes ( goto install ) ELSE IF %continue%==no ( goto quit ) ELSE IF %continue%==redo ( goto redo )

goto askagain


:install
ECHO killing current the WSL %distro% process if it is running...
wsl --terminate %distro%
ECHO DONE

ECHO killing all WSL processes...
wsl --shutdown
ECHO DONE

ECHO deleting WSL distro %distro% if it exists...
wsl --unregister %distro%
ECHO DONE

ECHO importing  %distro%.tar to %install_location% as %distro%
wsl --import %distro% %install_location% .\%distro%.tar
ECHO DONE

ECHO setting  %distro% as default
wsl --set-default %distro%
ECHO DONE

@REM wsl --shutdown
wsl -l -v
wsl 

:quit
echo goodbye
