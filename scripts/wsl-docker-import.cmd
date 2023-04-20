@echo off
@REM this file is solid but will be deprecated once wsl-import.ps1 is fixed
color 0F
SETLOCAL EnableDelayedExpansion
:redo
SET "module=main"
SET "options=config"
SET wsl_version=2
SET save_directory=docker2wsl
SET mount_drive=C

@REM SET image_repo=_
@REM SET image_repo_mask=official
@REM SET image_name=kali:latest
SET image_repo=kindtek
SET image_repo_mask=kindtek
SET "image_tag=%~1"
SET "non_interactive=%~2"
SET non_interactive=%non_interactive: =%
SET "options=%~3"
IF "!options!"=="default" (
    SET "default_distro=y"
) ELSE (
    SET "default_distro=n"
)

IF "!image_tag!"=="" (
    SET "image_tag=default"
) 
IF "!image_tag!"=="default" (
    SET image_repo=_
    SET image_repo_mask=official
    SET "image_tag=latest"
    SET "image_name=ubuntu:!image_tag!"
    @REM ECHO "image_tag set to !image_tag!"
) ELSE (
    SET "image_tag=%1"
    SET "image_name=devels-playground:!image_tag!"
    @REM ECHO "image_tag set to arg: '%1'  ('%~1') as !image_tag!"
)
    

IF "!non_interactive!"=="" (
    SET "interactive=y"
) ELSE (
    SET "interactive=n"
)

SET "install_directory=!image_repo_mask!-!image_name::=-!"
SET "save_location=!mount_drive!:\!save_directory!"
SET "install_root_dir=!save_location!\!install_directory!"
@REM distro - meaning local distro
SET "distro=!install_directory!"
@REM :header
SET "image_save_path=!save_location!\!distro!.tar"
SET "install_root_dir=!save_location!\!install_directory!"
SET "image_repo_image_name=!image_repo!/!image_name!"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF !image_repo!==_ (
    @REM official repo has no repo name in address/url
    SET "image_repo_image_name=!image_name!"
) 
SET "docker_image_id_path=!install_root_dir!\.image_id"
SET "docker_container_id_path=!install_root_dir!\.container_id"


:show_config_banner
@REM CLS

SET "module=show_config_banner"
ECHO:
ECHO  _____________________________________________________________________ 
ECHO /                          DEVEL'S PLAYGROUND                         \
ECHO \______________  WSL import tool for Docker Hub images  ______________/
ECHO   -------------------------------------------------------------------
ECHO   .............    Image settings                       .............
ECHO   .............-----------------------------------------.............
ECHO   .............    source:                              .............
ECHO   .............      !image_repo_mask!                            .............
ECHO   .............                                         .............
ECHO   .............    name:                                .............
ECHO   .............      !image_name!                   
ECHO   .............                                         .............
ECHO   .............    download to:                         .............
ECHO   .............       !image_save_path! 
ECHO   .............                                         .............
ECHO   .............    WSL alias:                           .............
ECHO   .............       !distro!          
IF "!options!"=="default" (
    ECHO   .............                                         .............
    ECHO   .............    default:                             .............
    ECHO   .............      yes                                .............

)
ECHO   -------------------------------------------------------------------

:start_main_prompt
SET "module=start_main_prompt"
SET above=above
IF "!interactive!"=="n" (
    @REM official repo has no repo name in address/url
    goto set_vars
)
IF defined failed_before (
    IF !fail_count! GTR 2 (
        SET fail_count=0
        ECHO fail_count
        echo !fail_count!
        goto error_restart_prompt
    ) ELSE (        
        IF fail_count==3 (
            SET fail_count=4
        )
        IF fail_count==2 (
            SET fail_count=3
        )
        IF fail_count==1 (
            SET fail_count=2
        )
        IF fail_count==0 (
            SET fail_count=1
        )
    )
)

ECHO:
ECHO:
ECHO Confirm !above! settings.
ECHO: 
ECHO: 
ECHO: 
ECHO    Press ENTER to import !image_name! into WSL as !distro!
ECHO        ..or type [o]ptions to see more options

@REM @TODO: add options ie: 
@REM ECHO   ..or type:
@REM ECHO           - 'registry' to specify distro from a registry on the Docker Hub
@REM ECHO           - 'image' to import a local Docker image
@REM ECHO           - 'container' to import a running Docker container
@REM @TODO: (and eventually add numbered menu)
ECHO:
SET /p "confirm=$ "
IF "!confirm!"=="o" (
    SET "confirm=options"
)
IF "!confirm!"=="options" (
    SET "options=options"
    goto prompt_options
) ELSE (
    IF "!confirm!"=="" (
        SET "options="
        goto set_vars
    ) ELSE (
        SET "options=!confirm!"
        goto parse_options
    )
)

:custom_config
SET "module=custom_config"
if "!interactive!"=="n"(
    goto quit
)
if "!options!"=="c" (
    SET "options=config"
)
@REM prompt user to type input or hit enter for default shown in parentheses
if "!options!"=="config" (

    color 0B

    @REM @TODO: filter/safeguard user input
    ECHO:
    SET /p "image_repo=image repository: (!image_repo_mask!) $ "

    SET /p "image_name=image name in !image_repo_mask!: (!image_name!) $ "

    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF "!image_repo!"=="_" (
        SET "image_repo_image_name=!image_name!"
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
        SET "image_repo_image_name=!image_repo_mask!/!image_name!"
    )

    SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    SET install_directory=!image_repo_image_name:/=-!
    SET install_directory=!install_directory::=-!

    SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
    SET install_directory=!install_directory:/=-!
    SET install_directory=!install_directory::=-!
    @REM not possible to set this above bc it will overlap with the default initializing so set it here
    SET save_location=!mount_drive!:\!save_directory!
    SET install_root_dir=!save_location!\!install_directory!
    @REM special rule for official distro
    if "!image_repo!"=="_" (
        SET "distro=official-!install_directory!"
    ) ELSE (
        SET "distro=!install_directory!" 
    )

    SET /p "distro=distro name in WSL: (!distro!) $ "
    SET "distro=!distro::=-!"
    SET "distro=!distro:/=-!"

    SET /p "wsl_version=WSL version: (!wsl_version!) $ "
    IF "!wsl_version!"=="2" (
        SET "wsl_version=2"
    ) ELSE (
        SET "wsl_version=1" 
    )
    ECHO:
    SET "options="
    ECHO Press ENTER to import !distro! as a distro into WSL
    ECHO:   or enter [o]ptions to see more options
    SET /p "options=$ "
    IF "!options!"=="" (
        SET "options=import"
        goto set_vars
    )
    IF "!options!"=="o" (
        SET "options=options"
    )
    IF "!options!"=="options" (
        goto prompt_options
    ) ELSE (
        goto parse_options
    )


    color 0F
) ELSE (
    IF "!options!"=="exit" (
        goto quit
    )
    IF "!options!"=="x" (
        goto program_restart_prompt
    )
)

:set_vars
SET "module=set_vars"
for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do set %%x
set "timestamp=%Year%%Month%%Day%"
SET timestamp_id=!timestamp!_%TIME:*.=%
SET "install_location=!install_root_dir!\!timestamp!\!timestamp_id!"
SET "save_location=!save_location!"
IF NOT "!distro!"=="official-ubuntu-latest" (
    SET "distro=!distro!-!timestamp_id!"
)
SET "docker_image_id_path=!install_location!\.image_id"
SET "docker_container_id_path=!install_location!\.container_id"
SET "image_save_path=!save_location!\!distro!.tar"

@REM directory structure: 
@REM !mount_drive!:\!install_directory!\!save_directory!
@REM ie: C:\wsl-distros\docker
mkdir !save_location! > nul 2> nul
mkdir !install_location! > nul 2> nul

:docker_image_container_start
SET "module=docker_image_container_start"

ECHO ========================================================================
ECHO:
ECHO pulling image (!image_repo_image_name!)...
ECHO docker pull !image_repo_image_name!
@REM pull the image
docker pull !image_repo_image_name!
ECHO:
ECHO initializing the image container...
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker images -aq !image_repo_image_name! > !docker_image_id_path!"
docker images -aq !image_repo_image_name! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
@REM ECHO WSL_DOCKER_IMG_ID_RAW: !WSL_DOCKER_IMG_ID_RAW!
SET WSL_DOCKER_IMG_ID=!WSL_DOCKER_IMG_ID_RAW!
del !docker_container_id_path! > nul 2> nul
IF "!options!"=="c" (
    SET "options=config"
)
IF "!options!"=="config" (
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
    color 02
    ECHO docker run -it --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    docker run -it --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    color 0F
    ECHO:
    ECHO closing preview container...
    ECHO:
    ECHO ========================================================================
) ELSE (
    ECHO docker run -dit --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID!
    docker run -dit --cidfile !docker_container_id_path! !WSL_DOCKER_IMG_ID! 

)

SET /P WSL_DOCKER_CONTAINER_ID=<!docker_container_id_path! > nul
if "!WSL_DOCKER_CONTAINER_ID!"=="" (
    ECHO An error occurred. Missing container ID. Please try again
    SET above=previous
    SET failed_before=y
    goto error_restart_prompt
)
ECHO:
ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
ECHO docker export !WSL_DOCKER_CONTAINER_ID! ^> !image_save_path!
@set /A _tic=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul

docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!

@set /A _toc=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul
@set /A _elapsed=%_toc%-%_tic
@REM IF !_elapse! LEQ 1 (
@REM     ECHO Docker export failure
@REM     goto error_restart_prompt
@REM     )
ECHO DONE

:wsl_list
SET "module=wsl_list"

ECHO ---------------------------------------------------------------------
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO ---------------------------------------------------------------------
ECHO Check the list of current WSL distros installed on your system above. 
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!                   WARNING:                ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO If !distro! is already listed above it will be REPLACED.  
ECHO ^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!^^!
ECHO _____________________________________________________________________

:install_prompt
SET "module=install_prompt"
if "!interactive!"=="n"(
    goto quit
)
ECHO:
IF "!interactive!"=="n" (
    SET "continue=install"
    goto install
) ELSE (
    SET "options="
)
ECHO Would you still like to continue (y/n/redo)?
SET /p "continue="

@REM if blank -> yes 
IF "!continue!"=="" ( 
    SET "continue=y"
)

@REM if y -> yes 
IF !continue!==y ( 
    SET "continue=install"
)
IF "!continue!"=="yes" ( 
    SET "continue=install"
)

@REM if n -> no
IF "!continue!"=="n" ( 
    SET "continue=no"
)

@REM if label exists goto it
goto !continue!

@REM otherwise... use the built in error message and repeat install prompt
goto install_prompt

@REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default distro
@REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes distro default

:yes
:install
SET "module=install"


if "!distro!"=="official-ubuntu-latest" (
    ECHO:
    ECHO deleting WSL distro !distro! if it exists...
    ECHO wsl --unregister !distro!
    wsl --unregister !distro!
    ECHO DONE
)

ECHO:
ECHO importing !distro!.tar to !install_location! as !distro!...
ECHO wsl --import !distro! !install_location! !image_save_path! --version !wsl_version!
@set /A _tic=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul

wsl --import !distro! !install_location! !image_save_path! --version !wsl_version!

@set /A _toc=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul
@set /A _elapsed=%_toc%-%_tic
@REM IF !_elapse! LEQ 1 (
@REM     ECHO WSL import failure
@REM     SET "failed_before=y"
@REM     goto error_restart_prompt
@REM )
ECHO DONE
IF "!default_distro!"=="y" (
    SET "options=yes"
)
if "options"=="yes" (
    goto set_default_distro
) ELSE (
    IF "interactive"=="n" (
        goto wsl_or_exit
    ) ELSE (
        ECHO: 
        ECHO press ENTER to import !distro! as the default WSL distro
        ECHO  ..or enter any character to skip
        SET /p "setdefault=$ "
        IF "!setdefault!"=="" (
            SET "default_distro=y"
        )
    )
)


:set_default_distro
SET "module=set_default_distro"
IF "!default_distro!"=="y" (

    SET "options=default"
    ECHO:
    ECHO setting default WSL distro as !distro!...
    ECHO  wsl --set-default !distro! 
    wsl --set-default !distro! 
    ECHO DONE!
    ECHO:
    ECHO  ..if starting WSL results in an error, try converting the distro version to WSL1 by running:
    ECHO wsl --set-version !distro! 1
    ECHO:
    goto wsl_or_exit
)

:wsl_or_exit
SET "module=wsl_or_exit"

@REM make sure windows paths transfer
SET WSLENV=USERPROFILE/p
ECHO Windows Subsystem for Linux Distributions:
wsl -l -v
ECHO:
wsl --status
ECHO:
IF "!interactive!"=="y"(
    ECHO press ENTER to open !distro! in WSL
    ECHO  ..or enter any character to skip 
    @REM make sure windows paths transfer
    SET WSLENV=USERPROFILE/p 
    SET /p "exit=$ "
)
IF "!exit!"=="" (
    ECHO:
    ECHO launching WSL with !distro! distro...
    ECHO wsl -d !distro!
    ECHO:
    @set /A _tic=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul

        wsl -d !distro!

    @set /A _toc=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul
    @set /A _elapsed=%_toc%-%_tic
    IF !_elapse! LEQ 1 (
        ECHO ERROR DETECTED
        IF "!options!"=="default" (
            ECHO reverting back to official ubuntu latest distro
            wsl -s official-ubuntu-latest
        )
        ECHO trying to convert distro version to WSL1 with:
        ECHO wsl --set-version !distro! 1
        wsl --set-version !distro! 1
        @set /A _tic=%time:~0,2%*3600^
                    +%time:~3,1%*10*60^
                    +%time:~4,1%*60^
                    +%time:~6,1%*10^
                    +%time:~7,1% >nul

        wsl -d !distro!

        @set /A _toc=%time:~0,2%*3600^
                    +%time:~3,1%*10*60^
                    +%time:~4,1%*60^
                    +%time:~6,1%*10^
                    +%time:~7,1% >nul
        @set /A _elapsed=%_toc%-%_tic
        IF !_elapse! LEQ 1 (
            ECHO WSL is down.
            SET "failed_before=y"
            goto error_restart_prompt
        )
    )
)

:error_restart_prompt:
@REM SET "module=error_restart_prompt"
SET "prompt_type=error_restart"
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO Sorry - import failed. 
IF "!interactive!"=="n" (
    goto quit
)
SET "failed_before=y"
ECHO:
:program_restart_prompt
if "!interactive!"=="n"(
    goto quit
)
@REM SET "module=program_restart_prompt"
COLOR 04
SET "prompt_type=restart"

ECHO:
@REM CLS
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:


ECHO Press ENTER to exit program
ECHO        ..or enter [o]ptions to see more options
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:



SET /p "exit_devels_playground="
COLOR 0F

IF "!exit_devels_playground!"=="x" (
    goto quit
)
IF "!exit_devels_playground!"=="exit" (
    goto quit
)
IF "!exit_devels_playground!"=="" (
    goto quit
) ELSE (
    SET "options=!exit_devels_playground!"
    goto parse_options
)
goto prompt_options
:computer_restart_prompt
if "!interactive!"=="n"(
    goto quit
)
@REM SET "module=program_restart_prompt"
SET "prompt_type=restart"
COLOR 4E
@REM CLS
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:


ECHO Press ENTER to restart this computer
ECHO        ..or enter [o]ptions to see more options
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
SET /p "options=$ "
IF "!options!"=="" (
@REM dism /Online /Cleanup-Image /RestoreHealth
    ECHO "initializing restart ..."
    shutdown /r
    goto quit
)
IF "!options!"=="o" (
    SET "options=options"
)
IF "!options!"=="options" (
    COLOR 0F
    goto prompt_options
) ELSE (
    IF "!options!"=="r" (
        SET "options=restart"
    )
    IF "!options!"=="restart" (
        shutdown /r
    ) ELSE (
        COLOR 0F
        goto parse_options
    )
    
)

:prompt_options:
@REM SET "module=prompt_options"
SET "prompt_type=normal"
IF "!options!"=="o" (
    SET "options=options"
)
IF "!options!"=="options" (
    if "!interactive!"=="n"(
        goto quit
    )
    ECHO:
    ECHO    Options:

    IF "!module!"=="wsl_or_exit" (
        ECHO        [c]onfig    configure import settings
        ECHO        [d]efault   set !distro! as default WSL distro
    ) ELSE  (
        IF "!module!"=="custom_config" (
            ECHO        [c]onfig    edit !image_repo_image_name! import configuration
        ) ELSE (
            ECHO        [c]onfig    configure import settings
        )
        ECHO        [i]mport    import !image_repo_image_name! image into WSL
        ECHO        [d]efault   import !image_repo_image_name! image into WSL and set as default distro
    )
    
    ECHO        [r]estart   **restart computer**
    ECHO        e[x]it      exit
    ECHO:
    SET /p "options=$ "
)
:parse_options
color 0F
@REM SET "module=parse_options"

IF "!options!"=="i" (
    goto set_vars
)
IF "!options!"=="import" (
    ECHO option 'import' selected
    goto set_vars
)
IF "!options!"=="c" (
    goto custom_config
)
IF "!options!"=="config" (
    ECHO option 'config' selected
    goto custom_config
)
IF "!module!"=="wsl_or_exit" (
    IF "!options!"=="d" (
        SET "default_distro=y"
        ECHO option 'default' selected
        goto set_default_distro
    )
    IF "!options!"=="default" (
        SET "default_distro=y"
        ECHO option 'default' selected
        goto set_default_distro
    )
) ELSE (
    IF "!options!"=="d" (
        ECHO option 'default' selected
        SET "options=default"
    )
    IF "!options!"=="default" (
        SET "default=default"
        ECHO option 'default' selected
        goto docker_image_container_start
        SET "default="
    )
)
IF "!options!"=="o" (
    goto prompt_options
)
IF "!options!"=="options" (
    goto prompt_options
)
IF "!options!"=="r" (
    SET "options=restart"
)
IF "!options!"=="restart" (
    ECHO option 'restart' selected
    goto computer_restart_prompt
)
IF "!options!"=="x" (
    goto program_restart_prompt
)
IF "!options!"=="exit" (
    goto quit
)
start cmd.exe /k !options!

:quit
:no
:exit
@REM ECHO exiting from module !module!
ECHO exiting devel's playground
ECHO goodbye.
ECHO:
