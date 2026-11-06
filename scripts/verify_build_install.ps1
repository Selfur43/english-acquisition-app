param([Parameter(Mandatory=$true)][string]$ProjectRoot)
$ErrorActionPreference = 'Stop'
Set-Location $ProjectRoot
function Invoke-Checked { param([string]$Executable,[string[]]$ArgumentList) & $Executable @ArgumentList; if($LASTEXITCODE -ne 0){throw "$Executable failed with exit code $LASTEXITCODE"} }
Remove-Item '.\pubspec.lock' -Force -ErrorAction SilentlyContinue
Remove-Item '.\.dart_tool' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item '.\build' -Recurse -Force -ErrorAction SilentlyContinue
Invoke-Checked flutter @('pub','get')
$deps = flutter pub deps --style=compact
if ($deps -match 'path_provider_android 2\.3\.' -or $deps -match 'jni_flutter') { throw 'Incompatible JNI dependency chain was resolved.' }
Invoke-Checked dart @('format','lib','test','tool')
Invoke-Checked flutter @('analyze')
Invoke-Checked flutter @('test')
Invoke-Checked flutter @('build','windows','--release')
$exe=Join-Path $ProjectRoot 'build\windows\x64\runner\Release\english_acquisition_app.exe'
if(-not(Test-Path $exe)){throw 'Release EXE missing'}
& '.\scripts\install_desktop_shortcuts.ps1'
Start-Process $exe
