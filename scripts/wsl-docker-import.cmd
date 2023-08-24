@echo off
@REM this file is solid but will be deprecated once wsl-import.ps1 is fixed
color 0F
SETLOCAL EnableDelayedExpansion

doskey /exename docker.exe docker=C:\Program Files\Docker\Docker\Docker Desktop.exe > nul 2> nul
doskey /exename wsl.exe wsl=C:\Windows\System32\wsl.exe > nul 2> nul
SET "DVLP_DEBUG=n"
:redo
IF "!DVLP_DEBUG!" == "y" (
    ECHO "custom image set with !image_name_tag!"
    @ECHO ON

)
SET "module=main"
SET wsl_version_int=2
SET "wsl_version=!wsl_version_int!"
SET save_directory=users\%USERNAME%\kache\docker2wsl
SET mount_drive=C
@REM SET image_repo=_
@REM SET image_repo_mask=official
@REM SET image_name=kali:latest
SET failsafe_wsl_distro=kalilinux-kali-rolling-latest
SET image_repo=kindtek
SET image_repo_mask=kindtek
SET "image_name_tag=%~1"
SET "non_interactive_distro_name=%2"
SET "options=%3"
SET "display_options=n"
IF "!options!" == "default" (
    SET "default_wsl_distro=y"
) ELSE (
    SET "default_wsl_distro=n"
)
@REM ECHO IMG_NAME_TAG !image_name_tag!

SET "image_repo=kindtek"
SET "image_repo_mask=kindtek"
SET "image_tag=kali-git-kernel"
SET "image_name=devels-playground"
IF "%~1" == "default" (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "default image set"
    )
    SET "image_repo=kalilinux"
    SET "image_repo_mask=kalilinux"
    SET "image_tag=latest"
    SET "image_name=kali-rolling"
    SET "wsl_distro=!failsafe_wsl_distro!"
    SET "non_interactive_distro_name=!wsl_distro!"
    SET "image_name_tag=!image_name!:!image_tag!"
    SET "image_repo_name_tag=!image_repo!/!image_name!:!image_tag!"
    SET "default_wsl_distro=y"

) ELSE (
    IF NOT "%~1" == "" (
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "non_interactive_distro_name set to !non_interactive_distro_name!"
        )
        @REM SET "image_tag="
        @REM SET "image_name="
        ECHO !image_name_tag!|find "/" >NUL
        IF errorlevel 1 (
            ECHO !image_name_tag!|find ":" >NUL
            SET "image_repo="
            SET "image_repo_mask="
            IF errorlevel 0 (
                FOR /F "tokens=1* delims=:" %%a IN (
                "!image_name_tag!" 
                ) DO (
                    IF "!DVLP_DEBUG!" == "y" (
                        ECHO "parsed image name: %%a"
                    )
                    SET "image_name=%%a"
                )
                FOR /F "tokens=2 delims=:" %%a IN (
                "!image_name_tag!" 
                ) DO (
                    IF "!DVLP_DEBUG!" == "y" (
                        ECHO "parsed tag: %%a"
                    )
                    SET "image_tag=%%a"
                )
            )
        ) ELSE (
            FOR /F "tokens=1* delims=/" %%a IN (
            "%image_name_tag%" 
            ) DO (
                IF "!DVLP_DEBUG!" == "y" (
                    ECHO "parsed image repo: %%a"
                )
                SET "image_repo=%%a"
                SET "image_repo_mask=%%a"
            )
        )    
            
        SET "name_tag="
        ECHO !image_name_tag!|find "/" >NUL
        IF errorlevel 1 (
            ECHO !image_name_tag!|find ":" >NUL
            IF errorlevel 1 (
                 SET "image_tag="
            ) ELSE (
                FOR /F "tokens=2 delims=:" %%a IN (
                "!image_name_tag!" 
                ) DO (
                    IF "!DVLP_DEBUG!" == "y" (
                        ECHO "parsed tag: %%a"
                    )
                    SET "image_tag=%%a"
                )
            )
        ) ELSE (
            FOR /F "tokens=2 delims=/" %%a IN (
            "!image_name_tag!" 
            ) DO (
                IF "!DVLP_DEBUG!" == "y" (
                    ECHO "parsed image/tag: %%a"
                )
                SET "name_tag=%%a"
            )
        )
        ECHO !image_name_tag!|find ":" >NUL
        IF errorlevel 1 (
                SET "image_name=!image_name_tag!"
                SET "image_tag="
        ) ELSE (
            FOR /F "tokens=2 delims=:" %%a IN (
            "!name_tag!" 
            ) DO (
                IF "!DVLP_DEBUG!" == "y" (
                    ECHO "parsed tag: %%a"
                )
                SET "image_tag=%%a"
            )
            @REM SET "image_name="
            FOR /F "tokens=1* delims=:" %%a IN (
                "!name_tag!" 
            ) DO (
                IF "!DVLP_DEBUG!" == "y" (
                    ECHO "parsed image name: %%a"
                )
                SET "image_name=%%a"
            )
        )
    )
    IF "!DVLP_DEBUG!" == "y" (
        ECHO ARGS: %*
        ECHO "image_name_tag currently is !image_name_tag!"
        ECHO IMG_NAME !image_name!
        ECHO IMG_TAG !image_tag!
        ECHO IMG_NAME_TAG !image_name_tag!
        ECHO IMG_REPO_NAME_TAG !image_repo_name_tag!
        ECHO WSL_DISTRO_NAME %~2
        ECHO DOCKER_HUB %~1
        @REM ECHO "image_tag set to arg: '%1'  ('%~1') as !image_tag!"
    )
    @REM set image attribute strings using parsed args
    IF "!image_repo!" == "" (
        IF "!image_tag!" == "" (
            SET "image_repo_name_tag=!image_name!"
            SET "image_name_tag=!image_name!"
            SET "wsl_distro=!image_name!"
        )  ELSE (
            SET "image_repo_name_tag=!image_name!:!image_tag!"
            SET "image_name_tag=!image_name!:!image_tag!"
            SET "wsl_distro=!image_name!-!image_tag!"
        )
    ) ELSE (
        IF "!image_tag!" == "" (
            SET "image_repo_name_tag=!image_repo_mask!\!image_name!"
            SET "image_name_tag=!image_name!"
            SET "wsl_distro=!image_repo_mask!-!image_name!"
        ) ELSE (
            SET "image_repo_name_tag=!image_repo_mask!\!image_name!:!image_tag!"
            SET "image_name_tag=!image_name!:!image_tag!"
            SET "wsl_distro=!image_name!-!image_tag!"
        )
    )

    IF "!image_name_tag!" == "" (
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "default kindtek image set"
        )

        @REM SET "non_interactive_distro_name="
        SET "default_wsl_distro=n"
    ) ELSE ( 
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "custom image set as !image_name_tag! using args '%~1%'"
        )
        @REM SET "image_tag=%~1"
        @REM ECHO IMG_NAME_TAG !image_name_tag!
    )


)

IF "!DVLP_DEBUG!" == "y" (
    ECHO ARGS: %*
    ECHO "image_name_tag set to !image_name_tag!"
    ECHO IMG_NAME !image_name!
    ECHO IMG_TAG !image_tag!
    ECHO IMG_REPO !image_repo!
    ECHO IMG_NAME_TAG !image_name_tag!
    ECHO IMG_REPO_NAME_TAG !image_repo_name_tag!
    ECHO WSL_DISTRO_NAME %~2 / !non_interactive_distro_name!
    ECHO DOCKER_HUB %~1
    @REM ECHO "image_tag set to arg: '%1'  ('%~1') as !image_tag!"
)

IF "!non_interactive_distro_name!" == "" (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "interactive session"
    )
    SET "interactive=y"
    IF "!image_repo!" == "kindtek" (
        SET "wsl=y"
    ) ELSE (
        SET "wsl=n"
    )
) ELSE (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "NON-interactive session"
        ECHO "!non_interactive_distro_name!"
    )
    SET "interactive=n"
    @REM SET "wsl_distro=!non_interactive_distro_name!"
    SET "wsl=y"
    
)

IF "!DVLP_DEBUG!" == "y" (
    ECHO WSL_IMPORT !wsl!
    @ECHO off
) 
GOTO config


:set_paths
SET "module=set_paths"
SET "go2=home_banner"
@REM ECHO "entering module !module!"
FOR /F %%x IN (
    'wmic PATH win32_utctime get /Format:list ^| findstr "="'
) DO SET %%x
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
set "timestamp_date=%Year%%Month%%Day:~0,8%"
SET "timestamp_time=%Hour%%Minute%%Second%%TIME:*.=%"
SET "install_location=!save_location!\!wsl_distro!"
SET "image_save_path=!save_location!\!wsl_distro!.tar"
IF "!DVLP_DEBUG!" == "y" (
    ECHO wsl_distro: !wsl_distro!
    ECHO failsafe_wsl_distro: !failsafe_wsl_distro!
)
IF "!wsl_distro!" == "!failsafe_wsl_distro!" (
    SET "install_location=!save_location!"

    IF "!DVLP_DEBUG!" == "y" (
        ECHO !wsl_distro! is failsafe distro
        ECHO image_save_path: !image_save_path!
        ECHO image_install_location: !install_location!
    )
) ELSE (

    SET test_string=helloworld
    SET "test_string_path=%USERPROFILE%\.kali_test"
    @REM need better check for duplicate distro - use randomization for now
    wsl.exe -d !wsl_distro! echo !test_string! > !test_string_path!
    SET /P wsl_out=<!test_string_path!
    IF "!DVLP_DEBUG!" == "y" (
        ECHO !wsl_distro! is not failsafe distro
        ECHO image_save_path: !image_save_path!
        ECHO image_install_location: !install_location!
        ECHO wsl test string: !wsl_out! ^(!test_string_path!^)
    )
    DEL !test_string_path!

    @REM IF "!wsl_out!" == "!test_string!" (
    @REM     @REM we have a duplicate
    SET "wsl_distro_base=!wsl_distro!"
    SET "wsl_distro=!wsl_distro!-!timestamp_date!!timestamp_time!"
    SET "save_location=!mount_drive!:\!save_directory!\!wsl_distro_base!"
    SET "install_root_dir=!save_location!\!timestamp_date!!timestamp_time!"
    SET "image_save_path=!save_location!\!timestamp_date!!timestamp_time!\backups\!wsl_distro!.tar"
    SET "install_location=!install_root_dir!"
    mkdir !save_location!\!timestamp_date!!timestamp_time!\backups > nul 2> nul
    mkdir !install_location! > nul 2> nul
    IF "!DVLP_DEBUG!" == "y" (
        ECHO duplicate distro found for !wsl_distro!
        ECHO "install location: !install_location!"
    )
    @REM ) 
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "install location: !install_location!"
    )
)
@REM SET "save_location=!save_location!"
SET "docker_image_id_path=!install_location!\.image_id"
SET "docker_container_id_path=!install_location!\.container_id"
@REM SET "image_save_path=!save_location!\!wsl_distro!.tar"
SET "diskman_file_path=!install_location!\diskman.ps1"
SET "diskshrink_file_path=!install_location!\diskshrink.ps1"
@REM SET "image_save_path=!save_location!\!wsl_distro!.tar"
SET "wsl_default_distro_path=!mount_drive!:\!save_directory!\.default_distro"
SET "wsl_default_kernel_path=!mount_drive!:\!save_directory!\.default_kernel"
SET "wsl_default_kernel_version_path=!mount_drive!:\!save_directory!\.default_kernel_version"
SET "wsl_default_kernel_config_version_path=!mount_drive!:\!save_directory!\.default_kernel_config_version"

@REM directory structure: 
@REM !mount_drive!:\!install_directory!\!save_directory!
@REM ie: C:\wsl-wsl_distros\docker

SET "dvlp_path=repos\!image_repo!\dvlw\dvlp"
FOR /F "tokens=1* delims=-" %%a IN (
    "%image_tag%" 
) DO (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "parsed image distro: %%a"
    )
    SET "image_distro=%%a"
)
FOR /F "tokens=1* delims=-" %%G IN (
    "%image_tag%" 
) DO (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "parsed image service: %%H"
    )
    SET "image_service=%%H"
)
SET "image_service_base="
FOR /F "tokens=1* delims=-" %%G IN (
    "%image_service%" 
) DO (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "parsed image service base: %%G"
    )
    SET "image_service_base=%%G"
)
FOR /f "tokens=1,2,3* delims=-" %%a in ("%image_service%") do (

    IF NOT "%%b"=="" (
        IF NOT "%%b"=="%image_service%" (
            SET image_service_suffix=%%b
        )
    )
    IF NOT "%%c"=="" (
        IF NOT "%%c"=="%image_service%" (
            SET image_service_suffix=%%c
        )
    )
)
IF "!DVLP_DEBUG!" == "y" (
    ECHO "parsed image service suffix: !image_service_suffix!"
)
@REM do not try to build sources that are not kindtek
IF NOT "!image_repo!" == "kindtek" (
    ECHO "not kindtek go to docker image pull"
    SET "docker_image_do=docker_image_pull"
) 
@REM ECHO "DOCKER_IMG_DO: !docker_image_do!"
SET "docker_image_doing=!docker_image_do!"
SET "docker_image_do="
GOTO !docker_image_doing!

:docker_image_pull
SET "module=docker_image_pull"
ECHO ========================================================================
ECHO:
SET "docker_image_do="
ECHO pulling image (!image_repo_name_tag!)...
ECHO docker pull !image_repo_name_tag!
@REM pull the image
docker pull !image_repo_name_tag!
IF "!wsl!" == "n" (
    SET "options=options"
    GOTO home_banner
) ELSE (
    GOTO docker_image_run_from_pull
)

:docker_image_build
SET "module=docker_image_build"
ECHO ========================================================================
ECHO:
SET "docker_image_do="
IF "!image_service_suffix!" == "kernel" (
    FOR /f "tokens=1,2,3,4* delims=-" %%a in ("!image_tag!") do (
        IF "%%c"=="kernel" (
            @REM ECHO ccc is kernel %%d
            SET "image_tag_base=%%a-%%b"
        ) ELSE (
            IF "%%d"=="kernel" (
                @REM ECHO ddd is kernel %%d
                SET "image_tag_base=%%a-%%b-%%c"
            ) ELSE (
                IF NOT "%%d"=="" (
                    @REM ECHO ddd not empty  %%d
                    SET "image_tag_base=%%a-%%b-%%c-%%d"
                ) ELSE (
                    IF NOT "%%c"=="" (
                        @REM ECHO ccc not empty  %%c
                        SET "image_tag_base=%%a-%%b-%%c"
                    ) ELSE (
                        IF NOT "%%b"=="" (
                            @REM ECHO bbb not empty  %%b
                            SET "image_tag_base=%%a-%%b"
                        ) ELSE (
                            IF NOT "%%a"=="" (
                                @REM ECHO aaa not empty  %%a
                                SET "image_tag_base=%%a"
                            ) ELSE (
                                @REM ECHO aaa is empty  %%a

                                SET "image_tag_base="
                            )
                        )
                    )
                )
            )
        )
    )
    ECHO pulling cached image ^(!image_repo!^/!image_name!^:!image_tag_base!^)...
    @REM pull the image to possibly save time building
    ECHO docker pull !image_repo!^/!image_name!^:!image_tag_base!
) ELSE (
    ECHO pulling cached image ^(!image_repo_name_tag!^)...
    ECHO docker pull !image_repo_name_tag!
    @REM pull the image to possibly save time building
    docker pull !image_repo_name_tag!
)


@REM re-building repo
SET "build_args="
SET "compose_services_nocache=repo"
SET "compose_services=!image_tag_base!"
ECHO building image (!image_tag_base!)...
@REM build the image
IF "!image_service_suffix!" == "kernel" (
    @REM TODO: add prompt (when noninteractive) for kernel type/feature
    SET "build_args=--build-arg WIN_USER=%USERNAME%"
    SET "build_args=!build_args! --build-arg KERNEL_TYPE=basic --build-arg KERNEL_FEATURE=zfs"
    @REM SET "compose_services_nocache=!compose_services_nocache! repo-kernel"
    SET "compose_services=!image_service!"
)
@REM IF NOT "!image_service_base!" == "test" (
@REM     ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build --no-cache !compose_services_nocache!
@REM     docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build --no-cache !compose_services_nocache!
@REM )
@REM force no cache when testing different kernel types
@REM IF "!image_service_suffix!" == "kernel" (
@REM     @REM force rebuild of kernel
@REM     @REM ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build !build_args! kernel-make
@REM     @REM docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build !build_args! kernel-make
@REM )
ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build !build_args! !compose_services!
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml build !build_args! !compose_services!

SET "image_built=y"
IF "!wsl!" == "n" (
    SET "options=options"
    GOTO home_banner
) ELSE (
    GOTO docker_image_run_from_build
)

:docker_image_push
SET "module=docker_image_push"
ECHO ========================================================================
ECHO:
SET "docker_image_do="
ECHO pushing image (!image_service_base!)...
ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml push !image_service_base!
@REM build the image
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml push !image_service_base!
SET "options=options"
GOTO home_banner

:docker_image_run_from_pull
SET "module=docker_image_run_from_pull"
@REM ECHO "mkdir save: !save_location!"
mkdir !save_location! > nul 2> nul
@REM ECHO "mkdir install: !install_location!"
mkdir !install_location! > nul 2> nul
ECHO:
SET "docker_image_do="
ECHO initializing the image container...
@REM save id to file and then set wsl_docker_img_id with file contents
ECHO "docker images -aq !image_repo_name_tag! > !docker_image_id_path!"
docker images -aq !image_repo_name_tag! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
@REM ECHO WSL_DOCKER_IMG_ID_RAW: !WSL_DOCKER_IMG_ID_RAW!
SET WSL_DOCKER_IMG_ID=!WSL_DOCKER_IMG_ID_RAW!
del !docker_container_id_path! > nul 2> nul
IF /I "!options!" == "c" (
    SET "options=config"
)
IF /I "!options!" == "config" (
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
IF "!WSL_DOCKER_CONTAINER_ID!" == "" (
    ECHO An error occurred. Missing container ID. Please try again
    docker pull !image_repo_name_tag!
    SET above=previous
    SET failed_before=y
    SET "options=options"
    GOTO error_restart_prompt
)
IF "!wsl!" == "n" (
    IF "!interactive!" == "n" (
        GOTO exit
    )
    ELSE (
        GOTO home_banner
    )
) ELSE (
    GOTO docker_image_export
)

:docker_image_run_from_build
SET "module=docker_image_run_from_build"
@REM ECHO "mkdir save: !save_location!"
mkdir !save_location! > nul 2> nul
@REM ECHO "mkdir install: !install_location!"
mkdir !install_location! > nul 2> nul
ECHO:
SET "docker_image_do="
ECHO initializing the image container...
ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml up --build !image_service_base! --detach
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml up --build !image_service_base! --detach
@REM ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml -- !image_service_base! sudo rm -vrf /var/cache/dvlp/archives && sudo apt update -y && sudo apt upgrade -y
SET "test_string=helloworld"
SET "wsl_distro_test_pass=n"
SET "test_string_path=%USERPROFILE%\.distro_test"
ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo echo !test_string!
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo echo !test_string! > !test_string_path!
SET /P wsl_out=<!test_string_path!
IF "!image_repo!" == "kindtek" (
    IF "!wsl_out!" == "!test_string!" (
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo rm -vrf /var/cache/dvlp/archives
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo rm -vrf /var/cache/dvlp/archives
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo apt update -y
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo apt update -y
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo apt upgrade -y
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! sudo apt upgrade -y
    ) ELSE (
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! rm -vrf /var/cache/dvlp/archives
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! rm -vrf /var/cache/dvlp/archives
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! apt update -y
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! apt update -y
        ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! apt upgrade -y
        docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! apt upgrade -y
    )
)
@REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
ECHO "docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml images -q !image_service_base! > !docker_image_id_path!"
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml images -q !image_service_base! > !docker_image_id_path!
SET /P WSL_DOCKER_IMG_ID_RAW=< !docker_image_id_path!
ECHO "docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml ps -q !image_service_base! > !docker_container_id_path!"
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml ps -q !image_service_base! > !docker_container_id_path!
SET /P WSL_DOCKER_CTR_ID_RAW=< !docker_container_id_path!
SET WSL_DOCKER_CTR_ID=!WSL_DOCKER_CTR_ID_RAW!
SET WSL_DOCKER_IMG_ID=!WSL_DOCKER_IMG_ID_RAW!
ECHO WSL_DOCKER_IMG_ID_RAW: !WSL_DOCKER_IMG_ID_RAW!
ECHO WSL_DOCKER_CTR_ID_RAW: !WSL_DOCKER_CTR_ID_RAW!
ECHO docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! uname -r ^> !wsl_default_kernel_path!
docker compose -f %USERPROFILE%\!dvlp_path!\docker\!image_distro!\docker-compose.yaml exec !image_service_base! uname -r > !wsl_default_kernel_path!


@REM del !docker_container_id_path! > nul 2> nul
IF /I "!options!" == "c" (
    SET "options=config"
)
IF /I "!options!" == "config" (
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
    ECHO docker compose exec !image_service_base! bash
    docker compose exec !image_service_base! bash
    color 0F
    ECHO:
    ECHO closing preview container...
    ECHO:
    ECHO ========================================================================
)

SET /P WSL_DOCKER_CONTAINER_ID=<!docker_container_id_path! > nul
IF "!WSL_DOCKER_CONTAINER_ID!" == "" (
    ECHO An error occurred. Missing container ID. Please try again
    docker pull !image_repo_name_tag!
    SET above=previous
    SET failed_before=y
    SET "options=options"
    GOTO error_restart_prompt
)
IF NOT "!wsl!" == "y" (
    GOTO home_banner
)

:docker_image_export
SET "module=docker_image_export"
ECHO:
@REM create diskman.ps1 file
ECHO select vdisk file^=!install_location!\ext4.vhdx > !diskman_file_path!
ECHO attach vdisk readonly >> !diskman_file_path!
ECHO compact vdisk >> !diskman_file_path!
ECHO detach vdisk >> !diskman_file_path!
@REM create diskshrink.ps1 file
ECHO try { > !diskshrink_file_path!
ECHO    # Self-elevate the privileges >> !diskshrink_file_path!
ECHO    if (-Not ^([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent^(^)^).IsInRole^([Security.Principal.WindowsBuiltInRole] ^'Administrator^')^) { >> !diskshrink_file_path!
ECHO        if ^([int]^(Get-CimInstance -Class Win32_OperatingSystem ^| Select-Object -ExpandProperty BuildNumber^) -ge 6000^) { >> !diskshrink_file_path!
ECHO            $CommandLine ^= -File $MyInvocation.MyCommand.Path + ^" ^" + $MyInvocation.UnboundArguments >> !diskshrink_file_path!
ECHO            Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle ^'Maximized^' -ArgumentList $CommandLine >> !diskshrink_file_path!
ECHO            Exit >> !diskshrink_file_path!
ECHO        } >> !diskshrink_file_path!
ECHO    } >> !diskshrink_file_path!
ECHO }  catch {} >> !diskshrink_file_path!
ECHO docker system df >> !diskshrink_file_path!
ECHO docker builder prune -af --volumes >> !diskshrink_file_path!
ECHO docker system prune -af --volumes >> !diskshrink_file_path!
ECHO stop-service -name docker* -force;  >> !diskshrink_file_path!
ECHO # wsl.exe -- sudo shutdown -h now^; >> !diskshrink_file_path!
ECHO # wsl.exe -- sudo shutdown -r 0^; >> !diskshrink_file_path!
ECHO wsl.exe --shutdown^; >> !diskshrink_file_path!
ECHO stop-service -name wsl* -force -ErrorAction SilentlyContinue^; >> !diskshrink_file_path!
ECHO stop-process -name docker* -force -ErrorAction SilentlyContinue^; >> !diskshrink_file_path!
ECHO stop-process -name wsl* -force -ErrorAction SilentlyContinue^; >> !diskshrink_file_path!
ECHO Invoke-Command -ScriptBlock { diskpart /s !install_location!\diskman\.ps1 } -ArgumentList ^'-Wait -Verbose^'^; >> !diskshrink_file_path!
ECHO start-service wsl*^; >> !diskshrink_file_path!
ECHO start-service docker*^; >> !diskshrink_file_path!
ECHO write-host 'done.'^; >> !diskshrink_file_path!
ECHO read-host >> !diskshrink_file_path!
ECHO exporting image (!WSL_DOCKER_IMG_ID!) as container (!WSL_DOCKER_CONTAINER_ID!)...
ECHO docker export !WSL_DOCKER_CONTAINER_ID! ^> !image_save_path!
@SET /A _tic=%time:~0,2%*3600^
                +%time:~3,1%*10*60^
                +%time:~4,1%*60^
                +%time:~6,1%*10^
                +%time:~7,1% >nul

docker export !WSL_DOCKER_CONTAINER_ID! > !image_save_path!

@SET /A _toc=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul
@SET /A _elapsed=%_toc%-%_tic
@REM IF !_elapse! LEQ 1 (
@REM     ECHO Docker export failure
@REM     GOTO error_restart_prompt
@REM     )

:yes
:wsl_import
SET "module=wsl_import"
SET "handle=set_default_wsl_distro"

IF "!wsl_distro!" == "!failsafe_wsl_distro!" (
    ECHO:
    ECHO deleting WSL distro !wsl_distro! if it exists...
    ECHO wsl.exe --unregister !wsl_distro!
    DEL !install_location!\ext4.vhdx
    wsl.exe --unregister !wsl_distro!
    ECHO DONE
)

ECHO:
ECHO importing !wsl_distro!.tar to !install_location! as !wsl_distro!...
ECHO wsl.exe --import !wsl_distro! !install_location! !image_save_path! --version !wsl_version!
@SET /A _tic=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul

wsl.exe --import !wsl_distro! !install_location! !image_save_path! --version !wsl_version!
@SET /A _toc=%time:~0,2%*3600^
            +%time:~3,1%*10*60^
            +%time:~4,1%*60^
            +%time:~6,1%*10^
            +%time:~7,1% >nul
@SET /A _elapsed=%_toc%-%_tic
@REM IF !_elapse! LEQ 1 (
@REM     ECHO WSL import failure
@REM     SET "failed_before=y"
@REM     GOTO error_restart_prompt
@REM ECHO deleting !image_save_path! ...
@REM DEL !image_save_path!
@REM ECHO !image_save_path! deleted
IF "!image_service_suffix!" == "kernel" (
	SET "wsl_default_distro="
    SET "wsl_default_kernel="
    SET "wsl_default_kernel_version="
    SET "wsl_default_kernel_config_version="
    @REM ECHO wsl.exe -d %wsl_distro% --cd /boot --user r00t --exec bash uname -r ^> !wsl_default_kernel_path!
    @REM wsl.exe -d %wsl_distro% --cd /boot --user r00t --exec bash uname -r > !wsl_default_kernel_path!
    @REM kindtek-kernel-6L1WZB-gf53bd0a62a32
    @REM echo 6.1.21.2-kindtek-kernel-6L1WBZ-gf53bd0a62a32-dirty > !wsl_default_kernel_path!
    @REM ECHO wsl.exe -d %wsl_distro% --cd /boot --user r00t --exec bash ls -tx1 config* ^| tail -n 1 ^> %wsl_default_kernel_config_version_path%
    wsl.exe --user r00t -d %wsl_distro% -- cd /boot ^&^& ls -tx1 config* ^| tail -n 1 > !wsl_default_kernel_config_version_path!
    SET /P wsl_default_kernel=<!wsl_default_kernel_path!
    SET /P wsl_default_kernel_config_version=<!wsl_default_kernel_config_version_path!
    FOR /F "tokens=2* delims=-" %%a IN (        
        "!wsl_default_kernel_config_version!" 
    ) DO (
        SET "wsl_default_kernel_version=%%a"
        ECHO %%a > !wsl_default_kernel_version_path! 
    )
    @REM net stop docker
    @REM net stop com.docker.service
    @REM wsl.exe -d %wsl_distro% --cd /hal --user agl --exec bash sudo apt-get install -y powershell dwarves initramfs-tools firmware-linux zstd
    wsl.exe -d %wsl_distro% -- cd ^$HOME ^&^& sudo apt-get install -y powershell dwarves initramfs-tools firmware-linux zstd
    @REM wsl.exe -d %wsl_distro% --cd /boot --user r00t --exec bash cp config-!wsl_default_kernel_version! config-!wsl_default_kernel!
    wsl.exe --user r00t -d %wsl_distro% -- cp -f /boot/config-!wsl_default_kernel_version! /boot/config-!wsl_default_kernel!
    @REM wsl.exe -d %wsl_distro% --cd /boot --user r00t --exec bash cp System.map-!wsl_default_kernel_version! System.map-!wsl_default_kernel!
    wsl.exe --user r00t -d %wsl_distro% -- cp -f /boot/System.map-!wsl_default_kernel_version! /boot/System.map-!wsl_default_kernel!
    @REM wsl.exe -d %wsl_distro% --cd /r00t/dvlw/dvlp/kernels/linux --user r00t --exec update-initramfs -u -k !wsl_default_kernel!
    wsl.exe --user r00t -d %wsl_distro% -- update-initramfs -u -k !wsl_default_kernel!
    @REM wsl.exe -d %wsl_distro% --cd /r00t/dvlw/dvlp/kernels/linux --user r00t --exec bash mkdir -p /mnt/c/users/%USERNAME%/kache
    wsl.exe --user r00t -d %wsl_distro% -- mkdir -p /mnt/c/users/%USERNAME%/kache
    @REM wsl.exe -d %wsl_distro% --cd /r00t/dvlw/dvlp/kernels/linux --user r00t --exec bash cp -rf kache/. /mnt/c/users/%USERNAME%/kache/.
    wsl.exe --user r00t -d %wsl_distro% -- cp -rf /r00t/dvlw/dvlp/kernels/linux/kache/. /mnt/c/users/%USERNAME%/kache/.

    ECHO: default kernel !wsl_default_kernel!
    @REM wsl.exe -d %wsl_distro% --user r00t --exec bash update-initramfs -u -k !wsl_default_kernel!
    @REM wsl.exe -d %wsl_distro% --cd /hal --user agl --exec bash reclone-gh.sh autodel
    wsl.exe -d %wsl_distro% -- cd ^$HOME ^&^& bash reclone-gh.sh autodel

    @REM wsl.exe -d %wsl_distro% --cd /hal/dvlw/dvlp/kernels/linux --user agl --exec bash install-kernel.sh %USERNAME% latest latest
    wsl.exe -d %wsl_distro% -- cd ^$HOME/dvlw/dvlp/kernels/linux ^&^& bash install-kernel.sh %USERNAME% latest latest

)
NET STOP LxssManager >NUL
NET START LxssManager >NUL
ECHO DONE
IF "!default_wsl_distro!" == "y" (
    GOTO set_default_wsl_distro
) ELSE (
    GOTO wsl_distro_launch_prompt
)


:set_default_wsl_distro
SET "module=set_default_wsl_distro"
IF "!handle!" == "wsl_import" (
    SET "handle=set_default_wsl_distro"
)
IF "!default_wsl_distro!" == "y" (

    ECHO:
    ECHO setting default WSL distro as !wsl_distro!...
    ECHO  wsl.exe --set-default !wsl_distro! 
    wsl.exe --set-default !wsl_distro! 
    ECHO DONE
    SET "options=options"
    ECHO:
    ECHO  ..if starting WSL results in an error, try converting the distro version to WSL1 by running:
    ECHO wsl.exe --set-version !wsl_distro! 1
    ECHO:
    @REM reset default flag
    SET "default_wsl_distro=n"
)

:wsl_distro_launch_prompt
SET "module=wsl_distro_launch_prompt"
SET "handle=wsl_distro_launch_prompt"
@REM make sure windows paths transfer
SET WSLENV=USERPROFILE/P
ECHO Windows Subsystem for Linux Distributions:
wsl.exe -l -v
ECHO:
wsl.exe --status
ECHO:
SET "wsl_launch="
IF NOT "!image_repo!" == "kalilinux" (
    IF "!image_repo!" == "kindtek" (
        echo wsl -d !wsl_distro! -- cd ^$HOME ^&^& bash setup.sh %USERNAME%
        wsl.exe -d !wsl_distro! -- cd ^$HOME ^&^& bash setup.sh %USERNAME%
    )
    ECHO press ENTER to open terminal for newly created !wsl_distro!
    ECHO  ..or enter any character to skip 
    ECHO|set /p="(open !wsl_distro! terminal):"
    @REM make sure windows paths transfer
    SET /P "wsl_launch=> "
    IF /I "!wsl_launch!" == "" (
        wsl.exe -d !wsl_distro! -- cd / ^&^& bash
    ) ELSE (
        ECHO "skipping preview for !wsl_distro! ..."
    )
)

:wsl_distro_test
ECHO testing !wsl_distro! ...
@REM @echo on
SET "module=wsl_distro_test"
SET "handle=wsl_distro_test"
SET test_string=helloworld
SET "wsl_distro_test_pass=n"
SET "test_string_path=%USERPROFILE%\.wsl_test"
wsl.exe -d !wsl_distro! echo !test_string! > !test_string_path!
SET /P wsl_out=<!test_string_path!
DEL !test_string_path!
@REM SET "wsl_out="
@REM FOR /F %%g IN (!wsl_in!) DO (
@REM     @SET "wsl_out=%%g"
@REM     IF "!DVLP_DEBUG!" == "y" (
@REM         ECHO "wsl_in: !wsl_in!"
@REM         ECHO "wsl_out: : !wsl_out!"
@REM         ECHO "test_string: !test_string!"
@REM     )
@REM )

IF "!DVLP_DEBUG!" == "y" (
    ECHO "wsl_out^: !wsl_out!
    ECHO test_string^: !test_string!
)
IF "!wsl_out!" == "!test_string!" (
    SET "wsl_distro_test_pass=y"
    @REM add !wsl_distro! to Docker integrated WSL distro list
    @REM powershell -Command ". ..\..\dvlw\scripts\devel-tools.ps1; set_docker_config('!wsl_distro!');"
    ECHO !wsl_distro! was imported successfully!
    @REM ECHO updating !wsl_distro! ...
    @REM wsl.exe -d !wsl_distro! -- bash sudo apt-get update -y && sudo apt-get upgrade -y

    @REM wsl.exe -d !wsl_distro! -- bash apt update -y && apt-get upgrade -y

) ELSE (
    SET "wsl_distro_test_pass=n"
    ECHO !wsl_distro! did not boot.
)
IF "!DVLP_DEBUG!" == "y" (
    ECHO "wsl_distro_test_pass: !wsl_distro_test_pass!"
)

:wsl_set_conversion_version
IF NOT "!handle!" == "wsl_distro_launch" (
    SET "handle=wsl_set_conversion_version"
)
SET "module=wsl_set_conversion_version"
IF !set_wsl_conv! NEQ 1 (
    IF NOT !set_wsl_conv! EQU 2 (
        SET /A "set_wsl_conv=%wsl_version_int%%% 2 + 1" 
    )
)

:wsl_distro_error_handler
SET "module=wsl_distro_error_handler"
IF NOT "!handle!" == "wsl_distro_test" (
    SET "handle=wsl_distro_error_handler"
)
IF !set_wsl_conv! EQU 0 (
    IF !set_wsl_conv! NEQ 1 (
        IF !set_wsl_conv! NEQ 2 (
            GOTO wsl_set_conversion_version
        )
    )
)
IF "!wsl_distro_test_pass!" == "n" (
    SET "convert="
    ECHO ERROR DETECTED
    IF "!interactive!" == "y" (    
        @REM wsl.exe -d !wsl_distro!
        ECHO try to convert distro version to WSL!set_wsl_conv!? ^(y^)^/n
        SET /P "convert="
        IF /I "!convert!" == "" (
            SET "convert=y"
        )
        IF /I "!convert!" == "yes" (
            SET "convert=y"
        )
        IF NOT "!convert!" == "y" (
            ECHO !wsl_distro! failed to import.
            SET "options=options"
            GOTO wsl_delete_prompt
        )
    )  ELSE (
        IF /I "!convert!" == "y" (
            SET "convert=n"
            GOTO wsl_delete
        ) ELSE (
            SET "convert=y"
        )
    )  
) ELSE (
    GOTO quit
)  

:wsl_distro_convert_version
IF NOT DEFINED set_wsl_conv (
    GOTO wsl_set_conversion_version
) ELSE (
    wsl.exe --set-version !wsl_distro! !set_wsl_conv!
    IF !set_wsl_conv! EQU 2 (
        SET set_wsl_conv=1
    ) ELSE (
        SET set_wsl_conv=2
    )
    GOTO wsl_distro_test
)

:wsl_delete_prompt
SET "module=wsl_delete_prompt"
ECHO Delete !wsl_distro!? (y^^^)^^/^^n
SET /P "delete="
IF /I "!delete!" == "" (
    SET "delete=yes"
)
IF /I "!delete!" == "y" (
    SET "delete=yes"
)
IF /I "!delete!" == "yes" (
    SET "delete=yes"
    GOTO wsl_delete 
)
SET "options=options" 
IF "!interactive" == "y" (
    GOTO home_banner
) ELSE ( GOTO quit )

:wsl_delete
wsl.exe --unregister !wsl_distro!
IF "!interactive" == "y" (
    GOTO redo
) ELSE ( GOTO quit )

:wsl_distro_launch
IF "!wsl_distro_test_pass!" == "y" (
    ECHO launching WSL with !wsl_distro! distro...
    ECHO wsl.exe -d !wsl_distro!
    wsl.exe -d !wsl_distro!
) ELSE (
    GOTO wsl_distro_test
)

:custom_config
SET "module=custom_config"
SET "handle=custom_config"
IF "!interactive!" == "n" (
    GOTO quit
)

color 0B

@REM @TODO: filter/safeguard user input
ECHO:
SET /P "image_repo=image repository: (!image_repo_mask!) > "
SET "old_image_name_tag=!image_name_tag!"
SET /P "image_name_tag=image name/tag in !image_repo!: (!image_name!:!image_tag!) > "
@REM reset image_built flag if the image_name_tag changes
IF NOT "!old_image_name_tag!" == "!image_name_tag!" (
    SET "docker_image_built=n"
)
IF "!DVLP_DEBUG!" == "y" (
    @REM SET "image_name="
    @REM SET "image_tag="
    @REM SET "image_name="
    ECHO IMG_NAME !image_name!
    ECHO IMG_TAG !image_tag!
    ECHO IMG_NAME_TAG !image_name_tag!
    ECHO OLD_IMG_NAME_TAG !old_image_name_tag!
)
FOR /F "tokens=1 delims=:" %%a IN (
    "%image_name_tag%"
) DO (
    SET "image_name=%%a"
)
SET "image_tag=%image_name_tag::=" & SET "image_tag=%"
@REM SET "image_name_tag=!image_name!:!image_tag!"
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF "!image_repo!" == "_" (
    SET "image_repo_name_tag=!image_name!:!image_tag!"
    IF "!image_tag!" == "" (
        SET "image_repo_name_tag=!image_name!"
    )
) 
IF "!wsl!" == "y" (
    SET /P "save_directory=download folder: !mount_drive!:\(!save_directory!) > "
)
SET install_directory=!image_repo_name_tag:/=-!
SET install_directory=!install_directory::=-!
IF "!wsl!" == "y" (
    SET /P "install_directory=install folder: !mount_drive!:\!save_directory!\(!install_directory!) > "
)
SET install_directory=!install_directory:/=-!
SET install_directory=!install_directory::=-!
@REM not possible to set this above bc it will overlap with the default initializing so set it here
SET save_location=!mount_drive!:\!save_directory!
SET install_root_dir=!save_location!\!install_directory!
@REM special rule for official distro
IF "!image_repo!" == "_" (
    SET "wsl_distro=official-!install_directory!"
) ELSE (
    SET "wsl_distro=!install_directory!" 
)
IF "!wsl!" == "y" (
    SET /P "wsl_distro=distro name in WSL: (!wsl_distro!) > "
)
SET "wsl_distro=!wsl_distro::=-!"
SET "wsl_distro=!wsl_distro:/=-!"
IF "!wsl!" == "y" (
    SET /P "wsl_version=WSL version: (!wsl_version_int!) > "
    IF "!wsl_version!" == "2" (
        SET wsl_version_int=2
    ) ELSE (
        SET wsl_version_int=1 
    )
)

ECHO:
@REM GOTO home_banner
@REM SET "options="
@REM ECHO Press ENTER to import !wsl_distro! as a distro into WSL
@REM ECHO:   or enter [o]ptions to see more options
@REM SET /P "options=$ "
@REM IF "!options!" == "" (
@REM     SET "options=import"
@REM     GOTO set_paths
@REM )
@REM IF "!options!" == "o" (
@REM     SET "options=options"
@REM )
@REM IF "!options!" == "options" (
@REM     GOTO home_banner
@REM ) ELSE (
@REM     GOTO options_parse
@REM )
color 0F

:config
SET "module=config"
IF "!handle!" == "custom_config" (
    SET "handle=config"
)
SET "save_location=!mount_drive!:\!save_directory!"
SET "install_root_dir=!save_location!\!wsl_distro!"
SET "image_save_path=!save_location!\!wsl_distro!.tar"
SET "image_repo_name_tag=!image_repo_mask!/!image_name!:!image_tag!"
IF "!image_tag!" == "" (
    SET "image_repo_name_tag=!image_repo_mask!/!image_name!"
    IF "!image_repo!" == "" (
        SET "image_repo_name_tag=!image_name!"
    )
)
IF "!image_repo!" == "" (
    SET "image_repo_name_tag=!image_name!:!image_tag!"
    IF "!image_tag!" == "" (
        SET "image_repo_name_tag=!image_name!"
    )
)
@REM special rule for official distros on docker hub
@REM replaces '_' with 'official' for printing
IF "!image_repo!" == "_" (
    @REM official repo has no repo name in address/url
    SET "image_repo_name_tag=!image_name!:!image_tag!"

) 
SET "docker_image_id_path=!install_root_dir!\.image_id"
SET "docker_container_id_path=!install_root_dir!\.container_id"

:home_banner
@REM CLS
SET "handle=home_banner"
ECHO:
ECHO       _____________________________________________________________________ 
ECHO      /                            DOCKER DEVEL                             \
ECHO      \______________  WSL import tool for Docker Hub images  ______________/
ECHO        -------------------------------------------------------------------
ECHO        ............    Image settings                         ............
ECHO        ............-------------------------------------------............
ECHO        ............    source:                                ............
ECHO        ............      !image_repo_mask!                              
ECHO        ............                                           ............
ECHO        ............    name/tag:                              ............
ECHO        ............      !image_name!:!image_tag!                   

IF "!wsl!" == "y" (
    ECHO        ............                                           ............
    ECHO        ............    import into WSL:                       ............
    ECHO        ............      yes                                  ............
    ECHO        ............                                           ............
    ECHO        ............    download to:                           ............
    ECHO        ............       !image_save_path! 
    ECHO        ............                                           ............
    ECHO        ............    WSL alias:                             ............
    ECHO        ............       !wsl_distro!          
    IF "!default_wsl_distro!" == "y" (
        ECHO       ..............                                         ..............
        ECHO       ..............    default:                             ..............
        ECHO       ..............      yes                                ..............

    ) ELSE (
        ECHO       ..............                                         ..............
        ECHO       ..............    default:                             ..............
        ECHO       ..............      no                                 ..............

    )
) ELSE (
    ECHO      ..............                                         ..............
    ECHO      ..............    import into WSL:                     ..............
    ECHO      ..............      no                                 ..............

)

ECHO      -----------------------------------------------------------------------
ECHO:

:home_prompt
SET "module=home_prompt"
SET "prompt_type=home"
SET "docker_do="
IF NOT "!handle!" == "home_banner" (
    SET "handle=home_prompt"
)
SET above=above
IF "!interactive!" == "n" (
    IF NOT "!image_repo!" == "kalilinux" (
        @REM official repo has no repo name in address/url
        SET "options=build"
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "options0: !options!"
            ECHO "image_name_tag: !image_name_tag!"
        )
        GOTO options_parse
    )
)

IF DEFINED failed_before (
    IF fail_count GTR 2 (
        @REM SET fail_count=0
        echo !fail_count!
        GOTO error_restart_prompt
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

IF "!interactive!" == "n" (
    SET "quiet_home_prompt=y"
) ELSE (
    IF "!options!" == "options" (
        SET "quiet_home_prompt=n"
    ) ELSE (
        SET "quiet_home_prompt=n"
        ECHO Confirm !above! settings.
        ECHO: 
        ECHO: 
        ECHO: 
    )
)

SET "home_default_option=build"

IF "!wsl!" == "y" (
    IF "!image_repo!" == "kindtek" (
        IF "!image_built!" == "y" ( 
            IF "!quiet_home_prompt!" == "n" (
                ECHO    Press ENTER to import locally built !image_name! into WSL
                @REM SET "options=build"
            )
        ) ELSE (
            SET "home_default_option=pull"
            IF "!quiet_home_prompt!" == "n" (
                ECHO    Press ENTER to pull !image_name! and import into WSL as !wsl_distro!
            )
        )
    ) ELSE (
        IF "!quiet_home_prompt!" == "n" (
            ECHO    Press ENTER to pull !image_name! and import into WSL as !wsl_distro!
            @REM SET "options=build"
        )
    )
) ELSE (
    IF "!image_repo!" == "kindtek" (
        IF "!quiet_home_prompt!" == "n" (
            ECHO    Press ENTER to build !image_name! in Docker
            @REM SET "options=build"
        )
    ) ELSE (
        IF "!quiet_home_prompt!" == "n" (
            ECHO    Press ENTER to pull !image_name! in Docker
        )
        SET "home_default_option=pull"
    )
)
IF "!quiet_home_prompt!" == "n" (
    ECHO        ..or type [o]ptions
)
ECHO:
@REM IF "!options!" == "options" (
IF "!DVLP_DEBUG!" == "y" (
    ECHO "options1: !options!"
    ECHO "home_default_option1: !home_default_option!"
)
@REM avoid building official sources
IF "!image_repo!" == "_" (
    SET "home_default_option=pull"
)
@REM IF "!quiet_home_prompt!" == "n" (
@REM     IF "!DVLP_DEBUG!" == "y" (
@REM         ECHO "no quiet prompt"
@REM     )
@REM     SET "options=!home_default_option!"
@REM     SET "confirm="
@REM     SET /P "confirm=$ "
@REM     IF NOT "!confirm!" == "" (
@REM         SET "options=!confirm!"
@REM         IF "!DVLP_DEBUG!" == "y" (
@REM             ECHO "options set to !confirm! (confirm)"
@REM         )
@REM         @REM SET "confirm="
@REM     ) ELSE (
@REM         SET "options=!home_default_option!"
@REM         IF "!DVLP_DEBUG!" == "y" (
@REM             ECHO "options set to !home_default_option! (home_default_option)"
@REM         )
@REM     )
@REM )
IF "!DVLP_DEBUG!" == "y" (
    ECHO "options2: !options!"
    ECHO "home_default_option2: !home_default_option!"
)

:options_prompt
@REM SET "module=options_prompt"
SET "prompt_type=options_prompt"
SET "handle=options_prompt"

IF /I "!options!" == "o" (
    SET "options=options"
)
IF /I "!options!" == "options" (
    SET "display_options=y"

)
IF "!interactive!" == "y" (
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "interactive session"
        ECHO "options3: !options!"
    )
    IF "!display_options!" == "y" (
        ECHO   options:
        ECHO:
        ECHO        [h]ome      go to home screen

        IF "!module!" == "wsl_distro_launch_prompt" (
            ECHO        [c]onfig    configure import settings
            ECHO        [d]efault   !default_wsl_distro! toggle !image_repo_name_tag! image as default WSL distro 
        ) ELSE (
            IF "!module!" == "custom_config" (
                ECHO        [c]onfig    edit !image_repo_name_tag! import configuration
            ) ELSE (
                ECHO        [c]onfig    configure import settings
            )

            IF "!wsl!" == "y" (
                ECHO        [l]aunch    launch !wsl_distro! if it exists in WSL
                ECHO        [p]ull      pull and import !image_name_tag! image into WSL
                ECHO        [b]uild     build and import !wsl_distro! into WSL
                ECHO        [P]ush      push a built image to Hub
                IF "!image_built!" == "y" (
                    ECHO        [i]nstall[P]   [i]nstall[b] ^^+ push to !to image_repo!
                )
                ECHO [ON]   [w]sl       toggle - import !image_repo_name_tag! into WSL 
                IF "!default_wsl_distro!" == "y" (
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
        IF /I "!options!" == "options" (
            IF NOT "!home_default_option!" == "" (
                IF "DVLP_DEBUG" == "y" (
                    ECHO "options=home_default_option: !options!"
                )
                @REM post option (don't discard)
                SET "options=!home_default_option!"
                @REM SET "home_default_option="
            )
        ) 
        IF "DVLP_DEBUG" == "y" (
            ECHO "MAIN OPTS: !home_default_option!"
            ECHO "OPTIONS: !options!"
        )
        SET "display_options=n"
    ) 
    ECHO (!home_default_option!^^^)
    SET "confirm="
    SET /P "confirm="
    IF NOT "!confirm!" == "" (
        SET "options=!confirm!"
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "options set to !confirm! (confirm)"
        )
        @REM SET "confirm="
    ) ELSE (
        SET "options=!home_default_option!"
        IF "!DVLP_DEBUG!" == "y" (
            ECHO "options set to !home_default_option! (home_default_option)"
        )
    )
    IF "!options!" == "o" (
        SET "options=options"
    )
    IF "!options!" == "options" ( 
        @REM SET "options="
        GOTO options_prompt
    )
) ELSE (
    SET "options=!home_default_option!"
)
:options_parse
IF NOT "!handle!" == "options_prompt" (
    SET "handle=options_parse"
)
color 0F
SET "handle=options_parse"
SET "opti0ns=!options!"
IF "!DVLP_DEBUG!" == "y" (
    ECHO "OPTIONS PARSE: !options!"
    ECHO "OPTI0NS PARSE: !opti0ns!"
    ECHO "go2 PARSE: !go2!"
    ECHO "MOD: !module!"
    ECHO "EXIT_MOD: !exit_module!"
    ECHO HANDLE !handle!
    ECHO "WSL: !wsl!"
)

IF /I "!opti0ns!" == "b" (
    SET "opti0ns=build"
)
IF /I "!opti0ns!" == "build" (
    IF /I "!image_name_tag!" == "default" (
        SET "docker_image_do=docker_image_pull"
        @REM ECHO option 'build' selected
        SET "opti0ns=pull"
        SET "go2=set_paths"
        GOTO switchboard
    ) ELSE (
        SET "docker_image_do=docker_image_build"
        @REM ECHO option 'build' selected
        SET "go2=set_paths"
        GOTO switchboard
    )
)
@REM p -> pull
IF "!opti0ns!" == "p" (
    SET "opti0ns=pull"
)
IF /I "!opti0ns!" == "pull" (
    SET "docker_image_do=docker_image_pull"
    SET "go2=set_paths"
    GOTO switchboard
)
@REM P -> push
IF /I "!image_built!" == "y" (
    IF "!opti0ns!" == "P" (
        SET "opti0ns=push"
    )
    IF /I "!opti0ns!" == "push" (
        SET "docker_image_do=docker_image_push"
        SET "go2=set_paths"
        GOTO switchboard
    )
)
IF /I "!opti0ns!" == "c" (
    SET "opti0ns=config"
)
IF /I "!opti0ns!" == "config" (
    @REM ECHO option 'config' selected
    SET "go2=custom_config"
    GOTO switchboard
)
IF /I "!opti0ns!" == "h" (
    SET "opti0ns=home"
)
IF /I "!opti0ns!" == "home" (
    @REM ECHO option 'config' selected
    SET "go2=home_banner"
    GOTO switchboard
)
@REM IF "!module!" == "wsl_distro_launch_prompt" (
@REM     IF "!opti0ns!" == "d" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         GOTO set_default_wsl_distro
@REM     )
@REM     IF "!opti0ns!" == "default" (
@REM         SET "default_wsl_distro=y"
@REM         ECHO option 'default' selected
@REM         SET "go2= set_default_wsl_distro"
@REM     )
@REM ) ELSE (
    IF /I "!opti0ns!" == "dw" (
        @REM ECHO option 'default' selected
        SET "opti0ns=dwsl"
    )
    IF /I "!opti0ns!" == "d" (
        @REM ECHO option 'default' selected
        SET "opti0ns=dwsl"
    )
    IF /I "!opti0ns!" == "dwsl" (
        SET "default=default"
        @REM ECHO option 'default' selected
        ECHO flag changed
        IF "!default_wsl_distro!" == "y" (
            SET "default_wsl_distro=n"
            ECHO " [ON]  default distro
        ) ELSE (
            ECHO " [OFF] default distro"
            SET "default_wsl_distro=y"
        )
        
        SET "opti0ns=options"
        @REM SET "go2= docker_image_pull"
        SET "go2= home_banner"
        GOTO switchboard
    )
@REM )
IF /I "!opti0ns!" == "l" (
    SET "opti0ns=launch"
)
IF /I "!opti0ns!" == "launch" (
    SET "go2=wsl_distro_launch_prompt"
    GOTO switchboard
)
IF /I "!opti0ns!" == "o" (
    SET "opti0ns=options"
)
IF /I "!opti0ns!" == "options" (
    IF "!handle!" == "error_restart_prompt" (
        GOTO options_prompt
    ) ELSE (
        IF "!handle!" == "options_prompt" (
            GOTO options_prompt
        ) ELSE (
            GOTO home_banner
        )
    )
)
IF /I "!opti0ns!" == "r" (
    ECHO "RESTART COMPUTER 1"
    SET "opti0ns=restart"
)
IF /I "!opti0ns!" == "restart" (
    ECHO "RESTART COMPUTER 2"

    ECHO option 'restart' selected
    SET "go2=computer_restart_prompt"
    GOTO switchboard
)
IF /I "!opti0ns!" == "w" (
    SET "opti0ns=wsl"
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "opti0ns: !opti0ns!"
        ECHO "wsl: !wsl!"
    )
)
IF /I "!opti0ns!" == "wsl" (
    @REM ECHO option 'default' selected
    ECHO default flag changed
    IF "!wsl!" == "y" (
        SET "wsl=n"
        ECHO "toggle wsl import [OFF]"
    ) ELSE (
        ECHO "toggle wsl import [ON]"
        SET "wsl=y"
    )
    SET "opti0ns=options"
    @REM SET "go2=docker_image_pull"
    SET "go2=home_banner"
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "opti0ns: !opti0ns!"
        ECHO "wsl: !wsl!"
    )
    GOTO switchboard
)

IF /I "!opti0ns!" == "debug" (
    SET "DVLP_DEBUG=n"
    IF "!DVLP_DEBUG!" == "y" (
        SET "DVLP_DEBUG=n"
        ECHO "toggle debug output [OFF]"
    ) ELSE (
        ECHO "toggle debug output [ON]"
        SET "DVLP_DEBUG=y"
    )
    SET "opti0ns=options"
    @REM SET "go2=docker_image_pull"
    SET "go2=home_banner"
    GOTO switchboard
)

IF /I "!opti0ns!" == "x" (
    SET "go2=program_restart_prompt"
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "x-opti0ns: !opti0ns!"
    )
    GOTO switchboard
)
IF /I "!opti0ns!" == "exit" (
    SET "go2=quit"
    IF "!DVLP_DEBUG!" == "y" (
        ECHO "exit-opti0ns: !opti0ns!"
    )
    GOTO switchboard
)

:switchboard
@REM 
@REM SET "exit_module=switchboard"
SET "handle=switchboard"
IF "!DVLP_DEBUG!" == "y" (
    ECHO "OPTIONS PARSE: !options!"
    ECHO "OPTI0NS PARSE: !opti0ns!"
    ECHO "go2 PARSE: !go2!"
    ECHO "MOD: !module!"
    ECHO "EXIT_MOD: !exit_module!"
    ECHO HANDLE !handle!
)
IF NOT "!opti0ns!" == "" (
    SET "options=!opti0ns!"
)

IF NOT "!go2!" == "" (
    GOTO !go2!
) ELSE (
    GOTO home_banner
)

@REM GOTO home_banner

:computer_restart_prompt
SET "handle=computer_restart_prompt"
SET "prompt_type=computer_restart_prompt"
IF "!interactive!" == "n" (
    GOTO quit
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
ECHO        Enter [o]ptions for options
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
SET /P "options=> "
IF "!options!" == "" (
@REM dism /Online /Cleanup-Image /RestoreHealth
    ECHO "initializing restart ..."
    SET "options=restart_now"
    @REM shutdown /r
    @REM GOTO quit
    @REM exit
)
IF /I "!options!" == "o" (
    SET "options=options"
)
IF /I "!options!" == "options" (
    COLOR 0F
    SET "docker_do="
    GOTO home_banner
) ELSE (
    IF /I "!options!" == "r" (
        SET "options=restart_now"
    )
    IF /I "!options!" == "restart" (
        SET "options=restart_now"
    )
    IF /I "!options!" == "restart_now" (
        shutdown /r
        GOTO quit
    ) ELSE (
        COLOR 0F
        GOTO options_parse
    )
    
)


:no
GOTO home_banner

:error_restart_prompt:
SET "handle=error_restart_prompt"
SET "prompt_type=error_restart_prompt"
SET "prompt_error_msg=sorry - import failed. "

IF "!interactive!" == "n" (
    GOTO quit
)
SET "failed_before=y"
ECHO:
:program_restart_prompt
IF NOT "!handle!" == "error_restart_prompt" (
    SET "handle=program_restart_prompt"
)
SET "prompt_type=program_restart_prompt"

IF "!interactive!" == "n" (
    GOTO quit
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
ECHO: !prompt_error_msg!
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
SET /P "exit_devels_playground="
COLOR 0F

IF "!exit_devels_playground!" == "" (
    SET "exit_devels_playground=exit"
)
SET "options=!exit_devels_playground!"
SET "prompt_error_msg="
GOTO options_parse

:quit
:exit
IF "!interactive!" == "y" (
    ECHO:
) ELSE (
    @REM ECHO exiting from module !module!
    @REM ECHO exiting devel's playground
    ECHO:  
)
