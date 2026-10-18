<p align="center"><img src="docs/icon.png" width="96" alt="PanelGuard icon"></p>

# PanelGuard

A tiny macOS menu bar app that helps reduce **image retention** (ghosting / burn‑in‑like afterimages) on IPS panels — typically an iMac display that has warmed up and starts holding the outline of static, bright windows.

It does two things, and nothing else:

- **White Softening Filter** — lowers the display's peak white by 8 / 12 / 16 % through the display gamma table. Blacks stay black, contrast of normal content is barely affected, and because it is a gamma change rather than an overlay window, it costs zero GPU time and never shows up in screenshots.
- **Sleep Display When Idle** — puts the display to sleep after 2 / 3 / 5 / 10 minutes without keyboard or mouse input, well before the system screen saver would. A sleeping panel cools down and its liquid crystals relax; a black window would keep the backlight on and the panel warm.

No windows, no Dock icon, no background rendering, no permissions prompt.

## What it does not do

Image retention on IPS panels is a physical, temperature‑related effect. Software can reduce how often it happens and how long it lasts; it cannot repair a panel. PanelGuard deliberately does **not** include pixel “scrubbers” or noise animations: they keep the GPU busy, heat the machine, and work against the goal.

## Requirements

- macOS 12 Monterey or newer
- Intel or Apple Silicon
- Xcode (only to build from source; the prebuilt release needs nothing)
- Builds are universal: one app runs natively on Intel and Apple Silicon

## Download

Prebuilt universal (Intel + Apple Silicon) disk image: **[Releases](https://github.com/murtaza1905/PanelGuard/releases/latest)** → `PanelGuard-<version>.dmg`. Open it, drag `PanelGuard.app` to Applications, then right‑click → Open on first launch (the app is self‑signed). If macOS reports it as damaged:

```bash
xattr -dr com.apple.quarantine /Applications/PanelGuard.app
```

## Build from source

```bash
git clone https://github.com/murtaza1905/PanelGuard.git
cd PanelGuard
./scripts/build.sh
```

The script compiles a universal binary (Intel + Apple Silicon) with the Swift compiler bundled in Xcode, installs to `/Applications` and launches the app. No Homebrew or other tooling is required. `./scripts/make-dmg.sh` additionally produces `build/PanelGuard-<version>.dmg` for distribution.

## Usage

Click the monitor icon in the menu bar:

| Item | Effect |
|---|---|
| White Softening Filter | Toggle the gamma filter on/off |
| Intensity | Light (8 %) · Medium (12 %) · Strong (16 %) |
| Sleep Display When Idle | Toggle the idle trigger on/off |
| Delay | 2 · 3 · 5 · 10 minutes |
| Quit | Restores the original gamma and exits |

Settings persist between launches. The filter is re‑applied automatically after sleep/wake and display changes. The UI follows the system language (English, Turkish).

To start PanelGuard at login: System Settings → General → Login Items → **+** → `/Applications/PanelGuard.app`.

## How it works

- `GammaFilter.swift` reads each display's current transfer table with `CGGetDisplayTransferByTable`, scales it, and writes it back with `CGSetDisplayTransferByTable`. `CGDisplayRestoreColorSyncSettings` restores the ColorSync profile on quit.
- `IdleMonitor.swift` polls `CGEventSource.secondsSinceLastEventType` once per second and runs `pmset displaysleepnow` when the threshold is reached.
- `AppDelegate.swift` owns the `NSStatusItem` menu and re‑applies the filter on `didWakeNotification` / `didChangeScreenParametersNotification`.

## License

MIT — see [LICENSE](LICENSE).
