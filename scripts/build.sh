#!/bin/bash
# Builds PanelGuard as a universal (x86_64 + arm64) app bundle with the Swift
# compiler bundled in Xcode. No Homebrew, XcodeGen or other tooling is needed.
#
# Output: build/PanelGuard.app (ad-hoc signed)
# To install and launch the result, run ./scripts/install.sh instead.
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

VERSION="$(tr -d '[:space:]' < VERSION)"
BUILD_NUMBER="$(tr -d '[:space:]' < BUILD)"
APP="build/PanelGuard.app"
MACOS_DIR="$APP/Contents/MacOS"
RES_DIR="$APP/Contents/Resources"

echo "==> Building PanelGuard $VERSION ($BUILD_NUMBER) — universal: x86_64 + arm64"
rm -rf "$APP" build/obj
mkdir -p "$MACOS_DIR" "$RES_DIR" build/obj

for ARCH in x86_64 arm64; do
    xcrun swiftc \
        -O \
        -target "${ARCH}-apple-macos12.0" \
        -framework AppKit \
        -framework CoreGraphics \
        -module-name PanelGuard \
        -o "build/obj/PanelGuard-$ARCH" \
        Sources/PanelGuard/*.swift
done

lipo -create build/obj/PanelGuard-x86_64 build/obj/PanelGuard-arm64 -output "$MACOS_DIR/PanelGuard"
rm -rf build/obj

echo "==> Adding resources"
cp Resources/MenuBarIcon.png Resources/MenuBarIcon@2x.png Resources/PrivacyInfo.xcprivacy "$RES_DIR/"
if command -v iconutil >/dev/null 2>&1; then
    iconutil -c icns Resources/AppIcon.iconset -o "$RES_DIR/AppIcon.icns"
else
    echo "iconutil not found; skipping app icon." >&2
fi

sed -e "s/__VERSION__/$VERSION/g" -e "s/__BUILD__/$BUILD_NUMBER/g" Resources/Info.plist > "$APP/Contents/Info.plist"
echo "APPL????" > "$APP/Contents/PkgInfo"

echo "==> Signing (ad-hoc)"
codesign --force --sign - "$APP"

echo
echo "Built: $APP"
lipo -archs "$MACOS_DIR/PanelGuard"
