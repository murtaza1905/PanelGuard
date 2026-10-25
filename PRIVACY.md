# Privacy Policy

**PanelGuard** — last updated 25 October 2026

PanelGuard is a free, open-source macOS application developed by Murat Onurcu. This policy describes what the application does with data on your Mac.

## Summary

PanelGuard does not collect, store, transmit or share any personal data. It has no user accounts, no analytics, no advertising, no crash reporting service and no network access at runtime.

## Data stored on your Mac

- Four preferences in the application's user defaults (`com.muratonurcu.PanelGuard`): whether the filter is on, its intensity, whether idle display sleep is on and the delay. They can be removed with `scripts/uninstall.sh` or `defaults delete com.muratonurcu.PanelGuard`.
- PanelGuard reads the time since the last keyboard or mouse event to detect idleness. It does not read, log or store the events themselves.

All of this stays on your Mac. Nothing is uploaded anywhere.

## Data that leaves your Mac

None. PanelGuard never opens a network connection. It does not check for updates; new versions are announced only on the GitHub Releases page.

## Permissions

PanelGuard requests no permissions: no Accessibility, no Screen Recording, no Full Disk Access, no notifications.

## Third-party components

None. PanelGuard contains no third-party code, SDKs or services.

## Children's privacy

PanelGuard does not collect data from anyone, including children.

## Changes to this policy

Changes are recorded in this file and in `CHANGELOG.md`. The version history of this document is available in the repository.

## Contact

Murat Onurcu — muratonurcu@outlook.com
