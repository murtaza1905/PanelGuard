#!/bin/bash
# Builds PanelGuard (scripts/build.sh), replaces the copy in /Applications and
# launches it. Run the same command again to update.
set -euo pipefail

cd "$(dirname "$0")/.."
./scripts/build.sh

APP="build/PanelGuard.app"
TARGET="/Applications/PanelGuard.app"

echo "==> Installing to $TARGET"
if [ -d "$TARGET" ]; then
    osascript -e 'quit app "PanelGuard"' >/dev/null 2>&1 || true
    sleep 1
    rm -rf "$TARGET"
fi
cp -R "$APP" "$TARGET"
touch "$TARGET"
xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true

echo "==> Launching"
open "$TARGET"

cat <<'EOF'

PanelGuard is running in the menu bar.
Menu: White Softening Filter · Intensity · Sleep Display When Idle · Delay · About · Quit

To launch at login:
  System Settings → General → Login Items → + → /Applications/PanelGuard.app
EOF
