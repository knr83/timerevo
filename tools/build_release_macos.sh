#!/bin/bash
# Build Timerevo for macOS and create a distributable package.
# Run on macOS from project root: ./tools/build_release_macos.sh

set -e
project_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$project_root"

# Get version from pubspec
version=$(grep -E '^version:\s*' pubspec.yaml | sed -E 's/version:\s*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
if [ -z "$version" ]; then
  version="0.3.0"
fi

package_name="timerevo-${version}-macos"
build_dir="build/macos/Build/Products/Release"
app_bundle="timerevo.app"
out_dir="dist/${package_name}"
zip_path="dist/${package_name}.zip"

echo "Building Timerevo $version..."
flutter build macos

if [ ! -d "${build_dir}/${app_bundle}" ]; then
  echo "Build output not found: ${build_dir}/${app_bundle}"
  exit 1
fi

echo "Preparing package..."
rm -rf dist
mkdir -p "$out_dir"

# Copy app bundle
cp -r "${build_dir}/${app_bundle}" "$out_dir/"

# Ensure no DB files in package (DB lives in ~/Library/Application Support/timerevo/, created on first run)
find "$out_dir" -type f \( -name "*.sqlite" -o -name "*.sqlite-wal" -o -name "*.sqlite-shm" \) -delete 2>/dev/null || true

# Copy user guides
cp USER_GUIDE_EN.md USER_GUIDE_RU.md USER_GUIDE_DE.md "$out_dir/"

# Create zip
echo "Creating archive..."
(cd dist && zip -r "${package_name}.zip" "$package_name")
mv "dist/${package_name}.zip" "$zip_path"

echo ""
echo "Done."
echo "  Folder: $project_root/$out_dir"
echo "  Zip:    $project_root/$zip_path"
echo ""
echo "Share the zip. Users unpack it and open timerevo.app."
echo "Package contains no DB; each user gets a fresh DB in ~/Library/Application Support/timerevo/ on first run."
