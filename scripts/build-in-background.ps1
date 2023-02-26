$cmd_args = "$pwd_path/docker-to-wsl/scripts/images-build.bat" 
&$cmd_args = Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList cmd "$pwd_path/docker-to-wsl/scripts/images-build.bat"