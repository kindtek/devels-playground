$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
$env:WSL_UTF8 = 1
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
        Write-Host "`r`nRestarting computer ... r`n"
        Restart-Computer
    }
    # else {
    #     # powershell.exe -Command "$git_path\choco\src\chocolatey.resources\redirects\RefreshEnv.cmd"
    #     Write-Host "`r`n"
    # }
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
    Write-Host "`r`nThe following programs will be installed or updated`r`n`t- Windows Terminal`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Python 3.10`r`n`t" -ForegroundColor Magenta
    
    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        Write-Host "Installing $software_name ..." 
        winget install Microsoft.PowerShell
        winget install Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # }
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.wterminal-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed"  
    }    

    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..."
        # Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --silent --locale en-US --accept-package-agreements --accept-source-agreements --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
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
        # winget uninstall --id=Docker.DockerDesktop
        # winget install --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # winget upgrade --id=Docker.DockerDesktop --location="c:\docker" --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget install --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # update using rolling stable url
        Write-Host "Downloading $software_name update installation file ..." 
        Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile DockerDesktopInstaller.exe
        .\DockerDesktopInstaller.exe
        # & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
        # "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=c:\docker 
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.docker-installed"
        Remove-Item "DockerDesktopInstaller.exe" -Force -ErrorAction SilentlyContinue
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
        winget install --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --id=Python.Python.3.10  --silent --locale en-US --accept-package-agreements --accept-source-agreements

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

function ini_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") | ConvertFrom-JSON 
    # $config_json = ConvertFrom-JSON (Get-Content "$config_file")
    $config_json.disableTips = $true
    $config_json.disableUpdate = $false
    $config_json.autoDownloadUpdates = $true
    $config_json.displayedTutorial = $true
    $config_json.enableIntegrationWithDefaultWslDistro = $true
    # $config_json.kubernetesEnabled = $true
    $config_json.autoStart = $true
    $config_json.useWindowsContainers = $false
    $config_json.wslEngineEnabled = $true
    $config_json.openUIOnStartupDisabled = $true
    $config_json.skipUpdateToWSLPrompt = $true
    $config_json.skipWSLMountPerfWarning = $true
    $config_json.activeOrganizationName = "kindtek"
    if ("$new_integrated_distro" -ne "") {
        $jcurrent = $config_json.integratedWslDistros
        $new_distro = @"
[
    {
        "integratedWslDistros":"kalilinux-kali-rolling-latest"
    }
]
"@
        $jnew = ConvertFrom-Json -InputObject $new_distro
        $config_json.integratedWslDistros = $jcurrent + $jnew
    }
    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file
}

function set_docker_config {
    param ( $new_integrated_distro )
    $config_file = "$env:APPDATA\Docker\settings.json"
    $config_json = (Get-Content -Raw "$config_file") | ConvertFrom-JSON
    # $config_json = ConvertFrom-JSON (Get-Content "$config_file")
    $config_json.enableIntegrationWithDefaultWslDistro = $true
    # $config_json.kubernetesEnabled = $true
    $config_json.autoStart = $true
    $config_json.useWindowsContainers = $false
    $config_json.wslEngineEnabled = $true
    $config_json.openUIOnStartupDisabled = $true
    $config_json.skipUpdateToWSLPrompt = $true
    $config_json.skipWSLMountPerfWarning = $true
    $config_json.activeOrganizationName = "kindtek"
    if ("$new_integrated_distro" -ne "") {
        $jcurrent = $config_json.integratedWslDistros
        $new_distro = @"
[
    {
        "integratedWslDistros":"$new_integrated_distro"
    }
]
"@
        $jnew = ConvertFrom-Json -InputObject $new_distro
        $config_json.integratedWslDistros = $jcurrent + $jnew
    }

    ConvertTo-JSON $config_json -Depth 2 -Compress | Out-File $config_file -Encoding utf8 -Force
    (Get-Content $config_file) | Set-Content -Encoding utf8 $config_file


}

function require_docker_online {
    $docker_tries = 0
    $docker_restarts = 0
    $docker_online = $false
    $refresh_envs = "$env:USERPROFILE/repos/kindtek/RefreshEnv.cmd"
    $host.UI.RawUI.ForegroundColor = "Black"
    $host.UI.RawUI.BackgroundColor = "DarkRed"
    Write-Host "`r`n`r`nloading docker desktop ..."
    Write-Host "waiting for docker backend to come online ..."  
    try {
        Start-Process "Docker Desktop.exe" -WindowStyle "Hidden"
    }
    catch {
        try {
            ([void]( New-Item -path alias:'docker' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'C:\Program Files\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
            powershell.exe -Command $refresh_envs | Out-Null
            Start-Process "C:\Program Files\docker\docker\Docker Desktop.exe" -WindowStyle "Hidden"
        }
        catch {
            try {
                ([void]( New-Item -path alias:'docker' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker\Docker Desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                powershell.exe -Command $refresh_envs | Out-Null
                Start-Process "c:\docker\docker\Docker Desktop.exe" -WindowStyle "Hidden"
            }
            catch {
                try {
                    ([void]( New-Item -path alias:'docker' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop' -Value ':\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    ([void]( New-Item -path alias:'Docker Desktop.exe' -Value 'c:\docker\docker desktop.exe' -ErrorAction SilentlyContinue | Out-Null ))
                    powershell.exe -Command $refresh_envs | Out-Null
                    Start-Process "c:\docker\docker desktop.exe" -WindowStyle "Hidden"
                }
                catch {} 
            }
        }
    }
    :nested_do do {    
        try {
            # launch docker desktop and keep it open 
            $docker_tries++
            Write-Host "${docker_restarts}.${docker_tries}"
            if ( Get-Process 'com.docker.proxy' ) {
                $docker_online = $true
                # if service was already up continue right away otherwise sleep a bit
                if ( $docker_tries -gt 1 ) {
                    $sleep_time += 1
                    Start-Sleep -s $sleep_time
                    Write-Host ""
                }
                Write-Host "docker backend is now online"
                docker info
                break nested_do
            }
            if ( $docker_tries -eq 1 ) {
                Write-Host "error messages are expected when first starting docker. please wait ..."
            }
            if ($docker_online -eq $false -And (($docker_tries % 2) -eq 0)) {
                write-host ""
                $sleep_time += 2
                Start-Sleep -s $sleep_time
                Write-Host ""
            }
            elseif (($docker_tries % 3) -eq 0) {
                # start count over
                # $docker_attempt1 = $docker_attempt2 = $false
                # automatically restart docker on try 3 then prompt for restart after that
                if ( $docker_tries -gt 9 ) {
                    # $restart = Read-Host "Restart docker? ([y]n)"
                    $restart = 'y'
                }
                else {
                    $restart = 'n'
                }
                if ( $restart -ine 'n' -And $restart -ine 'no' -And (($docker_tries % 9) -eq 0)) {
                    Write-Output "stopping docker ..."
                    powershell.exe -Command cmd.exe /c net stop com.docker.service
                    powershell.exe -Command cmd.exe /c taskkill /IM "'Docker Desktop.exe'" /F
                    Write-Output "stopping wsl ..."
                    powershell.exe -Command wsl.exe --shutdown; 
                    Write-Output "starting wsl ..."
                    powershell.exe -Command wsl.exe --exec echo 'wsl restarted';
                    Write-Output "starting docker ..."
                    powershell.exe -Command cmd.exe /c net start com.docker.service
                    powershell.exe -Command wsl.exe --exec echo 'docker restarted';
                    $docker_tries = 1
                    $docker_restarts++
                }
                elseif ( ($docker_tries % 6) -eq 0) {
                    # $check_again = Read-Host "Keep trying to connect to docker? ([y]n)"
                    $check_again = 'y'
                    if ($check_again -ine 'n' -And $check_again -ine 'no') {
                        Write-Host "resetting docker engine ....."
                        &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine; Start-Sleep 5; &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine;
                        Write-Host "reset complete"
                        Write-Host "trying again to start docker desktop ..."
                    }
                }
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 13) -eq 0)) {
                docker info
                Write-Host "resetting Docker engine and data ..."
                docker update --restart=always docker-desktop
                docker update --restart=always docker-desktop-data
                &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchWindowsEngine; Start-Sleep 5; &$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchLinuxEngine;
                Write-Output "restarting docker ..."
                cmd.exe /c net stop docker
                cmd.exe /c net stop com.docker.service
                cmd.exe /c taskkill /IM "dockerd.exe" /F
                cmd.exe /c taskkill /IM "Docker Desktop.exe" /F
                cmd.exe /c net start docker
                cmd.exe /c net start com.docker.service
                $docker_tries = 1
                $docker_restarts++
            }
            if ($docker_online -eq $false -And ( $docker_tries -eq 1)) {
                # try extraordinary measures
                # $check_again = Read-Host "Try resetting default distro and restarting Docker? ([y]n)"
                Write-Host ""
                try {
                    Start-Process "com.docker.proxy" -WindowStyle "Hidden"
                } 
                catch {
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
                }
            }
            elseif ($docker_online -eq $false -And ($docker_restarts -eq 2 ) -And ($docker_tries -eq 10 )) {
                # clear settings 
                Rename-item -Path "$env:APPDATA\Docker\settings.json" "settings.json.old" -Force
            }
            elseif ($docker_online -eq $false -And ($docker_restarts -eq 4 )) {
                # give up
                $check_again = 'n'
            }
            Write-Host ""
            Start-Sleep 1
            Write-Host ""
        }
        catch {
            $docker_online = $false
        }
    } while ( -Not $docker_online -And ( $check_again -ine 'n' -And $check_again -ine 'no') )
    if ( -Not $docker_online -And ( $check_again -ine 'n' -Or $check_again -ine 'no') ) {
        Write-Host "docker failed to start. if restarting WSL and your computer does not help you may need to use a different WSL default distro"
    }
    $docker_daemon_online = docker search scratch --limit 1 --format helloworld
    if ($docker_daemon_online -ne 'helloworld') {
        $docker_online = $false
    }
    return $docker_online
}

function cleanup_installation {
    param (
        # OptionalParameters
    )
    
    try {
        Remove-Item "$git_path".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force -ErrorAction SilentlyContinue
        Write-Host "`r`nCleaning up..  `r`n"
        Remove-Item "$git_path".replace($repo_src_name, "DockerDesktopInstaller.exe") -Force -ErrorAction SilentlyContinue
        # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
        if ($git_path.Contains($repo_src_name) -And $git_path.NotContains("System32") ) {
            Remove-Item $git_path -Recurse -Confirm -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "Run the following command to delete the repo and setup files:`r`nRemove-Item $git_path -Recurse -Confirm -Force`r`n"
    }
}

function get_default_wsl_distro {
    $default_wsl_distro = wsl --list | Where-Object { $_ -and $_ -ne '' -and $_ -match '(.*)\(' }
    $default_wsl_distro = $default_wsl_distro -replace '^(.*)\s.*$', '$1'
    return $default_wsl_distro
}

function run_installer {

    $repo_src_owner = 'kindtek'
    $repo_git_name = 'dvlw'
    $git_path = "$env:USERPROFILE\repos\$repo_src_owner\$repo_git_name"
    # log default distro
    $global:ORIG_DEFAULT_WSL_DISTRO = get_default_wsl_distro
    # jump to bottom line without clearing scrollback
    # Write-Host "$([char]27)[2J" 
    $new_install = install_windows_features $git_path 
    if ($new_install -eq $true) {
        Write-Host "`r`nwindows features installations complete! restart may be needed to continue. `r`n`r`n" 
        reboot_prompt
    }

    $new_install = install_dependencies $git_path
    if ($new_install -eq $true) {
        Write-Host "`r`nsoftware installations complete! restart(s) may be needed to begin WSL import phase. `r`n`r`n" 
        reboot_prompt
    }


    # Write-Host "$([char]27)[2J" 
    if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
        if (!(require_docker_online)) {
            Write-Host "`r`nnot starting docker desktop.`r`n" 
        }
        else {
            ini_docker_config
        }
    }
}
