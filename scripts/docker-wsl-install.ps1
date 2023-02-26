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
                    Write-Host "Installing $software_name..."
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

function restart_prompt {
    Write-Host "`r`nA restart is required for the changes to take effect. " -ForegroundColor Magenta
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
$winget = "$pwd_path/get-latest-winget.ps1"
Write-Host "`n`r`n`rInstalling WinGet ..."
&$winget = Invoke-Expression -command "$pwd_path/get-latest-winget.ps1"

$software_name = "Github CLI"
$software_id = "Git_is1"
&$install_command = "winget install -e --id GitHub.cli"

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

write-host "cloning to $git_dir"
git clone "https://github.com/$repo_src_owner/$repo_src_name.git" --branch $repo_src_branch "$git_dir"
Set-Location "$git_dir"
git submodule update --force --recursive --init --remote
Set-Location ../../

Set-Location $git_dir

# @TODO: find a way to check if VSCode is installed
$software_id = $software_name = "Visual Studio Code (VSCode)"
&$install_command = "winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks=`"!runcode,addcontextmenufiles,addcontextmenufolders`"'"
# $verify_installed = $false
# $force_install = $true
# install_software $software_id $software_name $install_command $verify_installed $force_install

# Docker Desktop happens to work for both id and name
$software_id = $software_name = "Docker Desktop"
&$install_command = "winget install --id=Docker.DockerDesktop -e"
# $verify_installed = $true
# $force_install = $true
# install_software $software_id $software_name $install_command $verify_installed $force_install

# launch docker desktop and keep it open so that 
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -Wait -WindowStyle "Hidden"

Write-Host "`r`nA restart may be required for the changes to take effect. " -ForegroundColor Magenta
$confirmation = Read-Host "`r`nType 'reboot now' to reboot your computer now" 
if ($confirmation -ieq 'reboot now') {
    Restart-Computer -Force
}
# start WSL docker import tool
$winconfig = "$git_dir/scripts/wsl-import.bat"
&$winconfig = Invoke-Expression -command "$git_dir/scripts/wsl-import.bat" -WindowStyle "Maximized"

# @TODO: launch the below process concurrently
$cmd_args = "$pwd_path/docker-to-wsl/scripts/images-build.bat" 
&$cmd_args = Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList cmd "$pwd_path/docker-to-wsl/scripts/images-build.bat"

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

