$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
# store file path in $pwd_path and ensure PSScriptRoot worsk the same in both powershell 2 and 3
$pwd_path = $PSScriptRoot
# jump to first line without clearing scrollback
Write-Output "$([char]27)[2J"
function install_software {
    # function built using https://keestalkstech.com/2017/10/powershell-snippet-check-if-software-is-installed/ as aguide
    param (
        $software_id,
        $software_name,
        $install_command,
        $verify_installed,
        $force_install
    )

    if ($verify_installed -eq $true) {
        $installed = $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq $software_id })
        if ($installed -eq $false) {
            if ($force_install -eq $false) {
                # give user the option to install
                $install = Read-Host "`r`n$software_name recommended but not found. Install now? (y/[n])"
                if ($install -ieq 'y' -Or $install -ieq 'yes') { 
                    Write-Host "`r`n"
                    Write-Host "Installing $software_name..." -BackgroundColor "Black"
                    &$install_command
                    $host.UI.RawUI.BackgroundColor = "Black"
                }
                else {
                    Write-Host "skipping $software_name install"
                }
            }
            else {
                $install = Read-Host "`r`n$software_name required. Install now or quit? (y/[q])"
                # @TODO: investigate code refactoring for duplicate code
                if ($install -ieq 'y' -Or $install -ieq 'yes') { 
                    Write-Host "Installing $software_name..."
                    Invoke-Expression $install_command
                    $host.UI.RawUI.BackgroundColor = "Black"
                }
                else {
                    Write-Host "skipping $software_name install and exiting..."
                    exit
                }
            }
        }
        else {
            Write-Host "`r`n$software_name already installed." -ForegroundColor Yellow
        }
    }
    elseif ($force_install -eq $false) { 
        $install = Read-Host "`r`n$software_name recommended. Install now? (y/[n])"
        # @TODO: investigate code refactoring for duplicate code
        if ($install -ieq 'y' -Or $install -ieq 'yes') { 
            Write-Host "Installing $software_name..."
            Invoke-Expression $install_command
            $host.UI.RawUI.BackgroundColor = "Black"
        }
        else {
            Write-Host "skipping $software_name install"
        }
    }
    else {
        # force_install: true, verify_install: false
        $install = Read-Host "`r`n$software_name required. Install now or quit? (y/[q])"
        if ($install -ieq 'y' -Or $install -ieq 'yes') { 
            Write-Host "Installing $software_name..." -BackgroundColor "Black"
            Invoke-Expression $install_command
            $host.UI.RawUI.BackgroundColor = "Black"
        }
        else {
            Write-Host "skipping $software_name install and exiting..." -BackgroundColor "Black"
            exit
        }
    }
}

function restart_prompt {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now" 
    if ($confirmation -ieq 'reboot now') {
        Restart-Computer -Force
    }
}

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

$repo_src_owner = 'kindtek'
$repo_src_name = 'docker-to-wsl'
$repo_src_branch = 'dev'

# use windows-features-wsl-add to handle windows features install 
# installing first to make sure environment has powershell 2
$winconfig = "$pwd_path/add-wsl-windows-features/add-features.ps1"
&$winconfig = Invoke-Expression -command "$pwd_path/add-wsl-windows-features/add-features.ps1"

# install winget and use winget to install everything else
$software_name = "Github CLI"
$winget = "$pwd_path/get-latest-winget.ps1"
Write-Host "`n`r`n`rInstalling $software_name ..."  -BackgroundColor "Black"
&$winget = Invoke-Expression -command "$pwd_path/get-latest-winget.ps1" 

$software_name = "Github CLI"
Write-Host "`n`rInstalling $software_name ..." -BackgroundColor "Black"
$software_id = "Git_is1"
Invoke-Expression -Command "winget install -e --id GitHub.cli"
Write-Host "`n`r" -BackgroundColor "Black"
# $verify_installed = $true
# $force_install = $true
# install_software $software_id $software_name $install_command $verify_installed $force_install

# remove temp/scripts from working directory pathname
$git_dir = $pwd_path.Replace("$repo_src_name/scripts", "") 
$git_dir = $git_dir.Replace("/$repo_src_name/scripts", "") 
$git_dir = $git_dir.Replace("\$repo_src_name\scripts", "") 
$git_dir = $git_dir.Replace("$repo_src_name\scripts", "") 
$git_dir += "/$repo_src_name"

Set-Location ../../
# (git_dir-temp is current directory that contains fresh files)
if (Test-Path -Path "$git_dir") {
    # cleanup any old files from previous run
    Remove-Item "$git_dir" -Force -Recurse
}
if (Test-Path -Path "$git_dir-temp") {
    # cleanup any old files from previous run
    Remove-Item "$git_dir-temp" -Force -Recurse
}
if (Test-Path -Path "$git_dir-delete") {
    # cleanup any old files from previous run
    Remove-Item "$git_dir-delete" -Force -Recurse
}

$host.UI.RawUI.BackgroundColor = "Black"
git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch "$git_dir"
Set-Location "$git_dir"
$host.UI.RawUI.BackgroundColor = "Black"
git submodule update --force --recursive --init --remote
$host.UI.RawUI.BackgroundColor = "Black"
Set-Location ../../

Set-Location $git_dir

$software_name = "Visual Studio Code (VSCode)"
Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
Invoke-Expression -Command "winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'" 


$software_id = $software_name = "Docker Desktop"
Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
Invoke-Expression -Command "winget install --id=Docker.DockerDesktop -e" 


Write-Host "`r`nA restart may be required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
$confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now" 
if ($confirmation -ieq 'reboot now') {
    Restart-Computer -Force
}

Write-Host "`r`nLaunching Docker Desktop.`r`n`r`n$software_name is required to run the Docker import tool for WSL. `r`nYou can minimize $software_name by pressing ENTER`r`n" -BackgroundColor "Black"

# $docker_status_orig = $docker_status_now = (docker version)
# launch docker desktop and keep it open 
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Minimized"
Write-Host "`r`nWaiting for $software_name to come online ..." -BackgroundColor "Black"
do {
    $docker_status_now = (docker version)
    Start-Sleep -seconds 5
    # debug
    # write-host "$docker_status_now`r`n"
    # $check_again = Read-Host "keep checking? (y[n])"
}
while ($docker_status_now.Contains("error"))
# debug
# while ($docker_status_now.Contains("error") -Or $check_again -ieq 'y')

# launch the below process concurrently
# // commenting out background building process because this is NOT quite ready.
# // would like to run in separate window and then use these new images in import tool 
# // if they are more up to date than the hub - which could be a difficult process
# $cmd_command = "$git_dir/scripts/build-in-background.ps1"
# &$cmd_command = cmd /c start powershell -Command "$git_dir/scripts/build-in-background.ps1" -WindowStyle "Maximized"
# Write-Host "`r`n" -BackgroundColor "Black"

# start WSL docker import tool
$cmd_command = "$git_dir/scripts/wsl-import.bat"
&$cmd_command = cmd /c start powershell -Command "$git_dir/scripts/wsl-import.bat" -WindowStyle "Maximized"

# $wsl_import = "$git_dir/scripts/wsl-import.bat"
# &$wsl_import = Invoke-Expression -command "$git_dir/scripts/wsl-import.bat" -WindowStyle "Maximized"

# @TODO: find a way to check if windows terminal is installed
$software_id = $software_name = "Windows Terminal"
$install_command = "winget install Microsoft.WindowsTerminal"
$verify_installed = $false
$force_install = $false
install_software $software_id $software_name $install_command $verify_installed $force_install

$user_input = (Read-Host "`r`nopen Docker Dev environment? [y]/n")
if ( $user_input -ine "n" ) {
    Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/docker-to-wsl@dev" -WindowStyle "Hidden"
} 

# cleanup - remove install script
Remove-Item "$git_dir".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force

Write-Host "`r`nSetup complete!`r`n`r`nCleaning up.. (optional) `r`n" -ForegroundColor Green -BackgroundColor "Black"
# make extra sure this is not a folder that is not important (ie: system32 - which is default location)
if ($git_dir.Contains($repo_src_name)){
    Remove-Item $git_dir -Recurse -Confirm -Force
}

