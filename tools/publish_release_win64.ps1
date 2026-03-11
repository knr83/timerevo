# Create GitHub Release for Timerevo. CI builds and uploads all platform assets.
# Run from project root: .\tools\publish_release_win64.ps1
# Prerequisites: create .cursor/RELEASE_NOTES.md with release notes before running.
# GitHub Actions (.github/workflows/release-assets.yml) builds Windows, Linux, macOS and uploads them.

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Get version from pubspec
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -match 'version:\s*(\d+\.\d+\.\d+)') {
    $version = $Matches[1]
} else {
    $version = "2026.3.1"
}

$notesFile = ".cursor\RELEASE_NOTES.md"

if (-not (Test-Path $notesFile)) {
    Write-Host ".cursor\RELEASE_NOTES.md not found. Create it before publishing." -ForegroundColor Red
    exit 1
}

$tag = "v$version"
Write-Host "Creating release $tag on GitHub (CI will build and upload all platform assets)..." -ForegroundColor Cyan
gh release create $tag --notes-file $notesFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Release $tag created. GitHub Actions will add Windows, Linux, and macOS assets." -ForegroundColor Green
} else {
    Write-Host "gh release create failed (exit code $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}
