@echo off
@REM this file is solid but will be deprecated once wsl-import.ps1 is fixed
color 0F
SETLOCAL EnableDelayedExpansion
:redo
SET "module=main"
SET wsl_version_int=2
SET save_directory=docker2wsl
SET mount_drive=C
@REM SET image_repo=_
@REM SET image_repo_mask=official
@REM SET image_name=kali:latest
SET image_repo=kindtek
SET image_repo_mask=kindtek
SET "image_name_tag=%~1"
SET "non_interactive_distro_name=%~2"
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
    ECHO IMG_NAME_TAG !image_name_tag!
    SET "image_name="
    for /f "tokens=1 delims=:" %%a in ("%image_name_tag%") do (
        SET "image_name=%%a"
    )
    SET "image_tag=%image_name_tag::=" & SET "image_tag=%"
    SET "image_name_tag=!image_name!:!image_tag!"
    ECHO IMG_NAME !image_name!
    ECHO IMG_TAG !image_tag!
    ECHO IMG_NAME_TAG !image_name_tag!
    ECHO OLD_IMG_NAME_TAG %1
    @REM ECHO "image_tag set to arg: '%1'  ('%~1') as !image_tag!"
)
    SET "image_name_tag=!image_name!:!image_tag!"

    

IF "!non_interactive_distro_name!"=="" (
    SET "interactive=y"
    SET "wsl_distro=!image_repo_mask!-!image_name!-!image_tag!"
    IF "!image_repo!"=="kindtek" (
        SET "wsl=y"
    ) ELSE (
        SET "wsl=n"
    )

) ELSE (
    SET "interactive=n"
    SET "wsl_distro=!non_interactive_distro_name!"
    SET "wsl=y"
    
)

goto config


:set_paths
SET "module=set_paths"
SET "go2="
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
    set var=%var:~-1%
    SET "wsl_distro=!wsl_distro!-!timestamp_time:~-3!"
)
SET "docker_image_id_path=!install_location!\.image_id"
SET "docker_container_id_path=!install_location!\.container_id"
SET "image_save_path=!save_location!\!wsl_distro!.tar"
@REM directory structure: 
@REM !mount_drive!:\!install_directory!\!save_directory!
@REM ie: C:\wsl-wsl_distros\docker
SET "dvlp_path=repos/!image_repo!/dvlw/dvlp"
for /f "tokens=1 delims=-" %%a in ("%image_tag%") do (
    SET "image_distro=%%a"
)
SET "image_service=%image_tag:-=" & SET "image_service=%"

ECHO "DOCKER_IMG_DO: !docker_image_do!"
SET "docker_image_doing=!docker_image_do!"
@REM unset action before using goto
SET "docker_image_do="
goto !docker_image_doing!

:docker_image_pull
SET "module=docker_image_pull"

ECHO ========================================================================
ECHO:
SET "docker_image_do="
ECHO pulling image (!image_repo_name_tag!)...
ECHO docker pull !image_repo_name_tag!
@REM pull the image
docker pull !image_repo_name_tag!
if "!wsl!"=="n" (
    @REM goto home_banner
) ELSE (
    goto docker_image_run_from_pull
)

:docker_image_build
SET "module=docker_image_build"
ECHO ========================================================================
ECHO:
ECHO building image (!image_service!)...
ECHO docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml build !image_service!
@REM build the image
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml build !image_service!
SET "image_built=y"
if "!wsl!"=="n" (
    SET "options=options"
    goto home_banner
) ELSE (
    goto docker_image_run_from_build
)

:docker_image_push
SET "module=docker_image_push"
ECHO ========================================================================
ECHO:
ECHO pushing image (!image_service!)...
ECHO docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml push !image_service!
@REM build the image
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml push !image_service!
goto home_banner

:docker_image_run_from_pull
SET "module=docker_image_run_from_pull"
@REM ECHO "mkdir save: !save_location!"
mkdir !save_location! > nul 2> nul
@REM ECHO "mkdir install: !install_location!"
mkdir !install_location! > nul 2> nul
ECHO:
ECHO initializing the image container...
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker images -aq !image_repo_name_tag! > !docker_image_id_path!"
docker images -aq !image_repo_name_tag! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
@REM ECHO WSL_DOCKER_IMG_ID_RAW: !WSL_DOCKER_IMG_ID_RAW!
SET WSL_DOCKER_IMG_ID=!WSL_DOCKER_IMG_ID_RAW!
del !docker_container_id_path! > nul 2> nul
IF /I "!options!"=="c" (
    SET "options=config"
)
IF /I "!options!"=="config" (
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

:docker_image_run_from_build
SET "module=docker_image_run_from_build"
@REM ECHO "mkdir save: !save_location!"
mkdir !save_location! > nul 2> nul
@REM ECHO "mkdir install: !install_location!"
mkdir !install_location! > nul 2> nul
ECHO:
ECHO initializing the image container...
ECHO docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml up !image_service! --detach
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml up !image_service! --detach
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml images -q !image_service! > !docker_image_id_path!"
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml images -q !image_service! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
ECHO "docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml ps -q !image_service! > !docker_container_id_path!"
docker compose -f %HOMEDRIVE%%HOMEPATH%/!dvlp_path!/docker/!image_distro!/docker-compose.yaml ps -q !image_service! > !docker_container_id_path!
SET /P WSL_DOCKER_CTR_ID_RAW=< !docker_container_id_path!
SET WSL_DOCKER_CTR_ID=!WSL_DOCKER_CTR_ID_RAW!
SET WSL_DOCKER_IMG_ID=!WSL_DOCKER_IMG_ID_RAW!
ECHO WSL_DOCKER_IMG_ID_RAW: !WSL_DOCKER_IMG_ID_RAW!
ECHO WSL_DOCKER_CTR_ID_RAW: !WSL_DOCKER_CTR_ID_RAW!

@REM del !docker_container_id_path! > nul 2> nul
IF /I "!options!"=="c" (
    SET "options=config"
)
IF /I "!options!"=="config" (
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
    ECHO docker compose exec !image_service! bash
    docker compose exec !image_service! bash
    color 0F
    ECHO:
    ECHO closing preview container...
    ECHO:
    ECHO ========================================================================
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

@REM :wsl_import_prompt
@REM SET "module=wsl_import_prompt"
@REM IF "!interactive!"=="n" (
@REM     SET "continue=wsl_import"
@REM     goto wsl_import
@REM ) ELSE (
@REM     SET "options="
@REM )
@REM ECHO:
@REM ECHO Ready to import into WSL. Would you still like to continue?
@REM ECHO [y]es / [n]o / ([r]edo) 
@REM SET /p "continue="

@REM @REM if blank -> yes 
@REM IF /I "!continue!"=="" ( 
@REM     SET "continue=y"
@REM )
@REM IF /I "!continue!"=="y" ( 
@REM     SET "continue=yes"
@REM )
@REM IF /I "!continue!"=="yes" ( 
@REM     SET "continue=yes"
@REM )

@REM @REM if y -> yes 
@REM IF /I !continue!==y ( 
@REM     SET "continue=wsl_import"
@REM )
@REM IF /I "!continue!"=="yes" ( 
@REM     SET "continue=wsl_import"
@REM )


@REM @REM if n -> no
@REM IF /I "!continue!"=="n" ( 
@REM     SET "continue=no"
@REM )
@REM IF /I "!continue!"=="r" ( 
@REM     SET "continue=redo"
@REM )
@REM IF /I "!continue!"=="redo" ( 
@REM     SET "continue=redo"
@REM )

@REM @REM if label exists goto it
@REM goto !continue!

@REM @REM otherwise... use the built in error message and repeat wsl_import prompt
@REM goto wsl_import_prompt

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
    SET /p "openwsl=$ "
    IF "!openwsl!"=="" (
        SET "openwsl=y"
    ) 
    goto open_wsl
)
IF "!interactive!"=="n" (
    goto home_banner
)

:open_wsl
IF NOT DEFINED set_wsl_conv (
    go to set_wsl_conversion
)
IF !set_wsl_conv! EQU 2 (
    SET set_wsl_conv=1
) ELSE (
    SET set_wsl_conv=2
)
SET "wsl_in=wsl -d !wsl_distro! --exec echo y"
FOR /F "tokens=*" %%g IN (!wsl_in!) do (SET wsl_out=%%g)
IF "!wsl_out!"=="y" (
    ECHO launching WSL with !wsl_distro! distro...
    ECHO wsl -d !wsl_distro!
) ELSE (
    ECHO ERROR DETECTED
    ECHO wsl -d !wsl_distro!
    ECHO ("try to convert distro version to WSL!set_wsl_conv!? (y)/n")
    @REM IF NOT "!revert!"=="yes" (    
        SET /P "revert="
    @REM )
    IF "!revert!"=="" (
        SET "revert=yes"
    )
    IF /I "!revert!"=="y" (
        SET "revert=yes"
    )
    IF /I "!revert!"=="yes" (
        wsl --set-version !set_wsl_conv!
        goto open_wsl
    ) ELSE (
        SET "revert="
    )
)

:set_wsl_conversion
IF NOT DEFINED set_wsl_conv (
    SET set_wsl_conv=!wsl_version!
    set /a set_wsl_conv=%wsl_version_int%%1
) ELSE (
    goto home_prompt
)




:custom_config
SET "module=custom_config"
if "!interactive!"=="n" (
    goto quit
)
@REM if "!options!"=="c" (
@REM     SET "options=config"
@REM )
@REM @REM prompt user to type input or hit enter for default shown in parentheses
@REM if "!options!"=="config" (

    color 0B

    @REM @TODO: filter/safeguard user input
    ECHO:
    SET /p "image_repo=image repository: (!image_repo_mask!) $ "
    SET "old_image_name_tag=!image_name_tag!"
    SET /p "image_name_tag=image name/tag in !image_repo_mask!: (!image_name!:!image_tag!) $ "
    @REM reset image_built flag if the image_name_tag changes
    IF NOT "!old_image_name_tag!"=="!image_name_tag!" (
        SET "docker_image_built=n"
    )

    @REM SET "image_name="
    @REM SET "image_tag="
    @REM SET "image_name="
    ECHO IMG_NAME !image_name!
    ECHO IMG_TAG !image_tag!
    ECHO IMG_NAME_TAG !image_name_tag!
    ECHO OLD_IMG_NAME_TAG !old_image_name_tag!


    for /f "tokens=1 delims=:" %%a in ("%image_name_tag%") do (
        SET "image_name=%%a"

    )
    SET "image_tag=%image_name_tag::=" & SET "image_tag=%"
        ECHO image_tag !image_tag!
                ECHO image_name !image_name!

    @REM SET "image_name_tag=!image_name!:!image_tag!"
    @REM special rule for official distros on docker hub
    @REM replaces '_' with 'official' for printing
    IF "!image_repo!"=="_" (
        SET "image_repo_name_tag=!image_name!:!image_tag!"
    ) ELSE (
        SET "image_repo_mask=!image_repo!"
        SET "image_repo_name_tag=!image_repo_mask!/!image_name!:!image_tag!"
    )
    IF "!wsl!"=="y" (
        SET /p "save_directory=download folder: !mount_drive!:\(!save_directory!) $ "
    )
    SET install_directory=!image_repo_name_tag:/=-!
    SET install_directory=!install_directory::=-!
    IF "!wsl!"=="y" (
        SET /p "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) $ "
    )
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
    IF "!wsl!"=="y" (
        SET /p "wsl_distro=distro name in WSL: (!wsl_distro!) $ "
    )
    SET "wsl_distro=!wsl_distro::=-!"
    SET "wsl_distro=!wsl_distro:/=-!"
    IF "!wsl!"=="y" (
        SET /p "wsl_version=WSL version: (!wsl_version_int!) $ "
        IF "!wsl_version!"=="2" (
            SET wsl_version_int=2
        ) ELSE (
            SET wsl_version_int=1 
        )
    )

    ECHO:
    @REM goto home_banner
    @REM SET "options="
    @REM ECHO Press ENTER to import !wsl_distro! as a distro into WSL
    @REM ECHO:   or enter [o]ptions to see more options
    @REM SET /p "options=$ "
    @REM IF "!options!"=="" (
    @REM     SET "options=import"
    @REM     goto set_paths
    @REM )
    @REM IF "!options!"=="o" (
    @REM     SET "options=options"
    @REM )
    @REM IF "!options!"=="options" (
    @REM     goto home_banner
    @REM ) ELSE (
    @REM     goto options_parse
    @REM )


    color 0F
@REM ) ELSE (
@REM     IF /I "!options!"=="exit" (
@REM         goto quit
@REM     )
@REM     IF /I "!options!"=="x" (
@REM         goto program_restart_prompt
@REM     )
@REM )

:config
SET "save_location=!mount_drive!:\!save_directory!"
SET "install_root_dir=!save_location!\!wsl_distro!"
@REM wsl_distro - meaning local wsl_distro
@REM :header
SET "image_save_path=!save_location!\!wsl_distro!.tar"
SET "install_root_dir=!save_location!\!wsl_distro!"
SET "image_repo_name_tag=!image_repo!/!image_name!:!image_tag!"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF "!image_repo!"=="_" (
    @REM official repo has no repo name in address/url
    SET "image_repo_name_tag=!image_name!:!image_tag!"

) 
SET "docker_image_id_path=!install_root_dir!\.image_id"
SET "docker_container_id_path=!install_root_dir!\.container_id"


:home_banner
@REM CLS

SET "module=home_banner"
ECHO:
ECHO       _____________________________________________________________________ 
ECHO      /                          DEVEL'S PLAYGROUND                         \
ECHO      \______________  WSL import tool for Docker Hub images  ______________/
ECHO        -------------------------------------------------------------------
ECHO        ............    Image settings                         ............
ECHO        ............-------------------------------------------............
ECHO        ............    source:                                ............
ECHO        ............      !image_repo_mask!                              ............
ECHO        ............                                           ............
ECHO        ............    name/tag:                              ............
ECHO        ............      !image_name!:!image_tag!                   

IF "!wsl!"=="y" (
    ECHO        ............                                           ............
    ECHO        ............    import into WSL:                       ............
    ECHO        ............      yes                                  ............
    ECHO        ............                                           ............
    ECHO        ............    download to:                           ............
    ECHO        ............       !image_save_path! 

    ECHO        ............                                           ............
    ECHO        ............    WSL alias:                             ............
    ECHO        ............       !wsl_distro!          
    IF "!default_wsl_distro!"=="y" (
        ECHO        .............                                           ............
        ECHO        .............    default:                               ............
        ECHO        .............      yes                                  ............

    ) ELSE (
        ECHO        .............                                           ............
        ECHO        .............    default:                               ............
        ECHO        .............      no                                   ............

    )
) ELSE (
    ECHO        ............                                           ............
    ECHO        ............    import into WSL:                       ............
    ECHO        ............      no                                   ............

)

ECHO      -----------------------------------------------------------------------
ECHO:
:home_prompt
SET "module=home_prompt"
SET above=above
IF "!interactive!"=="n" (
    @REM official repo has no repo name in address/url
    SET "options=build"
    goto options_parse
)

IF defined failed_before (
    IF fail_count GTR 2 (
        @REM SET fail_count=0
        echo !fail_count!
        goto error_restart_prompt
    ) ELSE (        
        IF !fail_count!==3 (
            SET fail_count=4
        )
        IF !fail_count!==2 (
            SET fail_count=3
        )
        IF !fail_count!==1 (
            SET fail_count=2
        )
        IF !fail_count!==0 (
            SET fail_count=1
        )
    )
)

ECHO:
ECHO:
IF "!options!"=="options" (
    SET "quiet_home_prompt=y"
    SET "quiet_home_prompt=n"

) ELSE (
    SET "quiet_home_prompt=n"
    ECHO Confirm !above! settings.
    ECHO: 
    ECHO: 
    ECHO: 
)

SET "home_default_option=build"
IF "!wsl!"=="y" (
    IF "!image_repo!"=="kindtek" (
        IF "!image_built!"=="y" ( 
            IF "!quiet_home_prompt!"=="n" (
                ECHO    Press ENTER to import locally built !image_name! into WSL
                @REM SET "options=build"
            )
        ) ELSE (
            SET "home_default_option=pull"
            IF "!quiet_home_prompt!"=="n" (
                ECHO    Press ENTER to pull !image_name! and import into WSL as !wsl_distro!
            )
        )
    ) ELSE (
        IF "!quiet_home_prompt!"=="n" (
            ECHO    Press ENTER to pull !image_name! and import into WSL as !wsl_distro!
            @REM SET "options=build"
        )
    )
) ELSE (
    IF "!image_repo!"=="kindtek" (
        IF "!quiet_home_prompt!"=="n" (
            ECHO    Press ENTER to build !image_name! in Docker
            @REM SET "options=build"
        )
    ) ELSE (
        IF "!quiet_home_prompt!"=="n" (
            ECHO    Press ENTER to pull !image_name! in Docker
        )
        SET "home_default_option=pull"
    )
)
IF "!quiet_home_prompt!"=="n" (
    ECHO        ..or type [o]ptions
)
ECHO:

@REM IF "!options!"=="options" (

@REM )
ECHO "options1: !options!"
ECHO "home_default_option1: !home_default_option!"
IF "!quiet_home_prompt!"=="n" (
    ECHO "no quiet prompt"
    SET "options=!home_default_option!"
    SET "confirm="
    SET /p "confirm=$ "
    IF NOT "!confirm!"=="" (
        SET "options=!confirm!"
        ECHO "options set to !confirm! (confirm)"
        @REM SET "confirm="
    ) ELSE (
        ECHO "options set to !home_default_option! (home_default_option)"
        SET "options=!home_default_option!"
    )
)
ECHO "options2: !options!"
ECHO "home_default_option2: !home_default_option!"

@REM ELSE (
@REM     IF NOT "!home_default_option!"=="" (
@REM     @REM     SET "options=!confirm!"
@REM     @REM ) ELSE (
@REM         SET "options=!home_default_option!"
@REM         SET "home_default_option="
@REM         @REM SET "home_default_option=!options!"
@REM     )
@REM )



@REM goto options_parse

@REM ) ELSE (
@REM     goto options_parse
    @REM goto options_prompt
    @REM IF /I "!options!"=="o" (
    @REM     SET "options=options"
    @REM )
    @REM IF /I "!options!"=="options" (
    @REM ) 
@REM )

:options_prompt
@REM SET "module=options_prompt"
SET "exit_module=options_prompt"
SET "prompt_type=normal"
IF /I "!options!"=="o" (
    SET "options=options"
)
IF /I "!options!"=="options" (
    if "!interactive!"=="n" (
        goto quit
    )
    ECHO   Options:
    ECHO:
    ECHO        [h]ome      go to home screen

    IF "!module!"=="wsl_or_exit" (
        ECHO        [c]onfig    configure import settings
        ECHO        [d]efault   !default_wsl_distro! toggle !image_repo_name_tag! image as default WSL distro 
    ) ELSE (
        IF "!module!"=="custom_config" (
            ECHO        [c]onfig    edit !image_repo_name_tag! import configuration
        ) ELSE (
            ECHO        [c]onfig    configure import settings
        )

        if "!wsl!"=="y" (
            ECHO        [l]aunch    launch !wsl_distro! if it exists in WSL
            ECHO        [p]ull      pull and import !image_name_tag! image into WSL
            ECHO        [b]uild     build and import !image_name_tag! image into WSL
            ECHO        [P]ush      push !image_repo_name_tag! image to Docker Hub - requires build
            IF "!image_built!"=="y" (
                ECHO        [i]nstall[P]   [i]nstall[b] ^^+ push to !to image_repo!
            )
            ECHO [ON]   [w]sl       toggle - import !image_repo_name_tag! into WSL 
            if "!default_wsl_distro!"=="y" (
                ECHO [ON]    [d]wsl      toggle - designate !image_repo_name_tag! as default WSL distro 
            ) ELSE (
                ECHO [OFF]  [d]wsl      toggle - designate !image_repo_name_tag! as default WSL distro  
            )
        ) ELSE (
            ECHO        [p]ull      pull !image_repo_name_tag! image into Docker 
            ECHO        [b]uild     build !image_repo_name_tag! image with Docker
            ECHO        [P]ush      push !image_repo_name_tag! image to Docker Hub - requires build
            ECHO [OFF]  [w]sl       toggle - import !image_repo_name_tag! into WSL 
        )

    )
    
    ECHO [ ^^! ]  [r]estart   restart computer
    ECHO        e[x]it      exit
    ECHO:
    IF /I "!options!"=="o" (
        SET "options=options"
    )
    IF /I "!options!"=="options" (
        ECHO "894 options: !options!"
        SET /p "options=$ "
        IF "!options!"=="options" (
            ECHO "set /p options: !options!"
            IF NOT "!home_default_option!"=="" (
                ECHO "options=home_default_option: !options!"
                SET "options=!home_default_option!"
                SET "home_default_option="
            )
        ) ELSE (
            echo "SET /P OPTIONS: !options!"
        )
    ) 

    ECHO "MAIN OPTS: !home_default_option!"
    ECHO "OPTIONS: !options!"
)
:options_parse
@REM SET "exit_module=options_parse"

color 0F
@REM SET "module=options_parse"

@REM gotoo and options are live
@REM opti0ns - just temp copy of val
SET "opti0ns=!options!"
@REM go2 - just temp copy of val
@REM SET "go2="

@REM IF /I "!opti0ns!"=="ib" (
@REM     SET "opti0ns=installb"
@REM )
@REM IF /I "!opti0ns!"=="installb" (
@REM     SET "docker_image_do=docker_image_build"
@REM     @REM ECHO option 'install' selected
@REM     SET "go2=set_paths"
@REM     goto switchboard
@REM )
@REM IF /I "!opti0ns!"=="ip" (
@REM     SET "opti0ns=installp"
@REM )
@REM IF /I "!opti0ns!"=="installp" (
@REM     SET "docker_image_do=docker_image_pull"
@REM     @REM ECHO option 'install' selected
@REM     SET "go2=set_paths"
@REM     goto switchboard
@REM )
ECHO "OPTIONS PARSE: !options!"
ECHO "OPTI0NS PARSE: !opti0ns!"
ECHO "go2 PARSE: !go2!"


@REM P -> push
IF "!opti0ns!"=="P" (
    SET "opti0ns=push"
)
IF /I "!opti0ns!"=="push" (
    SET "docker_image_do=docker_image_push"
    @REM ECHO option 'install' selected
    SET "go2=set_paths"
    goto switchboard
)
IF /I "!opti0ns!"=="b" (
    SET "opti0ns=build"
)
IF /I "!opti0ns!"=="build" (
    SET "docker_image_do=docker_image_build"
    @REM ECHO option 'build' selected
    SET "go2=set_paths"
    goto switchboard
)
@REM p -> pull
IF "!opti0ns!"=="p" (
    SET "opti0ns=pull"
)
IF /I "!opti0ns!"=="pull" (
    SET "docker_image_do=docker_image_pull"
    ECHO option 'pull' selected
    SET "go2=set_paths"
    goto switchboard
)
@REM P -> push
IF /I "!image_built!"=="y" (
    IF "!opti0ns!"=="P" (
        SET "opti0ns=push"
    )
    IF /I "!opti0ns!"=="push" (
        SET "docker_image_do=docker_image_push"
        @REM ECHO option 'build' selected
        SET "go2=set_paths"
    )
    goto switchboard
)
IF /I "!opti0ns!"=="c" (
    SET "opti0ns=config"
)
IF /I "!opti0ns!"=="config" (
    @REM ECHO option 'config' selected
    SET "go2=custom_config"
    goto switchboard
)
IF /I "!opti0ns!"=="h" (
    SET "opti0ns=home"
)
IF /I "!opti0ns!"=="home" (
    @REM ECHO option 'config' selected
    SET "go2=home_banner"
    goto switchboard
)
@REM IF "!module!"=="wsl_or_exit" (
@REM     IF "!opti0ns!"=="d" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         goto set_default_wsl_distro
@REM     )
@REM     IF "!opti0ns!"=="default" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         SET "go2= set_default_wsl_distro"
@REM     )
@REM ) ELSE (
    IF /I "!opti0ns!"=="dw" (
        @REM ECHO option 'default' selected
        SET "opti0ns=dwsl"
    )
    IF /I "!opti0ns!"=="d" (
        @REM ECHO option 'default' selected
        SET "opti0ns=dwsl"
    )
    IF /I "!opti0ns!"=="dwsl" (
        SET "default=default"
        @REM ECHO option 'default' selected
        ECHO default flag changed
        if "!default_wsl_distro!"=="y" (
            SET "default_wsl_distro=n"
            ECHO "make default distro: ON"
        ) ELSE (
            ECHO "make default distro: OFF"
            SET "default_wsl_distro=y"
        )
        
        SET "options=options"
        @REM SET "go2= docker_image_pull"
        SET "go2= home_banner"
        goto switchboard
    )
@REM )
IF /I "!opti0ns!"=="l" (
    SET "opti0ns=launch"
)
IF /I "!opti0ns!"=="launch" (
    SET "go2=wsl_open"
    goto switchboard
)
IF /I "!opti0ns!"=="o" (
    SET "opti0ns=options"
)
IF /I "!opti0ns!"=="options" (
    ECHO EXIT_MODULE !exit_module!

    IF "!exit_module!"=="error_restart_prompt" (
            ECHO MODULE !module!
        goto options_prompt
    ) ELSE (
        IF "!exit_module!"=="options_prompt" (
            goto options_prompt
        ) ELSE (
            goto home_banner
        )

    )
    @REM SET "go2=home_banner"
    
)
IF /I "!opti0ns!"=="r" (
    ECHO "RESTART COMPUTER 1"
    SET "opti0ns=restart"
)
IF /I "!opti0ns!"=="restart" (
    ECHO "RESTART COMPUTER 2"

    ECHO option 'restart' selected
    SET "go2=computer_restart_prompt"
    goto switchboard
)
IF /I "!opti0ns!"=="w" (
    SET "opti0ns=wsl"
)
IF /I "!opti0ns!"=="wsl" (
    @REM ECHO option 'default' selected
    ECHO default flag changed
    if "!wsl!"=="y" (
        SET "wsl=n"
        ECHO "toggle wsl import [ON]"
    ) ELSE (
        ECHO "toggle wsl import [OFF]"
        SET "wsl=y"
    )
    SET "opti0ns=options"
    @REM SET "go2=docker_image_pull"
    SET "go2=home_banner"
    goto switchboard
)
IF /I "!opti0ns!"=="x" (
    SET "go2=program_restart_prompt"
    goto switchboard
)
IF /I "!opti0ns!"=="exit" (
    SET "go2=quit"
    goto switchboard
)

:switchboard
@REM SET "exit_module=switchboard"
=error_restart_prompt"
ECHO "options: !options!"
ECHO "opti0ns: !opti0ns!"
IF NOT "!opti0ns!"=="" (
    SET "options=!opti0ns!"
)

ECHO "go2: !go2!"
IF NOT "!go2!"=="" (
    @REM goto !goto!
    goto !go2!
) ELSE (
    goto home_banner
)

goto home_banner
:computer_restart_prompt
SET "exit_module=computer_restart_prompt"
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
IF /I "!options!"=="o" (
    SET "options=options"
)
IF /I "!options!"=="options" (
    COLOR 0F
    goto home_banner
) ELSE (
    IF /I "!options!"=="r" (
        SET "options=restart_now"
    )
    IF /I "!options!"=="restart" (
        SET "options=restart_now"
    )
    IF /I "!options!"=="restart_now" (
        shutdown /r
        goto quit
    ) ELSE (
        COLOR 0F
        goto options_parse
    )
    
)

@REM :cmd
@REM if "!opti0ns!"=="cmd" (
@REM     set /p "cmd_call="
@REM     call !cmd_call!
@REM )
:no
goto home_banner

:error_restart_prompt:
SET "exit_module=error_restart_prompt"
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
SET "go2="
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

ECHO Press ENTER to exit program
ECHO        ..or enter [o]ptions to see more options
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:



SET "exit_devels_playground="
SET /p "exit_devels_playground="
COLOR 0F

IF "!exit_devels_playground!"=="" (
    SET "exit_devels_playground=exit"
)
IF "!exit_devels_playground!"=="x" (
    SET "exit_devels_playground=exit"
)
IF "!exit_devels_playground!"=="exit" (
    goto quit
) ELSE (
    SET "options=!exit_devels_playground!"
    ECHO "options: !exit_devels_playground! (exit_devels_playground)"
    goto options_parse
)
:quit
:exit
IF "!interactive!"=="y" (
    ECHO exiting from modules !exit_module! !module!
    ECHO exiting devel's playground
    ECHO:
) ELSE (
    @REM ECHO exiting from module !module!
    @REM ECHO exiting devel's playground
    ECHO:  
)
