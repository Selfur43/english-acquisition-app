$ErrorActionPreference='Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '..'))
Remove-Item '.\build\windows' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item '.\.dart_tool\flutter_build' -Recurse -Force -ErrorAction SilentlyContinue
flutter pub get
if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
dart format lib test tool
if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
flutter analyze
if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
flutter test
if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
flutter build windows --release
if($LASTEXITCODE -ne 0){
  Remove-Item '.\build\windows' -Recurse -Force -ErrorAction SilentlyContinue
  flutter pub get
  flutter build windows --release
  if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
}
& '.\scripts\install_desktop_shortcut.ps1'
Start-Process '.\build\windows\x64\runner\Release\english_acquisition_app.exe'
