@echo off
color F
SETLOCAL EnableDelayedExpansion
on break goto quit
:redo
@REM set default variables. set default literally to default
SET default=default
SET image_repo=_
@REM _mask = human readable
SET image_repo_mask=official
SET image_name=ubuntu
SET mount_drive=C
SET save_directory=docker

SET "install_directory=%image_repo%-%image_name::=-%"
SET "install_directory_mask=%image_repo_mask%-%image_name::=-%"

SET "save_location=%mount_drive%:\%save_directory%"
SET "install_location=%save_location%\%install_directory%"
SET "distro=%image_repo%-%image_name::=-%"
SET "distro_mask=%image_repo_mask%-%image_name::=-%"
:header
SET save_location=%mount_drive%:\%save_directory%
SET image_save_path=%save_location%\%distro%.tar
SET image_save_path_mask=!image_save_path:%distro%=%distro_mask%!

SET "install_location=%save_location%\%install_directory%"
SET image_repo_image_name=%image_repo%/%image_name%
SET image_repo_image_name_mask=%image_repo_mask%/%image_name%
SET docker_image_id_path=%install_location%\.image_id
SET docker_container_id_path=%install_location%\.container_id
SET image_tag=%image_name:_/:=%
SET image_repo_image_name=!image_repo!/!image_name!

CLS
ECHO:
ECHO  ___________________________________________________________________ 
ECHO /                          DEV BOILERPLATE                          \
ECHO \_______________  WSL import tool for Docker images  _______________/
ECHO   -----------------------------------------------------------------
ECHO   .............    Image settings                     .............
ECHO   .............---------------------------------------.............
ECHO   .............    source:                            .............
ECHO   .............      !image_repo_mask!                         .............
ECHO   .............                                       .............
ECHO   .............    name:                              .............
ECHO   .............      !image_name!                           .............
ECHO   .............                                       .............
ECHO   .............    download to:                       .............
ECHO   .............       !image_save_path_mask!   .............
ECHO   .............                                       .............
ECHO   .............    WSL alias:                         .............
ECHO   .............       !distro_mask!                 .............
ECHO   -----------------------------------------------------------------

IF %default%==config ( goto custom_config )

IF "%default%"=="" ( 
    default=confirm
    goto confirm
)

@REM default equals default if first time around
IF %default%==notdefault ( 
    default=defnotdefault
    goto confirm 
)

IF %default%==defnotdefault ( 
    goto confirm
)

IF NOT %default%==default (goto %default%)

ECHO:
ECHO:
ECHO Press ENTER to use settings above and import %distro_mask% as default WSL distro 
ECHO:
ECHO   ..or type "config" for custom install.
ECHO:
ECHO:
SET /p "default=$ "

@REM catch when default configs NOT chosen AND second time around for user who chose to customize
@REM display header but skip prompt when user chooses to customize install
@REM IF %default%==config ( goto header )

:custom_config

if %default%==config (

    color B

    @REM TODO: fix config and default using same save_location, install_location, image_id, and container_id
    ECHO:
    IF !image_repo!=="_" (
        SET image_repo=official
    )
    SET /p "image_repo=image repository: (!image_repo_mask!) $ "

    @REM special rule for official distros on docker hub
    @REM replaces 'official' with '_' for printing
    IF image_repo==%image_repo_mask% (
        SET image_repo=_
    )
    SET /p "image_name=image name in !image_repo_mask!: (!image_name!) $ "

    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF %image_repo%==_ (
        SET image_repo_mask=official
        SET "image_repo_image_name=!image_name!"
        SET "image_repo_image_name_mask=!image_repo_mask!/!image_name!"


    ) else (
        SET "image_repo_image_name=!image_repo!/!image_name!" 
        SET "image_repo_image_name_mask=!image_repo_mask!/!image_name!"
    
    )

    SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    SET install_directory=!image_repo_image_name:/=-!
    SET install_directory=!install_directory::=-!





    ECHO Save image as:
    @REM special rule for official distro
    if !image_repo!==_ (
        SET install_directory=official
        SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
        @REM not possible to set this above bc it will overlap with the default initializing so set it here
        SET save_location=!mount_drive!:\!save_directory!
        SET install_location=!save_location!\!install_directory_mask!
        SET install_location_mask=!save_location!\!install_directory!
        SET "distro=!image_name::=-!"
        SET /p "distro=!install_location!\(!distro!).tar $ "
        SET "distro=!distro::=-!"
    ) else (
        SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory_mask!) $ "
        @REM not possible to set this above bc it will overlap with the default initializing so set it here
        SET save_location=!mount_drive!:\!save_directory!
        SET install_location=!save_location!\!install_directory!
        SET install_location_mask=!save_location!\!install_directory_mask!
        SET "distro=!image_repo!-!image_name::=-!"
        SET /p "distro=!install_location!\(!distro!).tar $ "
        SET "distro=!distro::=-!"
    )
        

    color F
)

ECHO "install location: !install_location_mask!"
SET docker_image_id_path=%install_location%\.image_id
SET docker_container_id_path=%install_location%\.container_id
SET image_save_path=%save_location%\%distro%.tar

@REM directory structure: 
@REM %mount_drive%:\%install_directory%\%save_directory%
@REM ie: C:\wsl-distros\docker
mkdir !save_location! > nul 2> nul
mkdir !install_location! > nul 2> nul

:docker_image_container_start
ECHO =====================================================================
ECHO pulling image (!image_repo_image_name_mask!)...

@REM pull the image

docker pull !image_repo_image_name!
ECHO initializing the image container...
docker images -aq !image_repo_image_name! > !docker_image_id_path!
@REM ECHO !docker_container_id_path!

SET /P _WSL_DOCKER_IMG_ID=<!docker_image_id_path!

del !docker_container_id_path! > nul 2> nul

IF %default%==config (
    ECHO: 
    
    ECHO =====================================================================

    ECHO:
    ECHO opening container preview...
    ECHO:
    ECHO:
    ECHO:
    ECHO this container is running as a local copy of the image !image_repo_image_name_mask!
    ECHO:
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^! IMPORTANT: type 'exit' then ENTER to exit container preview ^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO:
    ECHO:
    color 2
    docker run -it --cidfile !docker_container_id_path! !_WSL_DOCKER_IMG_ID!
    color F

    ECHO =====================================================================
) ELSE (
    docker run -dit --cidfile !docker_container_id_path! !_WSL_DOCKER_IMG_ID! 
)


@REM ECHO !docker_container_id_path!
@REM set /p _WSL_DOCKER_IMG_ID=<docker ps -alq !image_repo!:!image_tag!
 
@REM SET /p _WSL_DOCKER_IMG_ID=(imageid_!_WSL_DOCKER_IMG_ID!)
SET /P _WSL_DOCKER_CONTAINER_ID=<!docker_container_id_path!

docker export !_WSL_DOCKER_CONTAINER_ID! > !image_save_path!
ECHO DONE


:wsl_list
ECHO ---------------------------------------------------------------------
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO ---------------------------------------------------------------------
ECHO Check the list of current WSL distros installed on your system above. 
ECHO If !distro_mask! is already listed above it will be REPLACED.
ECHO _____________________________________________________________________

:install_prompt
ECHO:
ECHO Would you still like to continue (y/n/redo)?
SET /p "continue="

@REM if blank -> yes 
IF "%continue%"=="" ( 
    SET continue=y
)

@REM if y -> yes 
IF %continue%==y ( 
    SET continue=install
)

@REM if n -> yes no
IF %continue%==n ( 
    SET continue=no
)

@REM if label exists goto it
goto %continue%

@REM otherwise... use the built in error message and repeat install prompt
goto install_prompt

@REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default distro
@REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes distro default

:yes
:install
ECHO:
ECHO killing the !distro_mask! WSL process if it is running...
wsl --terminate !distro_mask!
ECHO DONE
@REM ECHO:
@REM ECHO killing all WSL processes...
@REM wsl --shutdown
@REM ECHO DONE

if NOT default==yes (
    ECHO deleting WSL distro !distro_mask! if it exists...
    wsl --unregister !distro_mask!
    ECHO DONE
)

ECHO:
ECHO importing !distro_mask!.tar to !install_location! as !distro_mask!...
wsl --import !distro_mask! !install_location! !image_save_path!
ECHO DONE


if default==yes (
    goto set_default
) else (
    ECHO press ENTER to set !distro_mask! as default WSL distro
    ECHO  ..or enter any character to skip
    SET /p "setdefault=$ "
    IF "%setdefault%"=="" (

:set_default
        ECHO:
        ECHO setting default WSL distro as !distro_mask!...
        wsl --set-default !distro_mask!
        ECHO DONE!
        ECHO:
        ECHO  ..if starting WSL results in an error, try converting the distro version to WSL1 by running:
        ECHO wsl --set-version !distro_mask! 1
        ECHO:
        goto wsl_or_exit
    )

)

:wsl_or_exit
@REM wsl --shutdown
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO:
wsl --status
ECHO:
ECHO press ENTER to open !distro_mask! in WSL
ECHO  ..or enter any character to skip 
SET /p "exit=$ "
IF "%exit%"=="" (
    ECHO:
    ECHO default WSL with default distro...
    ECHO if WSL fails to start try converting the distro version to WSL1:
    ECHO wsl --set-version !distro! 1
    ECHO:
    wsl 
)
:quit
:no
:exit
echo goodbye
