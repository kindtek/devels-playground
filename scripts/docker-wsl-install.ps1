Start-Process "https://www.microsoft.com/p/app-installer/9nblggh4nns1"
winget install -e --id GitHub.cli
winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"' 
winget install --id=Docker.DockerDesktop  -e
Start-Process "https://open.docker.com/dashboard/dev-envs?url=https://github.com/kindtek/docker-to-wsl@dev"
# ./images-build-push.ps1
./wsl-import.ps1
Write-Output "DONE!"