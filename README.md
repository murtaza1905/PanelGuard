<p align="center"><img src="docs/icon.png" width="128" alt="PanelGuard icon"></p>

<h1 align="center">PanelGuard</h1>

<p align="center">A tiny macOS menu bar app that helps reduce image retention on IPS displays.</p>

<p align="center">
  <a href="https://github.com/murtaza1905/PanelGuard/actions/workflows/ci.yml"><img src="https://github.com/murtaza1905/PanelGuard/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/murtaza1905/PanelGuard/releases/latest"><img src="https://img.shields.io/github/v/release/murtaza1905/PanelGuard?display_name=tag" alt="Latest release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/macOS-12%2B-black" alt="macOS 12 or later">
  <img src="https://img.shields.io/badge/Intel%20%7C%20Apple%20Silicon-universal-black" alt="Universal binary">
</p>

Image retention (ghosting, burn‑in‑like afterimages) shows up on IPS panels — typically an iMac display — once the panel has warmed up and bright, static windows have been sitting in the same place for a while. PanelGuard does two things against it, and nothing else:

- **White Softening Filter** — lowers the display's peak white by 8 / 12 / 16 % through the display gamma table. Blacks stay black, contrast of normal content is barely affected, and because it is a gamma change rather than an overlay window it costs zero GPU time and never shows up in screenshots.
- **Sleep Display When Idle** — puts the display to sleep after 2 / 3 / 5 / 10 minutes without keyboard or mouse input, well before the system screen saver would. A sleeping panel cools down and its liquid crystals relax; a black window would keep the backlight on and the panel warm.

No windows, no Dock icon, no background rendering, no permission prompts.

<!-- Screenshots: add images to docs/screenshots/ and reference them here. -->

## What it does not do

Image retention on IPS panels is a physical, temperature‑related effect. Software can reduce how often it happens and how long it lasts; it cannot repair a panel. PanelGuard deliberately does **not** include pixel “scrubbers” or noise animations: they keep the GPU busy, heat the machine and work against the goal.

## Requirements

- macOS 12 Monterey or later
- Intel or Apple Silicon (one universal binary)
- Xcode, only if you build from source — the prebuilt release needs nothing

## Install

### Download

1. Get `PanelGuard-<version>.dmg` from the [latest release](https://github.com/murtaza1905/PanelGuard/releases/latest) and drag **PanelGuard.app** to **Applications**.
2. The app is ad-hoc signed, not notarized. On first launch right-click the app › **Open**. If macOS reports the app as damaged, run:

   ```bash
   xattr -dr com.apple.quarantine /Applications/PanelGuard.app
   ```

3. Every release ships `SHA256SUMS.txt`; verify with `shasum -a 256 -c SHA256SUMS.txt --ignore-missing`.

### Build from source

Only Xcode is required — no Homebrew, XcodeGen or other tooling.

```bash
git clone https://github.com/murtaza1905/PanelGuard.git
cd PanelGuard
./scripts/install.sh
```

The script compiles a universal binary with the Swift compiler bundled in Xcode, installs the app to `/Applications` and launches it. Run the same command again to update.

```bash
./scripts/build.sh        # build only → build/PanelGuard.app
./scripts/install.sh      # build, install to /Applications, launch
./scripts/make-dmg.sh     # build and package → dist/PanelGuard-<version>.dmg
./scripts/uninstall.sh    # remove the app and its settings
```

## Usage

Click the monitor icon in the menu bar:

| Item | Effect |
|---|---|
| White Softening Filter | Toggle the gamma filter on/off |
| Intensity | Light (8 %) · Medium (12 %) · Strong (16 %) |
| Sleep Display When Idle | Toggle the idle trigger on/off |
| Delay | 2 · 3 · 5 · 10 minutes |
| About PanelGuard… | Version, developer contact, source code |
| Quit | Restores the original gamma and exits |

Settings persist between launches. The filter is re‑applied automatically after sleep/wake and display changes. The interface follows the system language (English, Turkish).

To start PanelGuard at login: System Settings → General → Login Items → **+** → `/Applications/PanelGuard.app`.

## How it works

- `GammaFilter.swift` reads each display's current transfer table with `CGGetDisplayTransferByTable`, scales it and writes it back with `CGSetDisplayTransferByTable`. `CGDisplayRestoreColorSyncSettings` restores the ColorSync profile on quit.
- `IdleMonitor.swift` polls `CGEventSource.secondsSinceLastEventType` once per second and runs `pmset displaysleepnow` when the threshold is reached.
- `AppDelegate.swift` owns the `NSStatusItem` menu and re‑applies the filter on `didWakeNotification` / `didChangeScreenParametersNotification`.

## Privacy

PanelGuard has no network access, no analytics and no accounts. It stores four preferences in its own user defaults and nothing else. See [PRIVACY.md](PRIVACY.md).

## Project layout

```
Sources/PanelGuard/        AppKit app: AppDelegate, GammaFilter, IdleMonitor, Settings, L10n, AboutPanel
Resources/                 Info.plist, PrivacyInfo.xcprivacy, app icon set, menu bar icon
scripts/                   build.sh · install.sh · make-dmg.sh · uninstall.sh
.github/workflows/         ci.yml (build check) · release.yml (tag → DMG + ZIP + checksums → GitHub Release)
VERSION, BUILD             Marketing version and build number stamped into Info.plist
docs/                      README assets
```

## Development

- Build check on every push and pull request: [CI](https://github.com/murtaza1905/PanelGuard/actions/workflows/ci.yml).
- Releases are produced by the [Release workflow](.github/workflows/release.yml) from a `v*` tag; see [CONTRIBUTING.md](CONTRIBUTING.md) for the exact steps.
- Changes are tracked in [CHANGELOG.md](CHANGELOG.md).

## Contributing and support

- Bugs and feature ideas: [Issues](https://github.com/murtaza1905/PanelGuard/issues) (templates are provided).
- Pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).
- Security problems: see [SECURITY.md](SECURITY.md) — please do not open a public issue.

## License

PanelGuard is released under the [MIT License](LICENSE). It contains no third-party code.

## Author

Murat Onurcu — [muratonurcu@outlook.com](mailto:muratonurcu@outlook.com)
