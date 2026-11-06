
param([string]$UpdateZip)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
if ([string]::IsNullOrWhiteSpace($UpdateZip)) {
  $dialog = New-Object System.Windows.Forms.OpenFileDialog
  $dialog.Filter = 'Complete update ZIP (*.zip)|*.zip'
  $dialog.Title = 'Select English Acquisition App complete update'
  if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { return }
  $UpdateZip = $dialog.FileName
}
if ([string]::IsNullOrWhiteSpace($UpdateZip)) {
  throw 'No update ZIP was selected.'
}
if (-not (Test-Path -LiteralPath $UpdateZip -PathType Leaf)) {
  throw "Update ZIP was not found: $UpdateZip"
}
$UpdateZip = (Resolve-Path -LiteralPath $UpdateZip).Path

$projects = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Projects'
$current = Join-Path $projects 'english_acquisition_app_current'
$stage = Join-Path $projects '_english_acquisition_app_stage'
$rollback = Join-Path $projects '_english_acquisition_app_rollback'
$runtime = Join-Path $env:APPDATA 'EnglishAcquisitionApp\data'
$dataBackupRoot = Join-Path $env:LOCALAPPDATA 'EnglishAcquisitionAppBackups\data'
$logRoot = Join-Path $env:LOCALAPPDATA 'EnglishAcquisitionAppLogs'
New-Item -ItemType Directory -Path $logRoot,$dataBackupRoot -Force | Out-Null
Remove-Item $stage,$rollback -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $stage -Force | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$transcriptLog = Join-Path $logRoot ("update_$stamp.log")
$nativeLog = Join-Path $logRoot ("update_${stamp}_native.log")
$dataBackup = Join-Path $dataBackupRoot ("data_$stamp")
Start-Transcript -Path $transcriptLog -Force | Out-Null

function Invoke-NativeChecked {
  param([string]$Executable,[string[]]$ArgumentList,[string]$WorkingDirectory)
  Push-Location $WorkingDirectory
  $oldPreference = $ErrorActionPreference
  try {
    $script:ErrorActionPreference = 'Continue'
    & $Executable @ArgumentList 2>&1 | Tee-Object -FilePath $nativeLog -Append | Out-Host
    $exitCode = $LASTEXITCODE
  } finally {
    $script:ErrorActionPreference = $oldPreference
    Pop-Location
  }
  if ($exitCode -ne 0) {
    throw "$Executable $($ArgumentList -join ' ') failed with exit code $exitCode"
  }
}

try {
  Expand-Archive -LiteralPath $UpdateZip -DestinationPath $stage -Force
  $pubspec = Get-ChildItem $stage -Recurse -Filter pubspec.yaml -File |
    Where-Object { $_.FullName -notmatch '[\\/](build|\.dart_tool)[\\/]' } |
    Select-Object -First 1
  if ($null -eq $pubspec) { throw 'Selected ZIP does not contain a Flutter project.' }
  $source = Split-Path $pubspec.FullName

  Remove-Item (Join-Path $source 'pubspec.lock') -Force -ErrorAction SilentlyContinue
  Remove-Item (Join-Path $source '.dart_tool') -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item (Join-Path $source 'build') -Recurse -Force -ErrorAction SilentlyContinue

  Write-Host 'Gate 1/7: dependency resolution'
  Invoke-NativeChecked 'flutter' @('pub','get') $source
  Write-Host 'Gate 2/7: deterministic formatting and verification'
  Invoke-NativeChecked 'dart' @('format','lib','test','tool') $source
  Invoke-NativeChecked 'dart' @('format','--output=none','--set-exit-if-changed','lib','test','tool') $source
  Write-Host 'Gate 3/7: V7 static audit'
  Invoke-NativeChecked 'dart' @('run','tool/v7_release_audit.dart') $source
  Write-Host 'Gate 4/7: flutter analyze'
  Invoke-NativeChecked 'flutter' @('analyze') $source
  Write-Host 'Gate 5/7: full automated tests'
  Invoke-NativeChecked 'flutter' @('test') $source

  if (Test-Path $current) {
    robocopy $current $rollback /MIR /R:1 /W:1 /XD .dart_tool /XF *.log *.tmp | Out-Host
    if ($LASTEXITCODE -ge 8) { throw "Source rollback snapshot failed: $LASTEXITCODE" }
  }
  if (Test-Path $runtime) {
    robocopy $runtime $dataBackup /MIR /R:1 /W:1 | Out-Host
    if ($LASTEXITCODE -ge 8) { throw "User data backup failed: $LASTEXITCODE" }
  }
  Get-Process english_acquisition_app -ErrorAction SilentlyContinue |
    Stop-Process -Force -ErrorAction SilentlyContinue

  robocopy $source $current /MIR /R:1 /W:1 /XD .git .idea coverage .dart_tool build /XF *.log *.tmp | Out-Host
  if ($LASTEXITCODE -ge 8) { throw "Source deployment failed: $LASTEXITCODE" }

  Remove-Item (Join-Path $current 'pubspec.lock') -Force -ErrorAction SilentlyContinue
  Remove-Item (Join-Path $current '.dart_tool') -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item (Join-Path $current 'build') -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item (Join-Path $current 'windows\flutter\ephemeral') -Recurse -Force -ErrorAction SilentlyContinue

  Invoke-NativeChecked 'flutter' @('pub','get') $current
  Write-Host 'Gate 6/7: flutter build windows --release'
  Invoke-NativeChecked 'flutter' @('build','windows','--release') $current
  $exe = Join-Path $current 'build\windows\x64\runner\Release\english_acquisition_app.exe'
  if (-not (Test-Path $exe)) { throw 'Release executable was not created.' }

  Write-Host 'Gate 7/7: application smoke launch'
  $smoke = Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe) -PassThru
  Start-Sleep -Seconds 8
  if ($smoke.HasExited -and $smoke.ExitCode -ne 0) {
    throw "Application smoke test failed with exit code $($smoke.ExitCode)"
  }
  if (-not $smoke.HasExited) { Stop-Process -Id $smoke.Id -Force }

  & (Join-Path $current 'scripts\install_desktop_shortcuts.ps1')
  Remove-Item $rollback -Recurse -Force -ErrorAction SilentlyContinue
  Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe)
  Write-Host 'UPDATE SUCCESS - ALL V7 RELEASE GATES PASSED' -ForegroundColor Green
} catch {
  Write-Host 'UPDATE FAILED. Restoring source, build, and user data.' -ForegroundColor Red
  Write-Host $_.Exception.Message -ForegroundColor Red
  if (Test-Path $rollback) {
    Remove-Item $current -Recurse -Force -ErrorAction SilentlyContinue
    robocopy $rollback $current /MIR /R:1 /W:1 | Out-Host
  }
  if (Test-Path $dataBackup) {
    Remove-Item $runtime -Recurse -Force -ErrorAction SilentlyContinue
    robocopy $dataBackup $runtime /MIR /R:1 /W:1 | Out-Host
  }
  $oldExe = Join-Path $current 'build\windows\x64\runner\Release\english_acquisition_app.exe'
  if (Test-Path $oldExe) {
    Start-Process -FilePath $oldExe -WorkingDirectory (Split-Path $oldExe)
  }
  Write-Host 'ROLLBACK SUCCESS' -ForegroundColor Yellow
  Write-Host "Transcript log: $transcriptLog" -ForegroundColor Yellow
  Write-Host "Native tools log: $nativeLog" -ForegroundColor Yellow
  Read-Host 'Press Enter to close'
} finally {
  try { Stop-Transcript | Out-Null } catch {}
  Remove-Item $stage,$rollback -Recurse -Force -ErrorAction SilentlyContinue
}
