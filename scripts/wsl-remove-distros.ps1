$env:WSL_UTF8 = 1
$count = 0

$distros = wsl.exe --list --quiet
if ($?){
    # Loop through each distro and prompt to remove
    foreach ($distro in $distros) {
        $count += 1   


        if (($distro.IndexOf("*") -le 0) -And ($distro.IndexOf("docker-desktop") -lt 0)) {
            $warning_str = ""
        }
        else {
            continue
            $warning_str = "
    WARNING: removing this distro is not a good idea
    "
        }

        Write-Host `r`n`r`n`r`n`t
        wsl -l -v
        $removeDistro = Read-Host "`n`n`n`n`nDo you want to remove ${distro}? $warning_str(Y/N)"

        if ($removeDistro.ToLower() -eq "y") {
            wsl.exe --unregister $distro

            # # Remove distro
            # Write-Host "$command_str"
            # $wsl_exe = 'wsl.exe --unregister'.Trim()
            # $unregister = "$distroName".Trim()
            # $command_string = "$wsl_exe `'$unregister`'".Trim()
            # & "$command_string"
        }
    }

    Write-Host "`r`n`r`n`r`n"

    wsl --l --quiet

    Write-Host "`r`n`r`nend of distro list`r`n`r`n"
} else {
    Write-Host "`r`n`r`nno distros to uninstall ..skipping`r`n`r`n"
}



