$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
# powershell version compatibility for PSScriptRoot
if (!$PSScriptRoot) { $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
$pwd_path = $PSScriptRoot
# jump to bottom line without clearing scrollback
Write-Output "$([char]27)[2J"

function restart_prompt {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
    $confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip" 
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
$repo_src_branch = 'main'

# use windows-features-wsl-add to handle windows features install 
# installing first to make sure environment has powershell 2
$winconfig = "$pwd_path/add-wsl-windows-features/add-features.ps1"
&$winconfig = Invoke-Expression -command "$pwd_path/add-wsl-windows-features/add-features.ps1"


Write-Host "`r`nThe following programs will now be installed:" -ForegroundColor Magenta
Write-Host "`t- WinGet`r`n`t- Github CLI`r`n`t- Visual Studio Code`r`n`t- Docker Desktop`r`n`t- Powershell 2.0" -ForegroundColor Magenta
Write-Host "`r`nUse Ctrl + C to quit at any time"

# install winget and use winget to install everything else
$software_name = "WinGet"
$winget = "$pwd_path/get-latest-winget.ps1"
Write-Host "`n`r`n`rInstalling $software_name ..."  -BackgroundColor "Black"
&$winget = Invoke-Expression -command "$pwd_path/get-latest-winget.ps1" 

$software_name = "Github CLI"
Write-Host "`n`rInstalling $software_name ..." -BackgroundColor "Black"
Invoke-Expression -Command "winget install -e --id GitHub.cli"
Write-Host "`n`r" -BackgroundColor "Black"

# remove repo_src_name/scripts from working directory pathname
$git_dir = $pwd_path.Replace("$repo_src_name/scripts", "") 
$git_dir = $git_dir.Replace("/$repo_src_name/scripts", "") 
$git_dir = $git_dir.Replace("\$repo_src_name\scripts", "") 
$git_dir = $git_dir.Replace("$repo_src_name\scripts", "") 
$git_dir += "/$repo_src_name"

Set-Location ../../

# cleanup any old files from previous run
try {
    if (Test-Path -Path "$git_dir") {
        Remove-Item "$git_dir" -Force -Recurse -ErrorAction SilentlyContinue
    }
}
catch {}

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

$software_name = "Docker Desktop"
Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
Invoke-Expression -Command "winget install --id=Docker.DockerDesktop -e" 

Write-Host "`r`nA restart may be required for the changes to take effect. " -ForegroundColor Magenta -BackgroundColor "Black"
$confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now`r`n ..or hit ENTER to skip" 
if ($confirmation -ieq 'reboot now') {
    Restart-Computer -Force
}

# launch docker desktop and keep it open 
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle "Minimized"
Write-Host "`r`n`r`nWaiting for $software_name to come online ..." -BackgroundColor "Black" -ForegroundColor "Yellow"
Write-Host "`r`n$software_name is required to run the Docker import tool for WSL and will be launched soon. `r`nYou can minimize $software_name by pressing WIN + Down arrow" -BackgroundColor "Black"

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

# @TODO: find a way to check if windows terminal is installed
$windows_terminal_install = Read-Host "`r`nInstall Windows Terminal? ([y]/n)"
if ($windows_terminal_install -ine 'n' -Or $windows_terminal_install -ine 'no') { 
    $host.UI.RawUI.BackgroundColor = "Black"
    $software_name = "Windows Terminal"
    Write-Host "`r`nInstalling $software_name`r`n" -BackgroundColor "Black"
    Invoke-Expression -Command "winget install Microsoft.WindowsTerminal" 
}

$user_input = (Read-Host "`r`nopen Docker Dev environment? [y]/n")
if ( $user_input -ine "n" ) {
    Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/docker-to-wsl@dev" -WindowStyle "Hidden"
} 

# launch the below process concurrently
# // commenting out background building process because this is NOT quite ready.
# // would like to run in separate window and then use these new images in devel's playground 
# // if they are more up to date than the hub - which could be a difficult process
# $cmd_command = "$git_dir/scripts/build-in-background.ps1"
# &$cmd_command = cmd /c start powershell -Command "$git_dir/scripts/build-in-background.ps1" -WindowStyle "Maximized"
# Write-Host "`r`n" -BackgroundColor "Black"

Write-Host "`r`nSetup complete!`r`n" -ForegroundColor Green -BackgroundColor "Black"


# @TODO: maybe start in new window
$start_devs_playground = Read-Host "`r`nStart Devel's Playground ([y]/n)"
if ($start_devs_playground -ine 'n' -Or $start_devs_playground -ine 'no') { 
    $host.UI.RawUI.BackgroundColor = "Black"
    $devs_playground = "$git_dir/scripts/wsl-import.bat"
    &$devs_playground = cmd /c start powershell -Command "$git_dir/scripts/wsl-import.bat" -WindowStyle "Maximized"
}

try {
    Remove-Item "$git_dir".replace($repo_src_name, "install-$repo_src_owner-$repo_src_name.ps1") -Force -ErrorAction SilentlyContinue
    Write-Host "`r`nCleaning up..  `r`n"
    # make extra sure this is not a folder that is not important (ie: system32 - which is a default location)
    if ($git_dir.Contains($repo_src_name) -And $git_dir.NotContains("System32") ) {
        Remove-Item $git_dir -Recurse -Confirm -Force -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host "Run the following command to delete installation files:`r`nRemove-Item $git_dir -Recurse -Confirm -Force`r`n(will also delete Devel's Playground)"
}


