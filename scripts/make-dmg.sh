#!/bin/bash
# Builds PanelGuard (via build.sh) and packages it as a DMG for GitHub Releases.
set -euo pipefail

cd "$(dirname "$0")/.."
./scripts/build.sh

VERSION="$(cat VERSION)"
STAGING="build/dmg"
OUT="build/PanelGuard-$VERSION.dmg"

rm -rf "$STAGING" "$OUT"
mkdir -p "$STAGING"
cp -R build/PanelGuard.app "$STAGING/"
ln -s /Applications "$STAGING/Applications"

hdiutil create \
    -volname "PanelGuard $VERSION" \
    -srcfolder "$STAGING" \
    -ov -format UDZO \
    "$OUT" >/dev/null

rm -rf "$STAGING"
echo
echo "Disk image: $OUT"
