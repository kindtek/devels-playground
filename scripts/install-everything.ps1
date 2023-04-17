$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
$temp_repo_scripts_path = $PSScriptRoot

# source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
        Exit
    }
}
# source of the above self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.


function reboot_prompt {
    Write-Host "`r`nA restart is required for the changes to fully take effect. "
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip" 

    if ($confirmation -ieq 'reboot now') {
        InlineScript { Write-Host "`r`nRestarting computer ... r`n" }
        # Restart-Computer -Wait
    }
    else {
        Write-Host "`r`n"
    }
}

function install_windows_features {
    param ( $temp_repo_scripts_path )
    $new_install = $false
    $winconfig = "$temp_repo_scripts_path/dvl-adv/add-windows-features.ps1"
    &$winconfig = Invoke-Expression -command "$temp_repo_scripts_path/dvl-adv/add-windows-features.ps1"
    return $new_install
}

function install_dependencies {
    param ($temp_repo_scripts_path, $git_path)

    $new_install = $false
    Write-Host "`r`nThese programs will be installed or updated:" 
    Write-Host "`r`n`t- WinGet`r`n`t- Github CLI`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Windows Terminal`r`n`t- Python 3.10`r`n" 

    $software_name = "WinGet"
    if (!(Test-Path -Path "$git_path/.winget-installed" -PathType Leaf)) {
        Push-Location $temp_repo_scripts_path
        # install winget and use winget to install everything else
        $winget = "dvl-adv/get-latest-winget.ps1"
        Write-Host "Installing $software_name ...`r`n" 
        # $p = Get-Process -Name "PackageManagement"
        # Stop-Process -InputObject $p
        # Get-Process | Where-Object { $_.HasExited }
        &$winget = Invoke-Expression -command "dvl-adv/get-latest-winget.ps1" 
        Write-Host "$software_name installed`r`n`r`n" | Out-File -FilePath "$git_path/.winget-installed"
        Pop-Location
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed`r`n"   
    }

    $software_name = "Github CLI"
    if (!(Test-Path -Path "$git_path/.github-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ...`r`n"
        winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements
        Write-Host "$software_name installed`r`n`r`n" | Out-File -FilePath "$git_path/.github-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed`r`n" 
    }

    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ...`r`n"
        # Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --silent --locale en-US --accept-package-agreements --accept-source-agreements --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
        winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
        winget upgrade Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
        Write-Host "`$software_name installed`r`n`r`n" | Out-File -FilePath "$git_path/.vscode-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed`r`n" 
    }

    $software_name = "Docker Desktop"
    if (!(Test-Path -Path "$git_path/.docker-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ...`r`n" 
        winget install --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --id=Docker.DockerDesktop --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # "Docker Desktop Installer.exe" install --accept-license --backend=wsl-2 --installation-dir=C:\Docker 
        Write-Host "`$software_name installed`r`n`r`n" | Out-File -FilePath "$git_path/.docker-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed`r`n"   
    }

    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        Write-Host "Installing $software_name ...`r`n" 
        winget install Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade Microsoft.WindowsTerminal --silent --locale en-US --accept-package-agreements --accept-source-agreements
        # }
        Write-Host "`$software_name installed`r`n`r`n" | Out-File -FilePath "$git_path/.wterminal-installed"
        $new_install = $true
    }
    else {
        Write-Host "$software_name already installed`r`n"  
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
    
        Write-Host "$software_name installed`r`n" | Out-File -FilePath "$git_path/.python-installed"
    }
    else {
        Write-Host "$software_name already installed`r`n" 
    }

    return $new_install
    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl -y
    
}

function test_repo_path {
    param (
        $parent_path, $git_path, $repo_src_owner, $repo_src_name
    )
    try {
        # refresh environment variables
        # cmd /c start powershell.exe "$git_path/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
        if (Test-Path -Path "$parent_path/$repo_src_name") {
            Push-Location "$parent_path/$repo_src_name"
            # if git status works and finds devels-workshop repo, assume the install has been successfull and this script was ran once before
            $git_status = git remote show origin 
            # determine if git status works by checking output for LICENSE - see typical output of git status here: https://amitd.co/code/shell/git-status-porcelain
            if ($git_status.NotContains("github.com/$repo_src_owner/$repo_src_name")) {
                Write-Debug "Not a git repository"
            }
            Pop-Location
        }
        else {
            Write-Debug "No git directory found"
        }
    }
    catch {
        Write-Debug "Git command not found"
        powershell.exe "$git_path/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle "Hidden"
        
        return $false
    }

    return $true
}

function install_repo {
    param (
        $parent_path, $git_path, $repo_src_owner, $repo_src_name, $repo_src_branch 
    )
    # try {
    Write-Host "Now installing:`r`n`t- GitHub repos`r`n`t- Chocolatey`r`n" 

    # refresh environment variables using script in choco temp download location
    powershell.exe "$git_path/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle "Hidden"
    # Write-Host "parent path: $parent_path"
    Set-Location $parent_path
    $new_install = $false
    # .. and then clone/update the repo
    # Write-Host "Testing path $parent_path/$repo_src_name ..."
    if (!(Test-Path -Path $repo_src_name)) {
        Write-Host "Testing path $parent_path/$repo_src_name ..."
        # {
        git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch #} *>$null
        Push-Location $repo_src_name
        # { 
        git submodule update --force --recursive --init --remote 
        # } *>$null
        Pop-Location
    }

    Set-Location $repo_src_name
    # { 
    git pull
    #  }  *>$null
    # { 
    git submodule update --force --recursive --init --remote
    #  }  *>$null

    
    # @TODO: since this gave so many errors, use git to install from source - the current way does like it may be better to stay up to date (rather than using a fork or origin choco repo)
    $software_name = "Chocolatey"
    if (!(Test-Path -Path "$git_path/.choco-installed" -PathType Leaf)) {
        $new_install = $true
        # getting error-0x80010135 path too long error when unzipping.. unzip operation at the shortest path
        # Push-Location $temp_repo_scripts_path
        # Push-Location scripts

        Push-Location choco
        # $choco = "dvl-adv/get-latest-choco.ps1"
        # Write-Host "`n`r`n`rInstalling $software_name ..." 
        # $env:path += ";C:\ProgramData\chocoportable"
        # &$choco = Invoke-Expression -command "dvl-adv/get-latest-choco.ps1" 
        # $choco = "cmd.exe /c choco/build.bat"
        Write-Host "`n`r`n`rInstalling $software_name ..." 
        $env:path += ";C:\ProgramData\chocoportable"
        $choco = "build.bat"
        Write-Host "Executing $choco ..."
        $choco = "$parent_path/$repo_src_name/choco/build.bat"
        Write-Host "&$choco"
        # Push-Location ../../..
        &$choco = "$parent_path/$repo_src_name/choco/build.bat"
        # Pop-Location
        $refresh_env = "src/chocolatey.resources/redirects/RefreshEnv.cmd"
        &$refresh_env = "src/chocolatey.resources/redirects/RefreshEnv.cmd"
        # cmd /c start powershell.exe "$git_path/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
        Pop-Location
        # Pop-Location
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.choco-installed"

        # Push-Location cdir
        # Push-Location bin
    }
    else {
        Write-Host "$software_name already installed`r`n"  
    }
        
        

    $refresh_env = "choco/src/chocolatey.resources/redirects/RefreshEnv.cmd"
    &$refresh_env = "chocosrc/chocolatey.resources/redirects/RefreshEnv.cmd"
    

    return $new_install
    # if git is not recognized try to limp along with the manually downloaded files
    # }
    # catch {}
}


# refresh env again
# cmd /c start powershell.exe "$git_path/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden

# $user_input = (Read-Host "`r`nopen Docker Dev environment? [y]/n")
# if ( $user_input -ine "n" ) {
#     Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/devels-workshop@main" -WindowStyle "Hidden"
# } 

function require_docker_online {

    $docker_tries = 0
    $docker_online = $false
   
    Write-Host "`r`n`r`nWaiting for Docker to come online ..."  

    do {       
        try {
            # launch docker desktop and keep it open 
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Hidden"
            $docker_tries++
            Start-Sleep -seconds 1
            # { 
            if (Get-Process 'com.docker.proxy') {
                $docker_online = $true
                Write-Host "Docker Desktop is now online"
            }
            # }
            # *>$null
        
            if ($docker_online -eq $false -And (($docker_tries % 80) -eq 0)) {
                write-host "$docker_status_now`r`n"
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 30) -eq 0)) {
                # start count over
                # $docker_attempt1 = $docker_attempt2 = $false
                # prompt to continue
                write-host "$docker_status_now`r`n"
                # $check_again = Read-Host "Keep trying to connect to Docker? ([y]n)"
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 20) -eq 0)) {
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
    } while (-Not $docker_online )
    # } while (-Not $docker_online -Or $check_again -ine 'n')

    return $docker_online
}

function run_devels_playground {
    param (
        $git_path
    )
    try {
        $software_name = "Devel`'s Playground"
        if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
            # @TODO: add cdir and python to install with same behavior as other installs above
            # not eloquent at all but good for now

            # ... even tho cdir does not appear to be working on windows
            # $cmd_command = pip install cdir
            # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
    
            # @TODO: maybe start in new window
            # $start_devs_playground = Read-Host "`r`nStart Devel's Playground ([y]/n)"
            # if ($start_devs_playground -ine 'n' -And $start_devs_playground -ine 'no') { 
            Write-Host "`r`nNOTE:`tDocker Desktop is required to be running for the Devel's Playground to work.`r`n`r`n`tDo NOT quit Docker Desktop until you are done running it.`r`n" 
            Write-Host "`r`n`r`nAttempting to start wsl import tool ..."
            # // commenting out background building process because this is NOT quite ready.
            # // would like to run in separate window and then use these new images in devel's playground 
            # // if they are more up to date than the hub - which could be a difficult process
            # $cmd_command = "$git_path/devels_playground/docker-images-build-in-background.ps1"
            # &$cmd_command = cmd /c start powershell.exe -Command "$git_path/devels_playground/docker-images-build-in-background.ps1" -WindowStyle "Maximized"
               
            $devs_playground = "$git_path/dvpg/scripts/wsl-docker-import.cmd $args"
            Write-Host "Launching Devel's Playground`r`n$devs_playground ...`r`n" 
            Write-Host "&$devs_playground"
            # Write-Host "$([char]27)[2J"
            &$devs_playground = "$git_path/dvpg/scripts/wsl-docker-import.cmd $args"
            Write-Host "$software_name installed`r`n" | Out-File -FilePath "$git_path/.dvlp-installed"
        }
    }
    catch {}
}
    
# }

# }

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


workflow start_installer_daemon {
    param ([string]$temp_repo_scripts_path)

    $repo_src_owner = 'kindtek'
    $repo_src_name = 'devels-workshop'
    $repo_src_branch = 'main'
    $git_path = $temp_repo_scripts_path.Replace("\scripts", "")
    $git_path = $git_path.Replace("/scripts", "")
    $parent_path = $git_path.Replace("\$repo_src_name-temp", "")
    $parent_path = $parent_path.Replace("/$repo_src_name-temp", "")
    # Write-Host "parent path: $parent_path"
    # Write-Host "git dir: $git_path"
    # Write-Host "scripts dir: $temp_repo_scripts_path"

    # try {
    test_repo_path $parent_path $git_path $repo_src_owner $repo_src_name
    # jump to bottom line without clearing scrollback
    InlineScript { Write-Host "$([char]27)[2J" }
    # @TODO: fix $new_install variable - doesn't work for windows features in  
    $new_install = install_windows_features $temp_repo_scripts_path 
    if ($new_install -eq $true) {
        InlineScript { Write-Host "`r`nWindows features installed. Restarting computer in five seconds ... `r`n" }
        Start-Sleep 5
        Restart-Computer -Wait
    }
    
    $new_install = install_dependencies $temp_repo_scripts_path $git_path
    if ($new_install -eq $true) {
        InlineScript { Write-Host "`r`nRestart needed. Restarting computer in five seconds ... `r`n" }
        Start-Sleep 5
        Restart-Computer -Wait
    }

    install_repo $parent_path $git_path $repo_src_owner $repo_src_name $repo_src_branch
    InlineScript { Write-Host "$([char]27)[2J" }
    InlineScript { Write-Host "`r`nSetup complete!`r`n" }

    
    if (require_docker_online) {
        run_devels_playground $git_path
    }
    else {
        InlineScript { Write-Host "Failed to launch docker. Not able to start Devel's Playground. Please restart and run the script again:" }
        InlineScript { Write-Host "cmd `"$git_path/kindtek/devels-workshop/dvpg/scripts/wsl-docker-import`"" }
        InlineScript { Write-Host "powershell.exe ./kindtek/devels-workshop/dvpg/scripts/wsl-docker-import.ps1" }
    }

    # }
    # catch {
    #     InlineScript { Write-Host "Something went wrong. Restarting your computer will probably fix the problem." }
    #     InlineScript { Write-host "Error: $err" }
    #     # Restart-Computer -Wait 
    #     # start_installer_daemon $temp_repo_scripts_path     
    # }
}

    
start_installer_daemon $temp_repo_scripts_path