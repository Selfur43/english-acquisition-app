
$ErrorActionPreference = "Stop"

$source = "C:\Users\forma\Desktop\Projects\english_acquisition_app_phase2_profile_goals"
$staging = "C:\Users\forma\Desktop\Projects\english_acquisition_app_v0.2.1_phase2_verified_source"
$zip = "C:\Users\forma\Desktop\Projects\english_acquisition_app_v0.2.1_phase2_verified_source.zip"

if (-not (Test-Path (Join-Path $source "pubspec.yaml"))) {
    throw "Kaynak proje bulunamadi: $source"
}

Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $zip -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $staging -Force | Out-Null

$sourceDirectories = @("lib", "test", "tool", "scripts", "assets", "docs")

foreach ($directory in $sourceDirectories) {
    $directorySource = Join-Path $source $directory
    $directoryTarget = Join-Path $staging $directory

    if (Test-Path $directorySource) {
        Copy-Item -LiteralPath $directorySource -Destination $directoryTarget -Recurse -Force
    }
}

$windowsSource = Join-Path $source "windows"
$windowsTarget = Join-Path $staging "windows"

if (Test-Path $windowsSource) {
    Copy-Item -LiteralPath $windowsSource -Destination $windowsTarget -Recurse -Force
}

$rootFiles = @(
    ".gitignore",
    "analysis_options.yaml",
    "pubspec.yaml",
    "pubspec.lock",
    "README.md",
    "DEPENDENCY_RULES.md",
    "PHASE1_STATUS.md",
    "PHASE2_PLAN.md",
    "KNOWN_ISSUES.md",
    "WINDOWS_SETUP.md",
    "CHANGELOG.md"
)

foreach ($fileName in $rootFiles) {
    $fileSource = Join-Path $source $fileName
    if (Test-Path $fileSource) {
        Copy-Item -LiteralPath $fileSource -Destination (Join-Path $staging $fileName) -Force
    }
}

$unwantedDirectoryNames = @(
    ".dart_tool",
    "build",
    ".idea",
    ".git",
    "coverage",
    "ephemeral",
    "Debug",
    "Release",
    "RelWithDebInfo"
)

Get-ChildItem -LiteralPath $staging -Recurse -Directory -Force |
    Where-Object { $_.Name -in $unwantedDirectoryNames } |
    Sort-Object { $_.FullName.Length } -Descending |
    ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }

$unwantedExtensions = @(".exe", ".dll", ".pdb", ".ilk", ".obj", ".lib", ".exp")

Get-ChildItem -LiteralPath $staging -Recurse -File -Force |
    Where-Object {
        $_.Name -like "verification_*.txt" -or
        $_.Name -eq "flutter_project_dump.txt" -or
        $_.Extension -in $unwantedExtensions
    } |
    ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
    }

if (-not (Test-Path (Join-Path $staging "pubspec.yaml"))) {
    throw "Temiz kaynak klasorunde pubspec.yaml bulunamadi."
}

Compress-Archive -Path (Join-Path $staging "*") -DestinationPath $zip -CompressionLevel Optimal -Force

if (-not (Test-Path $zip)) {
    throw "ZIP olusturulamadi: $zip"
}

$zipInfo = Get-Item $zip
$sizeMB = [Math]::Round($zipInfo.Length / 1MB, 2)

Write-Host ""
Write-Host "Temiz kaynak ZIP basariyla olusturuldu." -ForegroundColor Green
Write-Host "Dosya: $($zipInfo.FullName)" -ForegroundColor Cyan
Write-Host "Boyut: $sizeMB MB" -ForegroundColor Cyan
Write-Host "Bayt: $($zipInfo.Length)" -ForegroundColor Cyan

if ($zipInfo.Length -ge 25MB) {
    Write-Warning "ZIP hala 25 MB veya daha buyuk. En buyuk dosyalar listeleniyor:"
    Get-ChildItem -LiteralPath $staging -Recurse -File |
        Sort-Object Length -Descending |
        Select-Object -First 20 FullName, Length |
        Format-Table -AutoSize
    exit 2
}

Write-Host "ZIP GitHub web yukleme sinirinin altinda." -ForegroundColor Green
