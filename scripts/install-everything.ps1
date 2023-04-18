$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}

function reboot_prompt {
    # Write-Host "`r`nA restart may be required for the changes to fully take effect. "
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n`t ..or hit ENTER to skip" 

    if ($confirmation -ieq 'reboot now') {
        InlineScript { Write-Host "`r`nRestarting computer ... r`n" }
        Restart-Computer
    }
    else {
        # powershell.exe -Command "$git_path\choco\src\chocolatey.resources\redirects\RefreshEnv.cmd"
        Write-Host "`r`n"
    }
}

function install_windows_features {
    param ( $git_path )
    $new_install = $false
    $winconfig = "$git_path/dvl-adv/add-windows-features.ps1"
    &$winconfig = Invoke-Expression -command "$git_path/dvl-adv/add-windows-features.ps1"
    return $new_install
}

function install_dependencies {
    param ( $git_path )
    Write-Host "`r`nThe following programs will be installed or updated`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Windows Terminal`r`n`t- Python 3.10`r`n`t" -ForegroundColor Magenta
    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..."
        # Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
        winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
        winget upgrade Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.vscode-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed" 
    }

    $software_name = "Docker Desktop"
    if (!(Test-Path -Path "$git_path/.docker-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..." 
        winget install --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity
        winget upgrade --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity
        # "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.docker-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed"   
    }

    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        Write-Host "Installing $software_name ..." 
        winget install Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity
        winget upgrade Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity
        # }
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.wterminal-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed"  
    }


    $software_name = "Python"
    if (!(Test-Path -Path "$git_path/.python-installed" -PathType Leaf)) {
        $new_install = $true
        # @TODO: add cdir and python to install with same behavior as other installs above
        # not eloquent at all but good for now
        winget install --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity
        winget upgrade --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements --disable-interactivity

        # ... even tho cdir does not appear to be working on windows
        # $cmd_command = pip install cdir
        # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
    
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.python-installed"
    }
    else {
        Write-Host "$software_name already installed" 
    }

    return $new_install
    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl -y
    
}


function require_docker_online {

    $docker_tries = 0
    $docker_online = $false
   
    Write-Host "`r`n`r`nWaiting for Docker to come online ..."  
    $sleep_time = 30
    try {
        Start-Process "Docker Desktop.exe" -WindowStyle "Hidden"
    }
    catch {
        try {
            Start-Process "c:\docker\Docker Desktop.exe" -WindowStyle "Hidden"
        }
        catch {
            try {
                Start-Process "c:\docker\Docker\Docker Desktop.exe" -WindowStyle "Hidden"
            }
            catch {
                try {
                    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Hidden"
                }
                catch {} 
            }
        }
    }
    do {    
        
          
        try {
            # launch docker desktop and keep it open 
            $docker_tries++
            if (Get-Process 'com.docker.proxy'  | Out-Null ) {
                $docker_online = $true
                # if service was already up continue right away otherwise sleep a bit
                if ( $docker_tries -gt 1 ) {
                    Start-Sleep $sleep_time
                }
                Write-Host "Docker Desktop is now online"
            }
        
            if ($docker_online -eq $false -And (($docker_tries % 2) -eq 0)) {
                docker info
                write-host "`r`n"
                $sleep_time += 15
                Start-Sleep $sleep_time
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 3) -eq 0)) {
                # start count over
                # $docker_attempt1 = $docker_attempt2 = $false
                # prompt to continue
                docker info
                $check_again = Read-Host "Keep trying to connect to Docker? ([y]n)"
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 5) -eq 0)) {
                docker info
                docker update --restart=always docker-desktop
                docker update --restart=always docker-desktop-data
                Write-Host "Waited $docker_tries seconds .. "
                Write-Host "Restarting Docker Engine..."
                Write-Host "Switching Docker Engine ...."
                ./DockerCli.exe -SwitchDaemon
                Start-Sleep 5
                Write-Host "Setting Docker Engine to Linux ....."
                ./DockerCli.exe -SwitchLinuxEngine
                Write-Host "Switch complete."
                Write-Host "Retrying connection in 10 seconds ......"
                Start-Sleep -seconds 10
            }
        }
        catch {}
        # } while (-Not $docker_online )
    } while (-Not $docker_online -And $check_again -ine 'n')

    return $docker_online
}

function cleanup_installation {
    param (
        # OptionalParameters
    )
    
    try {
        Remove-Item "$git_path".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force -ErrorAction SilentlyContinue
        Write-Host "`r`nCleaning up..  `r`n"
        # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
        if ($git_path.Contains($repo_src_name) -And $git_path.NotContains("System32") ) {
            Remove-Item $git_path -Recurse -Confirm -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Run the following command to delete the setup files:`r`nRemove-Item $git_path -Recurse -Confirm -Force`r`n"
    }
}


function start_installer_daemon {

    $repo_src_owner = 'kindtek'
    $repo_git_name = 'dvlw'
    $git_path = "$HOME\repos\$repo_src_owner\$repo_git_name"

    # jump to bottom line without clearing scrollback
    # Write-Host "$([char]27)[2J" 
    $new_install = install_windows_features $git_path 
    if ($new_install -eq $true) {
        Write-Host "`r`nWindows features installations complete! Restart may be needed to continue. `r`n`r`n" 
        reboot_prompt
    }

    # Write-Host "$([char]27)[2J" 
    wsl --install --no-launch
    wsl --update

    # Write-Host "$([char]27)[2J" 
    $new_install = install_dependencies $git_path
    if ($new_install -eq $true) {
        Write-Host "`r`nSoftware installations complete! Restart may be needed to begin WSL import phase. `r`n`r`n" 
        reboot_prompt
    }

    
    # Write-Host "$([char]27)[2J" 
    if (!(require_docker_online)) {
        Write-Host "`r`nCannot start Docker.`r`n" 
    }
}

start_installer_daemon
