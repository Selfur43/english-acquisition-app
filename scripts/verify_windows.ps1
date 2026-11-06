$ErrorActionPreference = 'Stop'
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
dart format --output=none --set-exit-if-changed lib test tool
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
dart run tool/validate_phase1.dart
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter build windows --debug
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter build windows --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host 'Windows verification completed.' -ForegroundColor Green
