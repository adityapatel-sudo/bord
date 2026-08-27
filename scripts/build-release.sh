#!/bin/zsh
set -euo pipefail

project_root="${0:A:h:h}"
archive_path="$project_root/.build/release/bord.xcarchive"
output_dir="$project_root/dist"
app_path="$archive_path/Products/Applications/bord.app"
zip_path="$output_dir/bord-macos-universal.zip"

mkdir -p "${archive_path:h}" "$output_dir"

xcodebuild \
  -project "$project_root/bord.xcodeproj" \
  -scheme bord \
  -configuration Release \
  -destination 'generic/platform=macOS' \
  -archivePath "$archive_path" \
  ARCHS='arm64 x86_64' \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY=- \
  DEVELOPMENT_TEAM= \
  OTHER_SWIFT_FLAGS='-disable-sandbox' \
  archive

codesign --verify --deep --strict "$app_path"
ditto -c -k --sequesterRsrc --keepParent "$app_path" "$zip_path"

echo "Created $zip_path"
