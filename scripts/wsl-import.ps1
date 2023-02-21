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
    $mount_drive_letter="c"
    $unix_mount_drive = "/mnt/$mount_drive_letter"
    $windows_mount_drive = "${mount_drive_letter}:/"
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
    # write-output "save location: $save_location"
    $install_location = "$save_location/$install_directory"
    # write-output "install location: $install_location"

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
        Write-Output `r`n
        $image_repo_prompt = Read-Host -Prompt "image repository ($image_repo_mask) $ "
        if ($image_repo_prompt -ne "") {
            $image_repo = $image_repo_prompt
            $image_repo_mask = $image_repo_prompt
        }
        else {
            $image_repo=$image_repo_mask
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
        if ($save_directory_prompt -ne ""){
            $save_directory=$save_directory_prompt
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

    $docker_image_id_path = "$install_location/.image_id"
    $docker_container_id_path = "$install_location/.container_id"

    Write-Output "$save_location`r`n"
    build_dir_structure $install_location $save_location
    docker_image_pull $image_repo_image_name
    docker_container_start $config $image_repo_image_name $docker_image_id_path $docker_container_id_path
    import_docker_tar $distro $install_location $image_save_path $wsl_version
    wsl_or_exit $distro
    
}

function greeting_prompt {
    param ($image_repo_mask,$image_name,$image_save_path,$distro) 

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
      .............      $distro           
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

function build_dir_structure {
    param( $install_location, $save_location)
    # @REM directory structure: 
    # @REM %mount_drive%:\%install_directory%\%save_directory%
    # @REM ie: C:\wsl-distros\docker
    $null = New-Item -Path $save_location -ItemType Directory 
    $null = New-Item -Path $install_location -ItemType Directory 

}
   
function docker_image_pull {

    param($image_repo_image_name)

    Write-Output "========================================================================"
    Write-Output "`r`r`n"
    Write-Output "pulling image ($image_repo_image_name)..."
    Write-Output "docker pull --platform linux $image_repo_image_name"
    # @REM pull the image
    docker pull --platform linux $image_repo_image_name
    Write-Output "`r`n"
}
function docker_container_start {
    param(
        [string]$config, 
        [string]$image_repo_image_name, 
        [string]$docker_image_id_path, 
        [string]$docker_container_id_path
    )
    Write-Output "initializing the image container..."
    # @REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
    Write-Output "docker images -aq $image_repo_image_name"
    $WSL_DOCKER_IMG_ID = docker images -aq $image_repo_image_name
    # @REM @TODO: handle WSL_DOCKER_IMG_ID case of multiple ids returned from docker images query
    Write-Output $WSL_DOCKER_IMG_ID | Out-File -FilePath $docker_image_id_path
    # $null = Remove-Item $docker_container_id_path

    
    Write-Output "`r`n "
    Write-Output "========================================================================"
    Write-Output "`r`n"
    Write-Output "testing container..."
    Write-Output "`r`n"
    Write-Output "this container is running as a local copy of the image $image_repo_image_name"
    Write-Output "`r`n"

       
    Write-Output "docker run -itd --cidfile $docker_container_id_path $WSL_DOCKER_IMG_ID --sig-proxy=false"
    docker run -itd --cidfile $docker_container_id_path $WSL_DOCKER_IMG_ID --sig-proxy=false
    
    # get first line of docker_container_id_path
    $WSL_DOCKER_CONTAINER_ID = Get-Content -Path $docker_container_id_path -Raw
    if ($config -eq "config") {
        
        Write-Output "docker attach $WSL_DOCKER_CONTAINER_ID"
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Red"     
        Write-Output "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Output "!!!!!! IMPORTANT: type 'exit' then ENTER to exit container preview !!!!!!"
        Write-Output "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Output "`r`n"
        Write-Output "`r`n"
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "Cyan"    
        docker attach $WSL_DOCKER_CONTAINER_ID
        $host.UI.RawUI.BackgroundColor = "Black"
        $host.UI.RawUI.ForegroundColor = "White"

    }

    Write-Output "`r`n"
    Write-Output "closing test container..."
    Write-Output "`r`n"
    Write-Output "========================================================================"



    Write-Output "exporting image ($WSL_DOCKER_IMG_ID) as container ($WSL_DOCKER_CONTAINER_ID)..."
    Write-Output "docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path"
    docker export $WSL_DOCKER_CONTAINER_ID > $image_save_path
    Write-Output "DONE"
}

# @REM EASTER EGG1: typing yes at first prompt bypasses cofirm and restart the default distro
# @REM EASTER EGG2: typing yes at second prompt (instead of 'y' ) makes distro default
function install_prompt {
    Write-Output "---------------------------------------------------------------------"
    Write-Output "Windows Subsystem for Linux Distributions:"
    wsl.exe -l -v
    Write-Output "---------------------------------------------------------------------"
    Write-Output "Check the list of current WSL distros installed on your system above. "
    Write-Output "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Output "!!!!!!!!!!!!                   WARNING:                !!!!!!!!!!!!!!"
    Write-Output "If $distro is already listed above it will be REPLACED.  "
    Write-Output "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    Write-Output "_____________________________________________________________________"
    Write-Output "`r`n"
    Write-Output "Would you still like to continue ([y]es/[n]o/[redo])?"
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
    param(
        [string]$distro,
        [string]$install_location,
        [string]$image_save_path,
        [string]$wsl_version
    )
    $setdefault = "no"

    Write-Output "`r`n"
    Write-Output "killing the $distro WSL process if it is running..."
    Write-Output "wsl.exe --terminate $distro"
    wsl.exe --terminate $distro
    Write-Output "DONE"
    # @REM Write-Output `r`n
    # @REM Write-Output killing all WSL processes...
    # @REM wsl.exe --shutdown
    # @REM Write-Output DONE
    $install = install_prompt

    if ($install -eq "yes-install" -Or $install -eq "default-install") {
        Write-Output "`r`n"
        Write-Output "deleting WSL distro $distro if it exists..."
        Write-Output "wsl.exe --unregister $distro"
        wsl.exe --unregister $distro
        Write-Output "DONE"
    }
    else {
        return 0 
    }

    Write-Output "`r`n"
    Write-Output "importing $distro.tar to $install_location as $distro..."
    Write-Output "wsl.exe --import $distro $install_location $image_save_path --version $wsl_version"
    wsl.exe --import $distro $install_location $image_save_path --version $wsl_version
    Write-Output "DONE"

    if ($install -eq "yes-install") {
        $setdefault = ""
    }
    else {
        Write-Output "`r`n"
        Write-Output "press ENTER to set $distro as default WSL distro"
        Write-Output " ..or enter any character to skip"
        $setdefault = Read-Host -Prompt " $ "

    }
    if ($setdefault -eq "") {
        Write-Output "`r`n"
        Write-Output "setting default WSL distro as $distro..."
        Write-Output  "wsl.exe --set-default $distro "
        wsl.exe --set-default $distro 
        Write-Output "DONE!"
        Write-Output "`r`n"
        Write-Output " ..if starting WSL results in an error, try converting the distro version to WSL1 by running:"
        Write-Output "wsl.exe --set-version $distro 1"
        Write-Output "`r`n"
    }
}

function wsl_or_exit {
    param($distro)
    Write-Output "Windows Subsystem for Linux Distributions:"
    wsl.exe -l -v
    Write-Output "`r`n"
    wsl.exe --status
    Write-Output "`r`n"
    Write-Output "press ENTER to open $distro in WSL"
    Write-Output " ..or enter any character to skip "
    $prompt_in = Read-Host " $ "
    if ($prompt_in -eq "") {
        Write-Output "`r`n"
        Write-Output "launching WSL with $distro distro..."
        Write-Output "wsl.exe -d $distro"
        Write-Output "`r`n"
        wsl.exe -d $distro
            
        Write-Output "if WSL fails to start try converting the distro version to WSL1:"
        Write-Output "wsl.exe --set-version $distro 1"
    }

    Write-Output "`r`n"
    Write-Output "goodbye"
    Write-Output "`r`n"
}


$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor="White"

main