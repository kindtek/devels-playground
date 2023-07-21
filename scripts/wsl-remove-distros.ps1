$env:WSL_UTF8 = 1
$distros = wsl.exe -l -v
$count = 0

# Loop through each distro and prompt to remove
foreach ($distro in $distros) {
    $count += 1

    if ($count -lt 3 -Or $distro.length -le 1) { 
        continue 
    }
   


    if (($distro.IndexOf("*") -le 0) -And ($distro.IndexOf("docker-desktop") -lt 0) -And ($distro.IndexOf("kalilinux-kali-rolling-latest") -lt 0)) {
        $index_start = 2
        $warning_str = ""
    }
    else {
        continue
        $index_start = 3
        $warning_str = "
WARNING: removing this distro is not a good idea
"
    }

    $index_stop = 0
    $index_stop = $distro.IndexOf("    ")

    if ($index_stop -ge $distro.length ) {
        $index_stop -= $distro.length - 1
    }
    if ($index_stop -le 0 ) {
        $index_stop += 100
    }

    $distroName = $distro.Substring($index_start, $index_stop)
    $distroName = $distroName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
    $distroName -replace '\s', ''
    Write-Host `r`n`r`n`r`n`t
    wsl -l -v
    $removeDistro = Read-Host "`n`n`n`n`nDo you want to remove ${distroName}? $warning_str(Y/N)"

    if ($removeDistro.ToLower() -eq "y") {
        wsl.exe --unregister $distroName

        # # Remove distro
        # Write-Host "$command_str"
        # $wsl_exe = 'wsl.exe --unregister'.Trim()
        # $unregister = "$distroName".Trim()
        # $command_string = "$wsl_exe `'$unregister`'".Trim()
        # & "$command_string"
    }
}

Write-Host "`r`n`r`n`r`n"

wsl -l -v

Write-Host "`r`n`r`nend of distro list`r`n`r`n"


