$ErrorActionPreference = 'Stop'
$projectRoot = Join-Path (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Projects') 'english_acquisition_app_current'
$exe = Join-Path $projectRoot 'build\windows\x64\runner\Release\english_acquisition_app.exe'
if (-not (Test-Path $exe)) {
    & (Join-Path $projectRoot 'scripts\verify_build_install.ps1') -ProjectRoot $projectRoot
    exit
}
Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe)
