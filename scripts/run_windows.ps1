$ErrorActionPreference = 'Stop'
if (-not (Test-Path '.\pubspec.yaml')) {
    throw "Run this script from the project root where pubspec.yaml exists. Current folder: $(Get-Location)"
}
flutter run -d windows --no-enable-impeller
if ($LASTEXITCODE -ne 0) {
    throw "Windows debug run failed with exit code $LASTEXITCODE."
}
