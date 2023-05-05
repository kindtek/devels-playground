$distros = wsl.exe -l -v
$count = 0

# Loop through each distro and prompt to remove
foreach ($distro in $distros) {
    $count += 1

    if ($count -lt 3 -Or $distro.length -le 1) { 
        continue 
    }

    if (($distro.IndexOf("*") -lt 0) -And ($distro.IndexOf("docker-desktop") -lt 0)) {
        $index_start = 2
        $warning_str = ""
    }
    else {
        continue
        $index_start = 4
        $warning_str = "
WARNING: removing this distro is not a good idea
"
    }

    $index_stop = $distro.IndexOf("    ")
    $distroName = $distro.Substring($index_start, $index_stop)
    $distroName = $distroName.Split('', [System.StringSplitOptions]::RemoveEmptyEntries) -join ''
    $distroName -replace '\s', ''
    $distroName = $distroName.Substring(3, $distroName.Length - 5)

    $removeDistro = Read-Host "`n`n`n`n`nDo you want to remove ${distroName}? $warning_str(Y/N)"

    if ($removeDistro.ToLower() -eq "y") {
        $command_str = "wsl.exe --unregister $distroName"

        # Remove distro
        Write-Host "$command_str"
        Invoke-Expression -Command "$command_str"
    }
}
