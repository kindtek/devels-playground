# Set-PSDebug -Trace 2
Set-PSDebug -Off


function main {
    # Clear-Host
    $host.UI.RawUI.BackgroundColor = "Black"
    $host.UI.RawUI.ForegroundColor = "White"
    dev_boilerplate
}
# from https://stackoverflow.com/questions/44703646/determine-the-os-version-linux-and-windows-from-powershell
function Get-PSPlatform {
    return [System.Environment]::OSVersion.Platform
}
function dev_boilerplate {

    # set default vars
    $image_repo = "_"
    # mask = human readable - ie 'official' not '_'
    $image_repo_mask = "official"
    $image_name = "ubuntu:latest"
    $mount_drive_letter = "c"
    $unix_mount_drive = "/mnt/$mount_drive_letter"
    $windows_mount_drive = "${mount_drive_letter}:"
    $mount_drive = $unix_mount_drive

    
    # check OS to get relevant C drive path
    # from https://stackoverflow.com/questions/44703646/determine-the-os-version-linux-and-windows-from-powershell
    switch (Get-PSPlatform) {
        'Win32NT' { 
            New-Variable -Option Constant -Name IsWindows -Value $True -ErrorAction SilentlyContinue
            New-Variable -Option Constant -Name IsLinux  -Value $false -ErrorAction SilentlyContinue
            New-Variable -Option Constant -Name IsMacOs  -Value $false -ErrorAction SilentlyContinue
        }
    }

    if ($IsLinux) {
        Write-Host "Linux OS detected"
        $mount_drive = $unix_mount_drive

    }
    # while we're here might as well
    elseif ($IsMacOS) {
        Write-Host "macOS OS detected"
        $mount_drive = $unix_mount_drive
    }
    elseif ($IsWindows) {
        Write-Host "Windows OS detected"
        $mount_drive = $windows_mount_drive
    }


    $save_directory = "docker"
    $wsl_version = "2"


    $install_directory = "$image_repo_mask-$image_name"
    $install_directory = $install_directory.replace(':', '-')
    $install_directory = $install_directory.replace('/', '-')

    # $save_location = "${mount_drive}:/$save_directory"
    $save_location = "${mount_drive}/$save_directory"
    # Write-Host "save location: $save_location"
    $install_location = "$save_location/$install_directory"
    # Write-Host "install location: $install_location"

    # @REM distro - meaning local distro
    $distro = $install_directory
    # @REM :header
    $image_save_path = "$save_location/$distro.tar"
    $install_location = "$save_location/$install_directory"
    $image_repo_image_name = "$image_repo/$image_name"
    # @REM special rule for official distros on docker hub
    # @REM replaces '_' with 'official' for printing
    if ( $image_repo -eq "_") {
        # @REM official repo has no repo name in address/url
        $image_repo_image_name = $image_name
    }
    

    $config = greeting_prompt $image_repo_mask $image_name $image_save_path $distro

    # @REM prompt user to type input or hit enter for default shown in parentheses
    if ($config -eq "config") {

        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Green"
        # @REM @TODO: filter/safeguard user input
        Write-Host `r`n
        $image_repo_prompt = Read-Host -Prompt "image repository ($image_repo_mask) $ "
        if ($image_repo_prompt -ne "") {
            $image_repo = $image_repo_prompt
            $image_repo_mask = $image_repo_prompt
        }
        else {
            $image_repo = $image_repo_mask
        }

        $image_name_prompt = Read-Host -Prompt "image name in ${image_repo_mask} ($image_name) $ "
        if ($image_name_prompt -ne "") {
            $image_name = $image_name_prompt
        }
        # @REM special rule for official distros on docker hub
        # @REM replaces '_' with 'official' for printing
        if ($image_repo -eq "_") {
            $image_repo_image_name = $image_name
        }
        else {
            $image_repo_image_name = "$image_repo_mask/$image_name"
        }

        # set default var before prompt
        $save_directory_prompt = Read-Host -Prompt "download folder ${mount_drive}/($save_directory) $ "
        if ($save_directory_prompt -ne "") {
            $save_directory = $save_directory_prompt
        }
        $save_directory = $save_directory.replace('/', '-')
        $save_directory = $save_directory.replace(':', '-')
        
        $install_directory = "$image_repo_mask-$image_name"
        $install_directory = $install_directory.replace('/', '-')
        $install_directory = $install_directory.replace(':', '-')

        # set default var before prompt
        $install_directory_prompt = Read-Host -Prompt "install folder ${mount_drive}/$save_directory/($install_directory) $ "
        if ($install_directory_prompt -ne "") {
            $install_directory = $install_directory_prompt
            $install_directory = $install_directory.replace('/', '-')
            $install_directory = $install_directory.replace(':', '-')

        }

        $save_location = "${mount_drive}/$save_directory"
        $install_location = "$save_location/$install_directory"
        # @REM special rule for official distro
        if ($image_repo -eq "_") {
            $distro = "official-$install_directory"
        }
        else {
            $distro = $install_directory
        }

        $distro_prompt = Read-Host -Prompt "distro name in WSL: ($distro) $ "
        if ($distro_prompt -ne "") {
            $distro = $distro_prompt
        }
        
        $distro = $distro.Replace('/', '-')
        $distro = $distro.Replace(':', '-')
        $image_save_path = "$save_location/$distro.tar"
        $wsl_version_prompt = Read-Host  "WSL version: (2) $ "
        if ($wsl_version_prompt -ne "") {
            $wsl_version = $wsl_version_prompt
        }

        if ($wsl_version -ne "1" -And $wsl_version -ne "2") {
            # manually override default wsl version here
            $wsl_version = "2"
        }
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "White"
    }

    $null = New-Item -Path $save_location -ItemType Directory 
    Write-Host "install location:$install_location"
    $null = New-Item -Path $install_location -ItemType Directory 

  
    Write-Host "$save_location`r`n"
    Write-Host "$install_location`r`n"

    docker_image_pull $image_repo_image_name
    $WSL_DOCKER_CONTAINER_ID = docker_container_start $config $distro $image_repo_image_name $install_location
    $WSL_DOCKER_CONTAINER_ID = $WSL_DOCKER_CONTAINER_ID[0].substring(0,4)

    # now that we have container id, append it to install location and distro
    $install_location = "$install_location-$WSL_DOCKER_CONTAINER_ID"

    # update image id and container id path for later ref
    $distro = "$distro-$WSL_DOCKER_CONTAINER_ID"
    # Write-Host "`r`n!>>>>>>>containerid:$WSL_DOCKER_CONTAINER_ID<<<<<<<<<!`r`n"
    # Write-Host "`r`n!>>>>>>>containerid:$distro<<<<<<<<<!`r`n"

    export_image $install_location $save_location $distro $WSL_DOCKER_CONTAINER_ID
    import_docker_tar $distro $install_location $save_location $wsl_version
    wsl_or_exit $distro
    
}

function greeting_prompt {
    param ($image_repo_mask, $image_name, $image_save_path, $distro) 

    $dev_boilerplate_output = @"
    
     _____________________________________________________________________
    /                          DEV BOILERPLATE                            \
    \______________  WSL import tool for Docker Hub images  ______________/
      -------------------------------------------------------------------
      .............    Image settings                       .............
      .............-----------------------------------------.............
      .............    source:                              .............
      .............      $image_repo_mask                           
      .............                                         .............
      .............    name:                                .............
      .............      $image_name                     
      .............                                         .............
      .............    download to:                         .............
      .............      $image_save_path 
      .............                                         .............
      .............    WSL alias:                           .............
      .............      $distro-dockerID           
      -------------------------------------------------------------------
      
    
Press ENTER to use settings above and import $distro as default WSL distro 
 ..or type 'config' for custom install.
"@



    # @REM @TODO: add options ie: 
    # @REM Write-Host   ..or type:
    # @REM Write-Host           - 'registry' to specify distro from a registry on the Docker Hub
    # @REM Write-Host           - 'image' to import a local Docker image
    # @REM Write-Host           - 'container' to import a running Docker container
    # @REM @TODO: (and eventually add numbered menu)
    Write-Host $dev_boilerplate_output  
    $config = Read-Host -Prompt ' $'
    return $config
}

   
function docker_image_pull {

    param($image_repo_image_name)

    Write-Host "========================================================================"
    Write-Host "`r`n"
    Write-Host "pulling image ($image_repo_image_name)..."
    Write-Host "docker pull --platform linux $image_repo_image_name"
    # @REM pull the image
    docker pull --platform linux $image_repo_image_name
    Write-Host "`r`n"
}
function docker_container_start {
    param( [string]$config, [string]$distro, [string]$image_repo_image_name, [string]$install_path, [string]$docker_container_id_path  )
    Write-Host "initializing the image container..."
    Write-Host "docker images -aq $image_repo_image_name"
    # get single id returned from docker images command
    $WSL_DOCKER_IMG_ID = @(<docker images -aq $image_repo_image_name>)
    $WSL_DOCKER_IMG_ID = $WSL_DOCKER_IMG_ID[0]
    $docker_image_id_path = "$install_path/.image_id"
    $docker_container_id_path = "$install_path/.container_id"
    Write-Host $WSL_DOCKER_IMG_ID | Out-File -FilePath $docker_image_id_path
    # $null = Remove-Item $docker_container_id_path

    Write-Host "`r`n "
    Write-Host "========================================================================"
    Write-Host "`r`n"
    Write-Host "testing container..."
    Write-Host "`r`n"
    Write-Host "this container is running as a local copy of the image $image_repo_image_name"
    Write-Host "`r`n"
       
    Write-Host "docker run -itd --cidfile=$docker_container_id_path --name=$distro-$WSL_DOCKER_IMG_ID --sig-proxy=false $WSL_DOCKER_IMG_ID"
    docker run -itd --cidfile=$docker_container_id_path --name=$distro-$WSL_DOCKER_IMG_ID --sig-proxy=false $WSL_DOCKER_IMG_ID    
    
    # get first line of docker_container_id_path
    $WSL_DOCKER_CONTAINER_ID = Get-Content -Path $docker_container_id_path -TotalCount 1
    # Write-Host "containerid: $WSL_DOCKER_CONTAINER_ID"
    # Write-Host "docker stop $WSL_DOCKER_CONTAINER_ID"
    # docker stop $WSL_DOCKER_CONTAINER_ID
    # Write-Host "docker start $WSL_DOCKER_CONTAINER_ID"
    # docker start $WSL_DOCKER_CONTAINER_ID

    $install_path = "$install_path-$WSL_DOCKER_CONTAINER_ID"

    $null = New-Item -Path $install_path -ItemType Directory
    # Write-Host "Move-Item -Path $docker_image_id_path -Destination $install_path/.image_id"
    # Write-Host "Move-Item -Path $docker_container_id_path -Destination $install_path/.container_id"
    
    Move-Item -Path $docker_image_id_path -Destination "$install_path/.image_id"
    Move-Item -Path $docker_container_id_path -Destination "$install_path/.container_id"
    # Write-Host "Rename-Item -Path $docker_image_id_path -NewName $install_path/.image_id"
    # Write-Host "Rename-Item -Path $docker_container_id_path -NewName $install_path/.container_id"
    
    # Rename-Item -Path $docker_image_id_path -NewName "$install_path/.image_id"
    # Rename-Item -Path $docker_container_id_path -NewName "$install_path/.container_id"
    $docker_image_id_path = "$install_path/.image_id"
    $docker_container_id_path = "$install_path/.container_id"

    if ($config -eq "config") {
        
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Red"     
        Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Host "!!!!!! IMPORTANT: use CTRL-P then CTRL-Q to exit container preview !!!!!!"
        Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Host "`r`n"
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Cyan"  
        Write-Host "`r`ndocker attach $WSL_DOCKER_CONTAINER_ID`r`n"  
        Write-Host "`r`n"
        docker attach $WSL_DOCKER_CONTAINER_ID
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "White"

    }
    Write-Host "docker rename $distro-$WSL_DOCKER_IMG_ID $distro-$WSL_DOCKER_CONTAINER_ID"
    docker rename $distro-$WSL_DOCKER_IMG_ID $distro-$WSL_DOCKER_CONTAINER_ID

    Write-Host "`r`nclosing test container...`r`n========================================================================"

    return $WSL_DOCKER_CONTAINER_ID
}

function export_image {
    param( $install_location, $save_location, $distro, $WSL_DOCKER_CONTAINER_ID)
    # @REM directory structure: 
    # @REM %mount_drive%:\%install_directory%\%save_directory%
    # @REM ie: C:\wsl-distros\docker
    $image_save_path = "$save_location/$distro.tar"
    Write-Host "exporting image as container ($WSL_DOCKER_CONTAINER_ID) into .tar file..."
    Write-Host "docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path"
    Write-Host "this may take a while..."
    docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path
    Write-Host "DONE"
}

# @REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default distro
# @REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes distro default
function install_prompt {
    Write-Host "---------------------------------------------------------------------"
    Write-Host "Windows Subsystem for Linux Distributions:"
    wsl.exe -l -v
    Write-Host "---------------------------------------------------------------------"
    Write-Host "Check the list of current WSL distros installed on your system above. "
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "!!!!!!!!!!!!                   WARNING:                !!!!!!!!!!!!!!"
    Write-Host "If $distro.substring(0, 20) is already listed above it will be REPLACED.  "
    Write-Host "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Host "_____________________________________________________________________"
    Write-Host "`r`n"
    Write-Host "Would you still like to continue ([y]es/[n]o/[redo])?"
    $continue = Read-Host " $ "

    # @REM if blank -> y -> yes-install
    if ($continue -eq "") {
        $continue = "y"
    }
    # @REM if yes -> default-install 
    if ($continue -eq "yes") {
        $continue = "default-install"
    }
    # @REM if y -> yes-install 
    if ($continue -eq "y") {
        $continue = "yes-install"
    }

    # @REM if n -> no-install
    if ($continue -eq "n") { 
        $continue = "no-install"
    }

    return $continue
}



function import_docker_tar {
    param([string]$distro, [string]$install_location, [string]$save_location, [string]$wsl_version)
    
    $setdefault = "no"

    Write-Host "`r`n"
    Write-Host "killing the $distro WSL process if it is running..."
    Write-Host "wsl.exe --terminate $distro"
    wsl.exe --terminate $distro
    Write-Host "DONE"
    # @REM Write-Host `r`n
    # @REM Write-Host killing all WSL processes...
    # @REM wsl.exe --shutdown
    # @REM Write-Host DONE
    $install = install_prompt

    if ($install -eq "yes-install" -Or $install -eq "default-install") {
        Write-Host "`r`ndeleting WSL distro $distro if it exists..."
        Write-Host "wsl.exe --unregister $distro"
        wsl.exe --unregister $distro
        Write-Host "DONE"
    }
    else {
        return $false 
    }
    $image_save_path="$save_location/$distro.tar"
    Write-Host "`r`nimporting $distro.tar to $install_location as $distro..."
    Write-Host "wsl.exe --import $distro $install_location $image_save_path --version $wsl_version"
    wsl.exe --import $distro $install_location $image_save_path --version $wsl_version
    Write-Host "DONE"

    if ($install -eq "yes-install") {
        $setdefault = ""
    }
    else {
        Write-Host "`r`n"
        Write-Host "press ENTER to set $distro as default WSL distro"
        Write-Host " ..or enter any character to skip"
        $setdefault = Read-Host -Prompt " $ "

    }
    if ($setdefault -eq "") {
        Write-Host "`r`n"
        Write-Host "setting default WSL distro as $distro..."
        Write-Host  "wsl.exe --set-default $distro "
        wsl.exe --set-default $distro 
        Write-Host "DONE!"
        Write-Host "`r`n"
        Write-Host " ..if starting WSL results in an error, try converting the distro version to WSL1 by running:"
        Write-Host "wsl.exe --set-version $distro 1"
        Write-Host "`r`n"
    }
    return $True
}

function wsl_or_exit {
    param($distro)
    Write-Host "Windows Subsystem for Linux Distributions:"
    wsl.exe -l -v
    Write-Host "`r`n"
    wsl.exe --status
    Write-Host "`r`n"
    Write-Host "press ENTER to open $distro in WSL"
    Write-Host " ..or enter any character to exit "
    $prompt_in = Read-Host " $ "
    if ($prompt_in -eq "") {
        Write-Host "`r`n"
        Write-Host "launching WSL with $distro distro..."
        Write-Host "wsl.exe -d $distro"
        Write-Host "`r`n"
        wsl.exe -d $distro
            
        Write-Host "if WSL fails to start try converting the distro version to WSL1:"
        Write-Host "wsl.exe --set-version $distro 1"
    }

    Write-Host "`r`n"
    Write-Host "goodbye"
    Write-Host "`r`n"
}


$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "White"

main