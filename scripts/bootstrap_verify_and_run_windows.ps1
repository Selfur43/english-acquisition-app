$ErrorActionPreference = 'Stop'
function Invoke-NativeCommand {
  param([Parameter(Mandatory=$true)][string]$Executable,[Parameter(Mandatory=$true)][string[]]$ArgumentList)
  $previous=$ErrorActionPreference
  try { $script:ErrorActionPreference='Continue'; & $Executable @ArgumentList; $code=$LASTEXITCODE }
  finally { $script:ErrorActionPreference=$previous }
  if($code -ne 0){ throw "Command failed with exit code ${code}: $Executable $($ArgumentList -join ' ')" }
}
function Build-WindowsWithRecovery {
  param([Parameter(Mandatory=$true)][string]$Mode)
  try { Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('build','windows',"--$Mode") }
  catch {
    Write-Warning "Windows $Mode build encountered stale MSBuild state. Cleaning generated build state and retrying once."
    Remove-Item '.\build\windows' -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item '.\.dart_tool\flutter_build' -Recurse -Force -ErrorAction SilentlyContinue
    Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('pub','get')
    Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('build','windows',"--$Mode")
  }
}
if(-not(Get-Command flutter -ErrorAction SilentlyContinue)){throw 'Flutter is not available in PATH.'}
if(-not(Test-Path '.\pubspec.yaml')){throw "Run from the project root. Current folder: $(Get-Location)"}
Write-Host 'Checking Flutter and Windows toolchain...' -ForegroundColor Cyan
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('doctor','-v')
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('config','--enable-windows-desktop')
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('create','--platforms=windows','.')
Remove-Item '.\test\widget_test.dart' -ErrorAction SilentlyContinue
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('pub','get')
Invoke-NativeCommand -Executable 'dart' -ArgumentList @('format','lib','test','tool')
Invoke-NativeCommand -Executable 'dart' -ArgumentList @('run','tool/validate_phase1.dart')
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('analyze')
Invoke-NativeCommand -Executable 'flutter' -ArgumentList @('test')
Build-WindowsWithRecovery -Mode 'debug'
Build-WindowsWithRecovery -Mode 'release'
Write-Host 'Verification completed successfully.' -ForegroundColor Green
& '.\scripts\install_desktop_shortcut.ps1'
$exe='.\build\windows\x64\runner\Release\english_acquisition_app.exe'
if(-not(Test-Path $exe)){throw "Release executable not found: $exe"}
Start-Process -FilePath $exe
