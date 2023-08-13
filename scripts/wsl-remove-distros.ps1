$env:WSL_UTF8 = 1
$count = 0

$distros = wsl.exe --list --quiet
if ($?){
    # Loop through each distro and prompt to remove
    foreach ($distro in $distros) {
        $count += 1   
        if (($distro.IndexOf("*") -le 0) -And ($distro.IndexOf("docker-desktop") -lt 0)) {
            $warning_str = ""
        } else {
            continue
            $warning_str = "
    WARNING: removing this distro is not a good idea
    "
        }
        Write-Host `r`n`r`n`r`n`t
        wsl -l -v
        wsl.exe --distribution "$($distro.trim())" --version | out-null
        if ($?){
            $removeDistro = Read-Host "`n`n`n`n`nDo you want to remove $($distro.trim())? $warning_str(Y/N)"

            if ($removeDistro.ToLower() -eq "y") {
                # wsl.exe --unregister "$($distro.trim())"
    
                # # Remove distro
                # Write-Host "$command_str"
                # $wsl_exe = 'wsl.exe --unregister'.Trim()
                # $unregister = "$distroName".Trim()
                try {
                    wsl.exe --unregister "$($distro.trim())"
                } catch {
                    $command_string = "wsl.exe --unregister $($distro.trim())".Trim()
                    &$command_string = Invoke-Expression $command_string | Out-Null
                }
                if ($?){
                    write-host "$($distro.trim()) distro removed successfully"
                } else {
                    write-host "could not remove $($distro.trim()) distro"
                }
            }
        }
    }

    Write-Host "`r`n`r`n`r`n"
    wsl --list --verbose | Out-Null
    if ($?){
        wsl --list --verbose
    }

    Write-Host "`r`n`r`nend of distro list`r`n`r`n"
} else {
    Write-Host "`r`n`r`nno distros to uninstall ..skipping`r`n`r`n"
}



