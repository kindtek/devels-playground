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
    $winconfig = "$temp_repo_scripts_path/devels-advocate/add-windows-features.ps1"
    &$winconfig = Invoke-Expression -command "$temp_repo_scripts_path/devels-advocate/add-windows-features.ps1"
    return $new_install
}

function install_dependencies {
    param ($temp_repo_scripts_path, $git_path)

    Write-Host "`r`nThese programs will be installed or updated:" 
    Write-Host "`r`n`t- WinGet`r`n`t- Github CLI`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Windows Terminal" 
    Write-Host "`r`nClose window to quit at any time"

    $software_name = "WinGet"
    if (!(Test-Path -Path "$git_path/.winget-installed" -PathType Leaf)) {
        Push-Location $temp_repo_scripts_path
        # install winget and use winget to install everything else
        $winget = "devels-advocate/get-latest-winget.ps1"
        Write-Host "`n`r`n`rInstalling $software_name ..." 
        &$winget = Invoke-Expression -command "devels-advocate/get-latest-winget.ps1" 
        Write-Host "`t$software_name installed"  | Out-File -FilePath "$git_path/.winget-installed"
        Pop-Location
    }
    else {
        Write-Host "`t$software_name already installed"  
    }

    $software_name = "Github CLI"
    if (!(Test-Path -Path "$git_path/.github-installed" -PathType Leaf)) {
        Write-Host "`n`r`tInstalling $software_name ..."
        Invoke-Expression -Command "winget install -e --id GitHub.cli"
        Invoke-Expression -Command "winget install --id Git.Git -e --source winget"
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.github-installed"
    }
    else {
        Write-Host "`t$software_name already installed" 
    }

    $software_name = "Visual Studio Code (VSCode)"
    if (!(Test-Path -Path "$git_path/.vscode-installed" -PathType Leaf)) {
        Write-Host "`r`n`tInstalling $software_name`r`n"
        Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 
        Write-Host "$software_name installed" | Out-File -FilePath "$git_path/.vscode-installed"
    }
    else {
        Write-Host "`t$software_name already installed"  
    }

    $software_name = "Docker Desktop"
    if (!(Test-Path -Path "$git_path/.docker-installed" -PathType Leaf)) {
        Write-Host "`r`n`tInstalling $software_name`r`n" 
        Invoke-Expression -Command "winget install --id=Docker.DockerDesktop -e" 
        Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.docker-installed"
    }
    else {
        Write-Host "`t$software_name already installed"  
    }

    $software_name = "Windows Terminal"
    if (!(Test-Path -Path "$git_path/.wterminal-installed" -PathType Leaf)) {
        # $windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
        # if ($windows_terminal_install -ine 'n' -And $windows_terminal_install -ine 'no') { 
        Write-Host "`r`n`tInstalling $software_name`r`n" 
        Invoke-Expression -Command "winget install Microsoft.WindowsTerminal" 
        # }
        Write-Host "$software_name installed`r`n"  | Out-File -FilePath "$git_path/.wterminal-installed"
    }
    else {
        Write-Host "`t$software_name already installed`r`n"  
    }

    # this is used for x11 / gui stuff .. @TODO: add the option one day maybe
    # choco install vcxsrv microsoft-windows-terminal wsl -y
    
}

function test_repo_path {
    param (
        $parent_path, $git_path, $repo_src_owner, $repo_src_name
    )
    try {
        # refresh environment variables
        # cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
        if (Test-Path -Path "$parent_path/$repo_src_name") {
            Set-Location "$parent_path/$repo_src_name"
            # if git status works and finds devels-workshop repo, assume the install has been successfull and this script was ran once before
            $git_status = git remote show origin 
            # determine if git status works by checking output for LICENSE - see typical output of git status here: https://amitd.co/code/shell/git-status-porcelain
            if ($git_status.NotContains("github.com/$repo_src_owner/$repo_src_name")) {
                Write-Debug "`tNot a git repository"
            }
        }
        else {
            Write-Debug "`tNo git directory found"
        }
    }
    catch {
        Write-Debug "`tGit command not found"
        powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle "Hidden"
        
        return $false
    }

    return $true
}

function install_repo {
    param (
        $parent_path, $git_path, $repo_src_owner, $repo_src_name, $repo_src_branch 
    )
    try {
        Write-Host "Now installing:`r`n`t- Chocolatey`r`n`t- Python`r`n" 

        # refresh environment variables using script in choco temp download location
        powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle "Hidden"
        # Write-Host "parent path: $parent_path"
        Set-Location $parent_path
        $new_install = $false
    
        # test git
        $git_version = git --version 
    
        # .. and then clone the repo
        if (!(Test-Path -Path "$parent_path/$repo_src_name")) {
            git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch
        }
        
        Set-Location "$repo_src_name"
        git submodule update --force --recursive --init --remote
    
        # @TODO: since this gave so many errors, use git to install from source - the current way does like it may be better to stay up to date (rather than using a fork or origin choco repo)
        $software_name = "Chocolatey"
        if (!(Test-Path -Path "$git_path/.choco-installed" -PathType Leaf)) {
            $new_install = $true
            # getting error-0x80010135 path too long error when unzipping.. unzip operation at the shortest path
            # Push-Location $temp_repo_scripts_path
            Push-Location scripts

            Push-Location choco
            # $choco = "devels-advocate/get-latest-choco.ps1"
            # Write-Host "`n`r`n`rInstalling $software_name ..." 
            # $env:path += ";C:\ProgramData\chocoportable"
            # &$choco = Invoke-Expression -command "devels-advocate/get-latest-choco.ps1" 
            # $choco = "cmd.exe /c scripts/choco/build.bat"
            Write-Host "`n`r`n`rI`tnstalling $software_name ..." 
            $env:path += ";C:\ProgramData\chocoportable"
            $choco = "build.bat"
            Write-Host "Executing $choco ..."
            &$choco = cmd /c start powershell.exe -Command "build.bat"
            $refresh_env = "src/chocolatey.resources/redirects/RefreshEnv"
            &$refresh_env = cmd /c start powershell.exe -Command "src/chocolatey.resources/redirects/RefreshEnv.cmd"
            # cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden
            Pop-Location
            Pop-Location
            Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.choco-installed"

            # Push-Location cdir
            # Push-Location bin
        }
        else {
            Write-Host "`t$software_name already installed"  
        }
        
        

        Write-Host"`r`n"
        powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle "Hidden"
        Write-Host"`r`n"
    
        if (!(Test-Path -Path "$git_path/.python-installed" -PathType Leaf)) {
            $new_install = $true
            # @TODO: add cdir and python to install with same behavior as other installs above
            # not eloquent at all but good for now
            winget install --id=Python.Python.3.10  -e
    
            # ... even tho cdir does not appear to be working on windows
            # $cmd_command = pip install cdir
            # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
       
            Write-Host "$software_name installed"  | Out-File -FilePath "$git_path/.python-installed"
        }
        else {
            Write-Host "`t$software_name already installed"
        }

        return $new_install
    
    }
    # if git is not recognized try to limp along with the manually downloaded files
    catch {}
}

# refresh env again
# cmd /c start powershell.exe "$git_path/scripts/choco/src/chocolatey.resources/redirects/RefreshEnv.cmd" -Wait -WindowStyle Hidden

# $user_input = (Read-Host "`r`nopen Docker Dev environment? [y]/n")
# if ( $user_input -ine "n" ) {
#     Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/devels-workshop@main" -WindowStyle "Hidden"
# } 

function require_docker_online {

    $docker_tries = 0
    $docker_online = $false
    # launch docker desktop and keep it open 
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Hidden"
    Write-Host "`r`n`r`nWaiting for Docker to come online ..."     
    do {
        $check_again = 'x'
        
        try {
            $docker_tries++
            Start-Sleep -seconds 1
            { Get-Process 'com.docker.proxy' } *>$null
            $docker_online = $true
            Write-Host "Docker Desktop is now online"
            return $docker_online
        }
        catch {
            if ($docker_online -eq $false -And (($docker_tries % 80) -eq 0)) {
                return $false
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 30) -eq 0)) {
                # start count over
                # $docker_attempt1 = $docker_attempt2 = $false
                # prompt to continue
                write-host "$docker_status_now`r`n"
                # $check_again = Read-Host "Keep trying to connect to Docker? ([y]n)"
            }
            elseif ($docker_online -eq $false -And (($docker_tries % 20) -eq 0)) {
                # docker update --restart=always docker-desktop
                # docker update --restart=always docker-desktop-data
                Write-Host "Waited $docker_tries seconds .. "
                # Write-Host "Restarting Docker Engine..."
                # Write-Host "Switching Docker Engine ...."
                # ./DockerCli.exe -SwitchDaemon
                # Start-Sleep 5
                # Write-Host "Setting Docker Engine to Linux ....."
                # ./DockerCli.exe -SwitchLinuxEngine
                # Write-Host "Switch complete."
                Write-Host "Retrying connection in 10 seconds ......"
                Start-Sleep -seconds 10
            }
        }
    } while (-Not $docker_online )
    # } while (-Not $docker_online -Or $check_again -ine 'n')

    return $docker_online
}

function run_devels_playground {
    param (
        $git_path
    )
    try {
        # @TODO: maybe start in new window
        # $start_devs_playground = Read-Host "`r`nStart Devel's Playground ([y]/n)"
        $software_name = "Docker Desktop"
        # if ($start_devs_playground -ine 'n' -And $start_devs_playground -ine 'no') { 
        Write-Host "`r`nNOTE:`t$software_name is required to be running for the Devel's Playground to work.`r`n`r`n`tDo NOT quit $software_name until you are done running it.`r`n" 
        Write-Host "`r`n`r`nAttempting to start wsl import tool ..."
        # if (
        require_docker_online
        # ) {
        # // commenting out background building process because this is NOT quite ready.
        # // would like to run in separate window and then use these new images in devel's playground 
        # // if they are more up to date than the hub - which could be a difficult process
        # $cmd_command = "$git_path/devels_playground/scripts/docker-images-build-in-background.ps1"
        # &$cmd_command = cmd /c start powershell.exe -Command "$git_path/devels_playground/scripts/docker-images-build-in-background.ps1" -WindowStyle "Maximized"
               
        Write-Output "$([char]27)[2J"
        $devs_playground = "$git_path/devels-playground/scripts/wsl-docker-import.cmd"
        Write-Host "Launching Devel's Playground`r`n$devs_playground ...`r`n" 
        Write-Host `"cmd /c start powershell.exe -Command "$git_path/devels-playground/scripts/wsl-docker-import.cmd"`"
        &$devs_playground = cmd /c start powershell.exe -Command "$git_path/devels-playground/scripts/wsl-docker-import.cmd"
        # }
        # else {
        #     Write-Host "Failed to launch docker. Not able to start Devel's Playground. Please restart and run the script again:"
        #     Write-Host "cmd `"$git_path/kindtek/devels-workshop/devels-playground/scripts/wsl-docker-import`""
        #     Write-Host "powershell.exe ./kindtek/devels-workshop/devels-playground/scripts/wsl-docker-import.ps1"
        # }
        # }
    
    }
    catch {}
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
    $new_install = install_windows_features $temp_repo_scripts_path 
    if ($new_install -eq $true) {
        InlineScript { Write-Host "`r`nWindows features installed. Restarting computer ... r`n" }
        # Restart-Computer -Wait
    }
    
    $new_install = install_dependencies $temp_repo_scripts_path $git_path
    if ($new_install -eq $true) {
        InlineScript { Write-Host "`r`nRestarting computer ... r`n" - }
        # Restart-Computer -Wait
    }

    install_repo $parent_path $git_path $repo_src_owner $repo_src_name $repo_src_branch
    InlineScript { Write-Host "$([char]27)[2J" }
    InlineScript { Write-Host "`r`nSetup complete!`r`n" }

    require_docker_online
    run_devels_playground $git_path

    # }
    # catch {
    #     InlineScript { Write-Host "Something went wrong. Restarting your computer will probably fix the problem." }
    #     InlineScript { Write-host "Error: $err" }
    #     # Restart-Computer -Wait 
    #     # start_installer_daemon $temp_repo_scripts_path     
    # }
}

    
start_installer_daemon $temp_repo_scripts_path