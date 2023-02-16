@echo off
color F
SETLOCAL EnableDelayedExpansion
on break goto quit
:redo
@REM set default variables. set default literally to default
SET default=default
SET image_repo=_
@REM _mask = human readable - ie 'official' not '_'
SET image_repo_mask=official
SET image_name=ubuntu:latest
SET mount_drive=C
SET save_directory=docker
SET wsl_version=2

SET "install_directory=%image_repo_mask%-%image_name::=-%"
SET "save_location=%mount_drive%:\%save_directory%"
SET "install_location=%save_location%\%install_directory%"
@REM distro: meaning local distro
SET "distro=%install_directory%"
SET "distro_mask=%distro%"
@REM :header
SET image_save_path=%save_location%\%distro_mask%.tar
SET "install_location=%save_location%\%install_directory%"
SET "image_repo_image_name=%image_repo%/%image_name%"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF %image_repo%==_ (
    SET "image_repo_image_name=%image_name%"
) 
SET "docker_image_id_path=%install_location%\.image_id"
SET "docker_container_id_path=%install_location%\.container_id"

CLS
ECHO "image_repo_image_name: !image_repo_image_name!"

ECHO:
ECHO  _____________________________________________________________________ 
ECHO /                          DEV BOILERPLATE                            \
ECHO \________________  WSL import tool for Docker images  ________________/
ECHO   -------------------------------------------------------------------
ECHO   .............    Image settings                       .............
ECHO   .............-----------------------------------------.............
ECHO   .............    source:                              .............
ECHO   .............      !image_repo_mask!                           .............
ECHO   .............                                         .............
ECHO   .............    name:                                .............
ECHO   .............      !image_name!                      .............
ECHO   .............                                         .............
ECHO   .............    download to:                         .............
ECHO   .............       !image_save_path! ..........
ECHO   .............                                         .............
ECHO   .............    WSL alias:                           .............
ECHO   .............       !distro_mask!            .............
ECHO   -------------------------------------------------------------------

ECHO:
ECHO:
ECHO Press ENTER to use settings above and import %distro_mask% as default WSL distro 
ECHO:
ECHO   ..or type 'config' for custom install.
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
    SET /p "image_repo=image repository: (!image_repo_mask!) $ "

    IF "!image_repo!"=="_" (
        SET "image_repo_mask=official"
        ECHO using an official Docker repo
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
    )


    SET /p "image_name=image name in !image_repo_mask!: (!image_name!) $ "

    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF "!image_repo!"=="_" (
        SET "image_repo_mask=official"
        SET "image_repo_image_name=!image_name!"
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
        SET "image_repo_image_name=!image_repo_mask!/!image_name!"
    )

    SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    SET install_directory=!image_repo_image_name:/=-!
    SET install_directory=!install_directory::=-!

    SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
        SET install_directory=!image_repo_image_name:/=-!
        SET install_directory=!install_directory::=-!
        @REM not possible to set this above bc it will overlap with the default initializing so set it here
        SET save_location=!mount_drive!:\!save_directory!
        SET install_location=!save_location!\!install_directory!
    @REM special rule for official distro
    if "!image_repo!"=="_" (
        SET "distro=!image_name::=-!"
    ) ELSE (
        SET "distro=!image_repo!-!image_name::=-!" 
    )

    SET "distro_mask=!distro::=-!"
    SET "distro_mask=!distro_mask:/=-!"
    SET /p "distro=filename: !install_location!\(!distro_mask!).tar $ "



    SET /p "wsl_version=WSL version: (2) $ "
    if "!wsl_version!"=="1" (
        SET "wsl_version=1"
    ) ELSE (
        SET "wsl_version=2" 
    )

    color F
)



SET docker_image_id_path=%install_location%\.image_id
SET docker_container_id_path=%install_location%\.container_id
SET image_save_path=%save_location%\%distro_mask%.tar

@REM directory structure: 
@REM %mount_drive%:\%install_directory%\%save_directory%
@REM ie: C:\wsl-distros\docker
mkdir !save_location! > nul 2> nul
mkdir !install_location! > nul 2> nul

:docker_image_container_start

ECHO ========================================================================
ECHO:
ECHO pulling image (!image_repo_image_name!)...

@REM pull the image

docker pull !image_repo_image_name!
ECHO:
ECHO initializing the image container...
docker images -aq !image_repo_image_name! > !docker_image_id_path!
@REM ECHO !docker_container_id_path!

SET /P WSL_DOCKER_IMG_ID=<!docker_image_id_path!

del !docker_container_id_path! > nul 2> nul

IF %default%==config (
    ECHO: 
    
    ECHO ========================================================================

    ECHO:
    ECHO opening container preview...
    ECHO:
    ECHO:
    ECHO:
    ECHO this container is running as a local copy of the image !image_repo_image_name!
    ECHO:
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^! IMPORTANT: type 'exit' then ENTER to exit container preview ^^!^^!^^!^^!^^!^^!
    ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
    ECHO:
    ECHO:
    color 2
    docker run -it --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    color F
    ECHO:
    ECHO closing preview container...
    ECHO:
    ECHO ========================================================================
) ELSE (
    docker run -dit --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID! 
)

@REM ECHO !docker_container_id_path!
@REM set /p WSL_DOCKER_IMG_ID=<docker ps -alq !image_repo!:!image_tag!
 
@REM SET /p WSL_DOCKER_IMG_ID=(imageid_!WSL_DOCKER_IMG_ID!)
SET /P WSL_DOCKER_CONTAINER_ID=<!docker_container_id_path! > nul
ECHO:
ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!
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
    ECHO:
    ECHO deleting WSL distro !distro_mask! if it exists...
    wsl --unregister !distro_mask!
    ECHO DONE
)

ECHO:
ECHO importing !distro_mask!.tar to !install_location! as !distro_mask!...
wsl --import !distro_mask! !install_location! !image_save_path! --version !wsl_version!
ECHO DONE


if default==yes (
    goto set_default
) else (
    ECHO: 
    ECHO press ENTER to set !distro_mask! as default WSL distro
    ECHO  ..or enter any character to skip
    SET /p "setdefault=$ "
    IF "!setdefault!"=="" (

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
    ECHO launching WSL with default distro...
    ECHO if WSL fails to start try converting the distro version to WSL1:
    ECHO wsl --set-version !distro_mask! 1
    ECHO:
    wsl -d !distro_mask!
)
:quit
:no
:exit
ECHO:
ECHO goodbye
ECHO:
