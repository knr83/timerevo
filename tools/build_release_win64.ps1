# Build Timerevo for Windows and create a distributable zip.
# Run from project root: .\tools\build_release_win64.ps1

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Get version from pubspec
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -match 'version:\s*(\d+\.\d+\.\d+)') {
    $version = $Matches[1]
} else {
    $version = "2026.3.2"
}

$packageName = "timerevo-${version}-win64"
$buildDir = "build\windows\x64\runner\Release"
$outDir = "dist\$packageName"
$zipPath = "dist\$packageName.zip"

Write-Host "Building Timerevo $version..." -ForegroundColor Cyan
flutter build windows

if (-not (Test-Path $buildDir)) {
    Write-Host "Build output not found: $buildDir" -ForegroundColor Red
    exit 1
}

Write-Host "Preparing package..." -ForegroundColor Cyan
if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

# Copy build output
Copy-Item -Path "$buildDir\*" -Destination $outDir -Recurse -Force

# Ensure no DB files in package (DB lives in %LOCALAPPDATA%\timerevo\, created on first run)
Get-ChildItem -Path $outDir -Recurse -Include "*.sqlite", "*.sqlite-wal", "*.sqlite-shm" -File -ErrorAction SilentlyContinue | Remove-Item -Force

# Copy user guides
Copy-Item -Path "USER_GUIDE_EN.md" -Destination $outDir -Force
Copy-Item -Path "USER_GUIDE_RU.md" -Destination $outDir -Force
Copy-Item -Path "USER_GUIDE_DE.md" -Destination $outDir -Force

# Create zip
Write-Host "Creating archive..." -ForegroundColor Cyan
Compress-Archive -Path $outDir -DestinationPath $zipPath -Force

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "  Folder: $projectRoot\$outDir" -ForegroundColor Gray
Write-Host "  Zip:    $projectRoot\$zipPath" -ForegroundColor Gray
Write-Host ""
Write-Host "Send the zip to the user. They unpack it and run timerevo.exe." -ForegroundColor Yellow
Write-Host "Package contains no DB; each user gets a fresh DB in %LOCALAPPDATA%\timerevo\ on first run." -ForegroundColor Gray
