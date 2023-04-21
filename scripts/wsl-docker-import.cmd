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
SET "image_name_tag=%~1"
SET "non_interactive=%~2"
SET "options=%~3"
IF "!options!"=="default" (
    SET "default_wsl_distro=y"
) ELSE (
    SET "default_wsl_distro=n"
)

IF "!image_name_tag!"=="" (
    SET "image_repo=_"
    SET "image_repo_mask=official"
    SET "image_tag=latest"
    SET "image_name=ubuntu"
    @REM ECHO "image_tag set to !image_tag!"
) ELSE (
    SET "image_name_tag=%1"
    SET "image_name="
    for /f "tokens=1 delims=:" %%a in ("%image_name_tag%") do (
        SET "image_name=%%a"
    )
    SET "image_tag=%image_name_tag::=" & SET "image_tag=%"
    SET "image_name_tag=!image_name!:!image_tag!"

    @REM ECHO "image_tag set to arg: '%1'  ('%~1') as !image_tag!"
)
    SET "image_name_tag=!image_tag!:!image_name!"

    

IF "!non_interactive!"=="" (
    SET "interactive=y"
) ELSE (
    SET "interactive=n"
)

SET "wsl_distro=!image_repo_mask!-!image_name!-!image_tag!"
SET "save_location=!mount_drive!:\!save_directory!"
SET "install_root_dir=!save_location!\!wsl_distro!"
@REM wsl_distro - meaning local wsl_distro
@REM :header
SET "image_save_path=!save_location!\!wsl_distro!.tar"
SET "install_root_dir=!save_location!\!wsl_distro!"
SET "image_repo_name_tag=!image_repo!/!image_name!:!image_tag!"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF !image_repo!==_ (
    @REM official repo has no repo name in address/url
    SET "image_repo_name_tag=!image_name!:!image_tag!"

) 
SET "docker_image_id_path=!install_root_dir!\.image_id"
SET "docker_container_id_path=!install_root_dir!\.container_id"


:show_banner_home_menu
@REM CLS

SET "module=show_banner_home_menu"
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
ECHO   .............    name/tag:                            .............
ECHO   .............      !image_name!:!image_tag!                   
ECHO   .............                                         .............
ECHO   .............    download to:                         .............
ECHO   .............       !image_save_path! 
ECHO   .............                                         .............
ECHO   .............    WSL alias:                           .............
ECHO   .............       !wsl_distro!          
IF "!default_wsl_distro!"=="y" (
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
    SET "options=install"
    goto parse_options
)
IF defined failed_before (
    IF fail_count GTR 2 (
        @REM SET fail_count=0
        ECHO fail_count
        echo fail_count
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
ECHO    Press ENTER to import !image_name! into WSL as !wsl_distro!
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
        goto make_dirs
    ) ELSE (
        SET "options=!confirm!"
        goto parse_options
    )
)

:custom_config
SET "module=custom_config"
if "!interactive!"=="n" (
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

    SET /p "image_name_tag=image name/tag in !image_repo_mask!: (!image_name!:!image_tag!) $ "
    SET "image_name="
    SET "image_tag="
    for /f "tokens=1 delims=:" %%a in ("%image_name_tag%") do (
        ECHO %%a
        SET "image_name=%%a"
    )
    SET "image_tag=%image_name_tag::=" & SET "image_tag=%"
    @REM SET "image_name_tag=!image_name!:!image_tag!"
    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF "!image_repo!"=="_" (
        SET "image_repo_name_tag=!image_name!:!image_tag!"
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
        SET "image_repo_name_tag=!image_repo_mask!/!image_name!:!image_tag!"
    )

    SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    SET install_directory=!image_repo_name_tag:/=-!
    SET install_directory=!install_directory::=-!

    SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
    SET install_directory=!install_directory:/=-!
    SET install_directory=!install_directory::=-!
    @REM not possible to set this above bc it will overlap with the default initializing so set it here
    SET save_location=!mount_drive!:\!save_directory!
    SET install_root_dir=!save_location!\!install_directory!
    @REM special rule for official distro
    if "!image_repo!"=="_" (
        SET "wsl_distro=official-!install_directory!"
    ) ELSE (
        SET "wsl_distro=!install_directory!" 
    )

    SET /p "wsl_distro=distro name in WSL: (!wsl_distro!) $ "
    SET "wsl_distro=!wsl_distro::=-!"
    SET "wsl_distro=!wsl_distro:/=-!"

    SET /p "wsl_version=WSL version: (!wsl_version!) $ "
    IF "!wsl_version!"=="2" (
        SET "wsl_version=2"
    ) ELSE (
        SET "wsl_version=1" 
    )
    ECHO:
    SET "options="
    ECHO Press ENTER to import !wsl_distro! as a distro into WSL
    ECHO:   or enter [o]ptions to see more options
    SET /p "options=$ "
    IF "!options!"=="" (
        SET "options=import"
        goto make_dirs
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

:make_dirs
SET "module=make_dirs"
@REM ECHO "entering module !module!"
for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do set %%x
SET "Month=0%Month%"
SET "Month=%Month:~-2%"
SET "Day=0%Day%"
SET "Day=%Day:~-2%"
SET "Hour=0%Hour%"
SET "Hour=%Hour:~-2%"
SET "Minute=0%Minute%"
SET "Minute=%Minute:~-2%"
SET "Second=0%Second%"
SET "Second=%Second:~-2%"
set "timestamp_date=%Year%%Month%%Day%"
SET "timestamp_time=%Hour%%Minute%%Second%%TIME:*.=%"
SET "install_location=!install_root_dir!\!timestamp_date!\!timestamp_time!"
SET "save_location=!save_location!"
IF NOT "!wsl_distro!"=="official-ubuntu-latest" (
    SET "wsl_distro=!wsl_distro!-!timestamp_id!"
)
SET "docker_image_id_path=!install_location!\.image_id"
SET "docker_container_id_path=!install_location!\.container_id"
SET "image_save_path=!save_location!\!wsl_distro!.tar"
@REM directory structure: 
@REM !mount_drive!:\!install_directory!\!save_directory!
@REM ie: C:\wsl-wsl_distros\docker
@REM ECHO "mkdir save: !save_location!"
mkdir !save_location! > nul 2> nul
@REM ECHO "mkdir install: !install_location!"
mkdir !install_location! > nul 2> nul
SET "dvlp_path=repos/!image_repo!/dvlw/dvlp"
ECHO DOCKER_IMG:!docker_get_image!

goto !docker_get_image!

:docker_image_pull
SET "module=docker_image_pull"

ECHO ========================================================================
ECHO:
ECHO pulling image (!image_repo_name_tag!)...
ECHO docker pull !image_repo_name_tag!
@REM pull the image
docker pull !image_repo_name_tag!
goto docker_image_run

:docker_image_build
SET "module=docker_image_build"
for /f "tokens=1 delims=-" %%a in ("%image_tag%") do (
    SET "image_distro=%%a"
)
SET "image_service=%image_tag:-=" & SET "image_service=%"
ECHO ========================================================================
ECHO:
ECHO building image (!image_service!)...
ECHO docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml build !image_service!
@REM build the image
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml build !image_service!
goto docker_image_run

:docker_image_run
SET "module=docker_image_run"
ECHO:
ECHO initializing the image container...
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker images -aq !image_repo_name_tag! > !docker_image_id_path!"
docker images -aq !image_repo_name_tag! > !docker_image_id_path!
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
    ECHO this container is running as a local copy of the image !image_repo_name_tag!
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
    docker pull !image_repo_name_tag!
    SET above=previous
    SET failed_before=y
    SET "options=options"
    goto error_restart_prompt
)

:docker_image_export
SET "module=docker_image_export"

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

:wsl_import_prompt
SET "module=wsl_import_prompt"
IF "!interactive!"=="n" (
    SET "continue=wsl_import"
    goto wsl_import
) ELSE (
    SET "options="
)
ECHO:
ECHO Ready to import into WSL. Would you still like to continue?
ECHO [y]es / [n]o / ([r]edo) 
SET /p "continue="

@REM if blank -> yes 
IF "!continue!"=="" ( 
    SET "continue=y"
)

@REM if y -> yes 
IF !continue!==y ( 
    SET "continue=wsl_import"
)
IF "!continue!"=="yes" ( 
    SET "continue=wsl_import"
)

@REM if n -> no
IF "!continue!"=="n" ( 
    SET "continue=no"
)
IF "!continue!"=="r" ( 
    SET "continue=redo"
)

@REM if label exists goto it
goto !continue!

@REM otherwise... use the built in error message and repeat wsl_import prompt
goto wsl_import_prompt

@REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default wsl_distro
@REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes wsl_distro default

:yes
:wsl_import
SET "module=wsl_import"


if "!wsl_distro!"=="official-ubuntu-latest" (
    ECHO:
    ECHO deleting WSL distro !wsl_distro! if it exists...
    ECHO wsl --unregister !wsl_distro!
    wsl --unregister !wsl_distro!
    ECHO DONE
)

ECHO:
ECHO importing !wsl_distro!.tar to !install_location! as !wsl_distro!...
ECHO wsl --import !wsl_distro! !install_location! !image_save_path! --version !wsl_version!
@set /A _tic=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul

wsl --import !wsl_distro! !install_location! !image_save_path! --version !wsl_version!

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
if "!default_wsl_distro!"=="y" (
    goto set_default_wsl_distro
) ELSE (
    goto wsl_or_exit
)


:set_default_wsl_distro
SET "module=set_default_wsl_distro"
IF "!default_wsl_distro!"=="y" (

    ECHO:
    ECHO setting default WSL distro as !wsl_distro!...
    ECHO  wsl --set-default !wsl_distro! 
    wsl --set-default !wsl_distro! 
    ECHO DONE
    SET "options=options"
    ECHO:
    ECHO  ..if starting WSL results in an error, try converting the distro version to WSL1 by running:
    ECHO wsl --set-version !wsl_distro! 1
    ECHO:
    @REM reset default flag
    SET "default_wsl_distro=n"
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
SET "openwsl=no"
IF "!interactive!"=="y" (
    ECHO press ENTER to open !wsl_distro! in WSL
    ECHO  ..or enter any character to skip 
    @REM make sure windows paths transfer
    SET WSLENV=USERPROFILE/p 
    SET /p "openwsl=$ "
    IF "!openwsl!"=="" (
        SET "open_wsl=y"
    )
    goto open_wsl
)
IF "!interactive!"=="n" (
    goto quit
)

:open_wsl
IF "!open_wsl!"=="y" (
    ECHO:
    ECHO launching WSL with !wsl_distro! distro...
    ECHO wsl -d !wsl_distro!
    ECHO:
    @set /A _tic=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul

    wsl -d !wsl_distro!

    @set /A _toc=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul
    @set /A _elapsed=%_toc%-%_tic
    ECHO "time elapsed: !_elapsed!"
    IF !_elapse! LEQ 1 (
        ECHO ERROR DETECTED
        IF "!options!"=="default" (
            ECHO reverting back to official ubuntu latest distro
            wsl -s official-ubuntu-latest
        )
        ECHO trying to convert distro version to WSL1 with:
        ECHO wsl --set-version !wsl_distro! 1
        wsl --set-version !wsl_distro! 1
        @set /A _tic=%time:~0,2%*3600^
                    +%time:~3,1%*10*60^
                    +%time:~4,1%*60^
                    +%time:~6,1%*10^
                    +%time:~7,1% >nul

        wsl -d !wsl_distro!

        @set /A _toc=%time:~0,2%*3600^
                    +%time:~3,1%*10*60^
                    +%time:~4,1%*60^
                    +%time:~6,1%*10^
                    +%time:~7,1% >nul
        @set /A _elapsed=%_toc%-%_tic
        IF !_elapse! LEQ 1 (
            ECHO WSL is down.
            SET "failed_before=y"
            @REM goto error_restart_prompt
        )
        SET "open_wsl=n"

    )
) ELSE (
    SET /P 
    goto prompt_options
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
if "!interactive!"=="n" (
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

IF "!exit_devels_playground!"=="" (
    SET "exit_devels_playground=x"
)
IF "!exit_devels_playground!"=="x" (
    SET "exit_devels_playground=exit"
)
IF "!exit_devels_playground!"=="exit" (
    goto quit
) ELSE (
    SET "options=!exit_devels_playground!"
    goto parse_options
)

goto prompt_options
:computer_restart_prompt
if "!interactive!"=="n" (
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
    SET "options=restart_now"
    @REM shutdown /r
    @REM goto quit
    @REM exit
)
IF "!options!"=="o" (
    SET "options=options"
)
IF "!options!"=="options" (
    COLOR 0F
    goto prompt_options
) ELSE (
    IF "!options!"=="r" (
        SET "options=restart_now"
    )
    IF "!options!"=="restart" (
        SET "options=restart_now"
    )
    IF "!options!"=="restart_now" (
        shutdown /r
        goto quit
    ) ELSE (
        COLOR 0F
        goto parse_options
    )
    
)

:prompt_options
@REM SET "module=prompt_options"
SET "prompt_type=normal"
IF "!options!"=="o" (
    SET "options=options"
)
IF "!options!"=="options" (
    if "!interactive!"=="n" (
        goto quit
    )
    ECHO:
    ECHO    Options:
    ECHO        [h]ome      go to home screen

    IF "!module!"=="wsl_or_exit" (
        ECHO        [c]onfig    configure import settings
        ECHO        [d]efault   [!default_wsl_distro!] toggle !image_repo_name_tag! image as default WSL distro 
    ) ELSE (
        IF "!module!"=="custom_config" (
            ECHO        [c]onfig    edit !image_repo_name_tag! import configuration
        ) ELSE (
            ECHO        [c]onfig    configure import settings
        )
        ECHO        [i]nstall   pull and import !image_repo_name_tag! image into WSL
        ECHO        [b]uild     build and import !image_repo_name_tag! image into WSL
        ECHO        [d]efault   [!default_wsl_distro!] toggle !image_repo_name_tag! image as default WSL distro 
    )
    
    ECHO        [r]estart   **restart computer**
    ECHO        e[x]it      exit
    ECHO:
    SET /p "options=$ "
)
:parse_options
color 0F
@REM SET "module=parse_options"

IF /I "!options!"=="i" (
    SET "options=install"
)
IF /I "!options!"=="install" (
    SET "docker_get_image=docker_image_pull"
    @REM ECHO option 'install' selected
    goto make_dirs
)
IF /I "!options!"=="b" (
    SET "options=build"
)
IF /I "!options!"=="build" (
    SET "docker_get_image=docker_image_build"
    @REM ECHO option 'build' selected
    goto make_dirs
)
IF /I "!options!"=="c" (
    goto custom_config
)
IF /I "!options!"=="config" (
    @REM ECHO option 'config' selected
    goto custom_config
)
IF /I "!options!"=="h" (
    goto show_banner_home_menu
)
IF /I "!options!"=="home" (
    @REM ECHO option 'config' selected
    goto show_banner_home_menu
)
@REM IF "!module!"=="wsl_or_exit" (
@REM     IF "!options!"=="d" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         goto set_default_wsl_distro
@REM     )
@REM     IF "!options!"=="default" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         goto set_default_wsl_distro
@REM     )
@REM ) ELSE (
    IF /I "!options!"=="d" (
        @REM ECHO option 'default' selected
        SET "options=default"
    )
    IF /I "!options!"=="default" (
        SET "default=default"
        @REM ECHO option 'default' selected
        ECHO default flag changed
        if "!default_wsl_distro!"=="y" (
            SET "default_wsl_distro=n"
            ECHO "!!image_repo_name_tag!! WILL be configured to be default WSL distro during import"
        ) ELSE (
            ECHO "!!image_repo_name_tag!! will NOT be configured to be default WSL distro during import"
            SET "default_wsl_distro=y"
        )
        
        SET "options=options"
        @REM goto docker_image_pull
        goto prompt_options
    )
@REM )
IF /I "!options!"=="o" (
    goto prompt_options
)
IF /I "!options!"=="options" (
    goto prompt_options
)
IF /I "!options!"=="r" (
    SET "options=restart"
)
IF /I "!options!"=="restart" (
    ECHO option 'restart' selected
    goto computer_restart_prompt
)
IF /I "!options!"=="x" (
    goto program_restart_prompt
)
IF /I "!options!"=="exit" (
    goto quit
)
call !options!

:quit
:no
:exit
IF "!interactive!"=="y" (
    @REM ECHO exiting from module !module!
    ECHO exiting devel's playground
    ECHO:
) ELSE (
    @REM ECHO exiting from module !module!
    @REM ECHO exiting devel's playground
    ECHO:  
)
