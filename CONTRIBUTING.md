# Contributing to PanelGuard

Thank you for taking the time to contribute. Bug reports, feature ideas, documentation fixes and code are all welcome.

## Reporting a bug

- Open an issue with the **Bug report** template.
- Include your macOS version, whether the Mac is Intel or Apple Silicon, the PanelGuard version (shown in the About window) and the exact steps to reproduce.
- For display problems, mention the display model (built-in iMac panel, external monitor, several displays) and whether the issue happens after sleep/wake or a display change.

## Suggesting a feature

- Open an issue with the **Feature request** template.
- Describe the problem you are trying to solve before the solution you have in mind.

## Development setup

Xcode is the only requirement; the build uses the Swift compiler bundled with Xcode directly. No Homebrew, XcodeGen or other tooling is needed.

```bash
git clone https://github.com/murtaza1905/PanelGuard.git
cd PanelGuard
./scripts/build.sh          # build/PanelGuard.app
./scripts/install.sh        # build, install to /Applications and launch
```

There is no Xcode project; the app is a handful of Swift files under `Sources/PanelGuard` compiled by `scripts/build.sh`. Open the folder in Xcode or any editor and rebuild with the script.

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep each pull request focused on one change.
3. Make sure the project builds with `./scripts/build.sh` — the CI workflow runs the same check on every pull request.
4. Add a line to the **Unreleased** section of `CHANGELOG.md`.
5. Open the pull request; the template lists what to include.

## Code style

- Swift, following Apple's API Design Guidelines; four-space indentation; no trailing whitespace.
- No new third-party dependencies without prior discussion in an issue.
- Every user-facing string goes through the localization layer (`L10n.swift`) and must be provided in both English and Turkish.
- Shell scripts use `set -euo pipefail` and must run on a clean Mac with only Xcode installed.

## Release process (maintainers)

1. Bump the version (`VERSION` and `BUILD`) and move the **Unreleased** notes in `CHANGELOG.md` under the new version heading.
2. Commit, push to `main` and wait for CI to pass.
3. Tag the commit and push the tag:

   ```bash
   git tag v<version>
   git push origin v<version>
   ```

4. The **Release** workflow builds a universal (Apple Silicon + Intel) app, packages the `.dmg` and `.zip`, writes `SHA256SUMS.txt` and publishes the GitHub Release using the matching `CHANGELOG.md` section as release notes.

## License

By contributing you agree that your contributions are licensed under the [MIT License](LICENSE).
