Start-Process "https://www.microsoft.com/p/app-installer/9nblggh4nns1"
winget install -e --id GitHub.cli
winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"' 
winget install --id=Docker.DockerDesktop  -e
"C:\Program Files\Docker\Docker\DockerCli.exe" 
