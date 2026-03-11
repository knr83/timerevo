#!/bin/bash
# Build Timerevo for Linux and create a distributable tarball.
# Run from project root: ./tools/build_release_linux.sh

set -e
project_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$project_root"

# Get version from pubspec
version=$(grep -E '^version:\s*' pubspec.yaml | sed -E 's/version:\s*([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
if [ -z "$version" ]; then
  version="0.3.0"
fi

package_name="timerevo-${version}-linux64"
build_dir="build/linux/x64/release/bundle"
out_dir="dist/${package_name}"
tarball_path="dist/${package_name}.tar.gz"

echo "Building Timerevo $version..."
flutter build linux

if [ ! -d "$build_dir" ]; then
  echo "Build output not found: $build_dir"
  exit 1
fi

echo "Preparing package..."
rm -rf dist
mkdir -p "$out_dir"

# Copy build output
cp -r "${build_dir}/"* "$out_dir/"

# Ensure no DB files in package (DB lives in ~/.local/share/timerevo/, created on first run)
find "$out_dir" -type f \( -name "*.sqlite" -o -name "*.sqlite-wal" -o -name "*.sqlite-shm" \) -delete 2>/dev/null || true

# Copy user guides
cp USER_GUIDE_EN.md USER_GUIDE_RU.md USER_GUIDE_DE.md "$out_dir/"

# Create tarball
echo "Creating archive..."
tar -czf "$tarball_path" -C dist "$package_name"

echo ""
echo "Done."
echo "  Folder:  $project_root/$out_dir"
echo "  Tarball: $project_root/$tarball_path"
echo ""
echo "Share the tarball. Users unpack it and run ./timerevo."
echo "Package contains no DB; each user gets a fresh DB in ~/.local/share/timerevo/ on first run."
