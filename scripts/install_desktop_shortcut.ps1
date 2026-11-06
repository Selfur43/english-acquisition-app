
$ErrorActionPreference='Stop'
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$exe=Join-Path $projectRoot 'build\windows\x64\runner\Release\english_acquisition_app.exe'
if(-not(Test-Path $exe)){throw "Release application not found: $exe"}
$shortcutPath=Join-Path ([Environment]::GetFolderPath('Desktop')) 'English Acquisition App.lnk'
$shell=New-Object -ComObject WScript.Shell
$shortcut=$shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath=$exe
$shortcut.WorkingDirectory=(Split-Path $exe)
$shortcut.Description='Open the English Acquisition App'
$icon=Join-Path $projectRoot 'windows\runner\resources\app_icon.ico'
if(Test-Path $icon){$shortcut.IconLocation=$icon}
$shortcut.Save()
Write-Host "Desktop shortcut created: $shortcutPath" -ForegroundColor Green
