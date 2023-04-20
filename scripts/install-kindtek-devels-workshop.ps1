$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
$img_tag = $args[0]

function install_winget {
    param (
        $git_parent_path
    )
    $software_name = "WinGet"
    Write-Host "`r`n"
    if (!(Test-Path -Path "$git_parent_path/.winget-installed" -PathType Leaf)) {
        $file = "$git_parent_path/get-latest-winget.ps1"
        Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/dvl-adv/dvl-works/get-latest-winget.ps1" -OutFile $file;
        powershell.exe -executionpolicy remotesigned -File $file
        # install winget and use winget to install everything else
        Write-Host "Installing $software_name ..." 
        # $p = Get-Process -Name "PackageManagement"
        # Stop-Process -InputObject $p
        # Get-Process | Where-Object { $_.HasExited }
        Write-Host "$software_name installed" | Out-File -FilePath "$git_parent_path/.winget-installed"
    }
    else {
        Write-Host "$software_name already installed"   
    }
}

function install_repo {
    param (
        $git_parent_path, $git_path, $repo_src_owner, $repo_src_name, $repo_git_name, $repo_src_branch 
    )
    $software_name = "Github CLI"
    if (!(Test-Path -Path "$git_parent_path/.github-installed" -PathType Leaf)) {
        Write-Host "Installing $software_name ..."
        winget install --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --exact --id GitHub.cli --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget install --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements
        winget upgrade --id Git.Git --source winget --silent --locale en-US --accept-package-agreements --accept-source-agreements
        Write-Host "$software_name installed" | Out-File -FilePath "$git_parent_path/.github-installed"
        $new_install = $true
        $file = "$HOME/repos/kindtek/RefreshEnv.cmd"
        Invoke-WebRequest "https://raw.githubusercontent.com/kindtek/choco/ac806ee5ce03dea28f01c81f88c30c17726cb3e9/src/chocolatey.resources/redirects/RefreshEnv.cmd" -OutFile $file;
        powershell.exe -Command $file 
    }
    else {
        Write-Host "$software_name already installed" 
    }

    Set-Location $git_parent_path
    $new_install = $false

    ( git -C $repo_git_name pull origin --progress ) -Or ( ( git clone "https://github.com/$repo_src_owner/$repo_src_name" --branch $repo_src_branch --progress -- $repo_git_name > $null ) -And ( $new_install = $true ) ) 

    Push-Location $repo_git_name
    
    ( git submodule update --remote --progress -- dvlp dvl-adv powerhell ) -Or ( ( git submodule update --init --remote --progress -- dvlp dvl-adv powerhell > $null ) -And ( $new_install = $true ) ) 

    return $new_install
}

function run_devels_playground {
    param (
        $git_path, $img_tag, $non_interactive, $default_distro
    )
    try {
        $software_name = "devel`'s playground"
        if (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf)) {
            Start-Sleep 10
            Write-Host "`r`nNOTE:`tDocker Desktop is required to be running for the devel's playground to work.`r`n`r`n`tDo NOT quit Docker Desktop until you are done running it.`r`n" 
            Start-Sleep 3
            Write-Host "`r`n`r`nAttempting to start wsl import tool ..."
            # @TODO: add cdir and python to install with same behavior as other installs above
            # not eloquent at all but good for now

            # ... even tho cdir does not appear to be working on windows
            # $cmd_command = pip install cdir
            # Start-Process -FilePath PowerShell.exe -NoNewWindow -ArgumentList $cmd_command
    
            # @TODO: maybe start in new window
            # $start_devs_playground = Read-Host "`r`nstart devel's playground ([y]/n)"
            # if ($start_devs_playground -ine 'n' -And $start_devs_playground -ine 'no') { 

            # // commenting out background building process because this is NOT quite ready.
            # // would like to run in separate window and then use these new images in devel's playground 
            # // if they are more up to date than the hub - which could be a difficult process
            # $cmd_command = "$git_path/devels_playground/docker-images-build-in-background.ps1"
            # &$cmd_command = cmd /c start powershell.exe -Command "$git_path/devels_playground/docker-images-build-in-background.ps1" -WindowStyle "Maximized"

            Write-Host "Launching $software_name ...`r`n" 
            # Write-Host "&$devs_playground $global:img_tag"
            # Write-Host "$([char]27)[2J"
            # Write-Host "`r`npowershell.exe -Command `"$git_path/dvlp/scripts/wsl-docker-import.cmd`" $img_tag`r`n"
            $img_tag = $img_tag.replace("\s+",'')
            if ($img_tag -eq "") {
                $img_tag = "default"
            }
            powershell.exe -Command "$git_path/dvlp/scripts/wsl-docker-import.cmd" "$img_tag" "$non_interactive" "$default_distro"
            # &$devs_playground = "$git_path/dvlp/scripts/wsl-docker-import.cmd $global:img_tag"
            # Write-Host "$software_name installed`r`n" | Out-File -FilePath "$git_path/.dvlp-installed"
        }
    }
    catch {}
}

# jump to bottom line without clearing scrollback
$start_over = 'n'
do {


    $repo_src_owner = 'kindtek'
    $repo_src_name = 'devels-workshop'
    $repo_src_branch = 'main'
    $repo_git_name = 'dvlw'
    $git_parent_path = "$HOME/repos/$repo_src_owner"
    $git_path = "$git_parent_path/$repo_git_name"
    $img_tag = $args[0]

    $confirmation = ''
    

    if (($start_over -ine 's') -And (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf))) {
        Write-Host "$([char]27)[2J"
        $host.UI.RawUI.ForegroundColor = "Black"
        $host.UI.RawUI.BackgroundColor = "DarkRed"

        # $confirmation = Read-Host "`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`tHit ENTER to continue`r`n`r`n`tpowershell.exe -Command $file $args" 
        $confirmation = Read-Host "`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`tHit ENTER to continue`r`n"
        Write-Host "$([char]27)[2J"
        Write-Host "`r`n`r`n`r`n`r`n`r`n`r`nRestarts may be required as new applications are installed. Save your work now.`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`r`n`t"

    }
    if (($confirmation -eq '') -And (!(Test-Path -Path "$git_path/.dvlp-installed" -PathType Leaf))) {   
        $host.UI.RawUI.ForegroundColor = "Black"
        $host.UI.RawUI.BackgroundColor = "DarkRed" 
        Write-Host "`t-- use CTRL + C or close this window to cancel anytime --"
        Start-Sleep 3
        Write-Host ""
        Start-Sleep 1
        Write-Host ""


        # source of the below self-elevating script: https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html#:~:text=If%20User%20Account%20Control%20(UAC,select%20%22Run%20with%20PowerShell%22.
        # Self-elevate the script if required
        if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
            if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
                $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
                Start-Process -FilePath PowerShell.exe -Verb Runas -WindowStyle "Maximized" -ArgumentList $CommandLine
                Exit
            }
        }
        $host.UI.RawUI.ForegroundColor = "White"
        $host.UI.RawUI.BackgroundColor = "Black"
        Write-Host ""
        Start-Sleep 1
        Write-Host ""
        Start-Sleep 1
        Write-Host "`r`n`r`nThese programs will be installed or updated:" -ForegroundColor Magenta
        Start-Sleep 1
        Write-Host "`r`n`t- WinGet`r`n`t- Github CLI`r`n`t- devels-workshop repo`r`n`t- devels-playground repo" -ForegroundColor Magenta
        
        # Write-Host "Creating path $HOME\repos\kindtek if it does not exist ... "  
        New-Item -ItemType Directory -Force -Path $git_parent_path | Out-Null

        install_winget $git_parent_path

        install_repo $git_parent_path $git_path $repo_src_owner $repo_src_name $repo_git_name $repo_src_branch  

        powershell.exe -Command "$git_path/scripts/install-everything.ps1"

        $host.UI.RawUI.ForegroundColor = "Black"
        $host.UI.RawUI.BackgroundColor = "DarkRed"

        # make sure failsafe official-ubuntu-latest distro is installed so changes can be easily reverted
        run_devels_playground "$git_path" "default" "nointeract" "default"
        # instsall distro requested in arg
        run_devels_playground "$git_path" "$img_tag" "nointeract" "default"
        
        Write-Host "`r`n`r`n"

        # $start_over = Read-Host "`r`nHit ENTER to exit or choose from the following:`r`n`t- launch [W]SL`r`n`t- launch [D]evels Playground`r`n`t- launch repo in [V]S Code`r`n`t"
        $start_over = Read-Host "`r`nHit ENTER to exit or choose from the following:`r`n`t- launch [W]SL`r`n`t- launch [D]evels Playground`r`n`t- [S]tart over`r`n`r`n    (exit)" 
        if ($start_over -ieq 'w') {    
            # wsl sh -c "cd /hel;exec $SHELL"
            wsl
        }
        elseif ($start_over -ieq 'd') {
            run_devels_playground "$git_path" "$img_tag" ""
        }
        elseif ($start_over -ieq 's') {
            Write-Host 'Restarting process ...'
        }
        # elseif ($start_over -ieq 'v') {
        #     wsl sh -c "cd /hel;. code"
        # }
        else {
            $start_over = ''
            break
        }
    }
} while ($start_over -ieq 's')


Write-Host "`r`nGoodbye!`r`n"
