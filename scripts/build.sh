#!/bin/bash
# Builds PanelGuard with the Swift compiler bundled in Xcode, installs it to
# /Applications and launches it. No Homebrew, XcodeGen or other tooling needed.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Checking Xcode"
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Xcode not found. Install Xcode from the App Store, open it once, then run:" >&2
    echo "    sudo xcode-select -s /Applications/Xcode.app" >&2
    exit 1
fi
if ! xcrun -f swiftc >/dev/null 2>&1; then
    echo "swiftc not found. Open Xcode once to accept the license, or run: sudo xcodebuild -license accept" >&2
    exit 1
fi

ARCH="$(uname -m)"
VERSION="$(cat VERSION)"
APP="build/PanelGuard.app"
MACOS_DIR="$APP/Contents/MacOS"
RES_DIR="$APP/Contents/Resources"

echo "==> Building PanelGuard $VERSION ($ARCH)"
rm -rf build
mkdir -p "$MACOS_DIR" "$RES_DIR"

xcrun swiftc \
    -O \
    -target "${ARCH}-apple-macos12.0" \
    -framework AppKit \
    -framework CoreGraphics \
    -module-name PanelGuard \
    -o "$MACOS_DIR/PanelGuard" \
    Sources/PanelGuard/*.swift

echo "==> Adding icons"
cp Resources/MenuBarIcon.png Resources/MenuBarIcon@2x.png "$RES_DIR/"
if command -v iconutil >/dev/null 2>&1; then
    iconutil -c icns Resources/AppIcon.iconset -o "$RES_DIR/AppIcon.icns"
else
    echo "iconutil not found; skipping app icon." >&2
fi

sed "s/__VERSION__/$VERSION/g" Resources/Info.plist > "$APP/Contents/Info.plist"
echo "APPL????" > "$APP/Contents/PkgInfo"

echo "==> Signing (ad-hoc)"
codesign --force --sign - "$APP" >/dev/null 2>&1 || true

echo "==> Installing to /Applications"
if [ -d /Applications/PanelGuard.app ]; then
    osascript -e 'quit app "PanelGuard"' >/dev/null 2>&1 || true
    sleep 1
    rm -rf /Applications/PanelGuard.app
fi
cp -R "$APP" /Applications/PanelGuard.app
touch /Applications/PanelGuard.app
xattr -dr com.apple.quarantine /Applications/PanelGuard.app 2>/dev/null || true

echo "==> Launching"
open /Applications/PanelGuard.app

cat <<'EOF'

PanelGuard is running in the menu bar.
Menu: White Softening Filter · Intensity · Sleep Display When Idle · Delay · Quit

To launch at login:
  System Settings → General → Login Items → + → /Applications/PanelGuard.app
EOF
