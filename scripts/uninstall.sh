#!/bin/bash
# Quits PanelGuard, removes the app from /Applications and deletes its settings.
set -uo pipefail

echo "==> Quitting PanelGuard"
osascript -e 'quit app "PanelGuard"' >/dev/null 2>&1 || true
pkill -x PanelGuard >/dev/null 2>&1 || true
sleep 1

echo "==> Removing application"
rm -rf /Applications/PanelGuard.app
rm -rf ~/Applications/PanelGuard.app

echo "==> Removing settings"
for domain in com.muratonurcu.PanelGuard com.panelguard.app; do
    defaults delete "$domain" >/dev/null 2>&1 || true
done

echo "==> Removing build output"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "$SCRIPT_DIR/build" "$SCRIPT_DIR/dist"

cat <<'EOF'

PanelGuard has been removed. The display gamma was restored when the app quit.
If PanelGuard was added to Login Items, remove the entry under
System Settings → General → Login Items.
EOF
