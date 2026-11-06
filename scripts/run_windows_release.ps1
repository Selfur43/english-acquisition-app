$ErrorActionPreference='Stop'
$exe='.\build\windows\x64\runner\Release\english_acquisition_app.exe'
if(-not(Test-Path $exe)){
  flutter build windows --release
  if($LASTEXITCODE -ne 0){
    Remove-Item '.\build\windows' -Recurse -Force -ErrorAction SilentlyContinue
    flutter pub get
    flutter build windows --release
    if($LASTEXITCODE -ne 0){throw 'Windows release build failed after clean retry.'}
  }
}
Start-Process -FilePath $exe
