$ErrorActionPreference = 'Stop'

$packageRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectsRoot = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Projects'
$installRoot = Join-Path $projectsRoot 'english_acquisition_app_current'
$launcherRoot = Join-Path $env:LOCALAPPDATA 'EnglishAcquisitionAppLauncher'

New-Item -ItemType Directory -Path $projectsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $launcherRoot -Force | Out-Null

$packageFull = [IO.Path]::GetFullPath($packageRoot).TrimEnd('\')
$installFull = [IO.Path]::GetFullPath($installRoot).TrimEnd('\')

if ($packageFull -ne $installFull) {
    Write-Host "Installing source into stable workspace: $installRoot" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $installRoot -Force | Out-Null
    robocopy $packageRoot $installRoot /MIR /R:1 /W:1 `
        /XD build .dart_tool .idea .git coverage `
        /XF *.log verification_*.txt *.tmp *.user *.suo | Out-Host
    if ($LASTEXITCODE -ge 8) {
        throw "Source installation failed with robocopy exit code $LASTEXITCODE."
    }
}

Copy-Item (Join-Path $installRoot 'scripts\update_from_zip.ps1') `
    (Join-Path $launcherRoot 'update_from_zip.ps1') -Force
Copy-Item (Join-Path $installRoot 'scripts\launch_current.ps1') `
    (Join-Path $launcherRoot 'launch_current.ps1') -Force

& (Join-Path $installRoot 'scripts\verify_build_install.ps1') -ProjectRoot $installRoot
