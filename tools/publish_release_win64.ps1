# Build Timerevo for Windows and publish to GitHub Release.
# Run from project root: .\tools\publish_release_win64.ps1
# Prerequisites: create .cursor\RELEASE_NOTES.md before running.
# GitHub Actions (.github/workflows/release-assets.yml) adds Linux and macOS assets after release creation.

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Build first
& "$PSScriptRoot\build_release_win64.ps1"

# Get version from pubspec
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -match 'version:\s*(\d+\.\d+\.\d+)') {
    $version = $Matches[1]
} else {
    $version = "2026.3.0"
}

$zipPath = "dist\timerevo-${version}-win64.zip"
$notesFile = ".cursor\RELEASE_NOTES.md"

if (-not (Test-Path $zipPath)) {
    Write-Host "Build artifact not found: $zipPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $notesFile)) {
    Write-Host ".cursor\RELEASE_NOTES.md not found. Create it before publishing." -ForegroundColor Red
    exit 1
}

$tag = "v$version"
Write-Host "Publishing release $tag to GitHub..." -ForegroundColor Cyan
gh release create $tag $zipPath --notes-file $notesFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Release $tag published. GitHub Actions will add Linux and macOS assets." -ForegroundColor Green
} else {
    Write-Host "gh release create failed (exit code $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}
