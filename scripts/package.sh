#!/bin/bash
# Builds PanelGuard (via build.sh) and packages the app as a zip for GitHub Releases.
set -euo pipefail

cd "$(dirname "$0")/.."
./scripts/build.sh

VERSION="$(cat VERSION)"
OUT="build/PanelGuard-$VERSION.zip"
rm -f "$OUT"
ditto -c -k --sequesterRsrc --keepParent build/PanelGuard.app "$OUT"
echo
echo "Release archive: $OUT"
