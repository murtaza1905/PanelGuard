# Changelog

All notable changes to PanelGuard are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-10-25

### Added
- **About PanelGuard…** menu item opening the standard About window with version, developer contact and source link (English and Turkish).
- `scripts/install.sh` (build, install to /Applications, launch) and `scripts/uninstall.sh` (remove app and settings).
- Privacy manifest (`PrivacyInfo.xcprivacy`) bundled with the app.
- Continuous integration build on every push and pull request; tag-triggered release workflow that builds the universal app, packages `.dmg` and `.zip`, writes `SHA256SUMS.txt` and publishes the GitHub Release.
- `CONTRIBUTING.md`, `SECURITY.md`, `PRIVACY.md`, issue and pull request templates.

### Changed
- Bundle identifier is now `com.muratonurcu.PanelGuard` (was `com.panelguard.app`). Existing settings are migrated automatically on first launch. If PanelGuard was added to Login Items, re-add it once.
- `scripts/build.sh` now only builds `build/PanelGuard.app`; installing and launching moved to `scripts/install.sh`.
- `scripts/make-dmg.sh` writes to `dist/`, lays out the disk image window (app icon → Applications) and sets the volume icon.
- Build number (`BUILD_NUMBER` file) is now stamped into `CFBundleVersion` and increases with every release.
- Application category, copyright string and README updated.

## [1.0.2] - 2026-10-18

### Changed
- App icon redrawn on the standard macOS icon grid.

## [1.0.1] - 2026-10-18

### Added
- Universal binary (x86_64 + arm64).
- `scripts/make-dmg.sh` for disk image packaging.

## [1.0.0] - 2026-10-18

### Added
- Initial release: white softening filter (8 / 12 / 16 %) through the display gamma table, display sleep after 2 / 3 / 5 / 10 idle minutes, menu bar interface in English and Turkish.

[Unreleased]: https://github.com/murtaza1905/PanelGuard/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/murtaza1905/PanelGuard/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/murtaza1905/PanelGuard/releases/tag/v1.0.2
[1.0.1]: https://github.com/murtaza1905/PanelGuard/commits/main
[1.0.0]: https://github.com/murtaza1905/PanelGuard/commits/main
