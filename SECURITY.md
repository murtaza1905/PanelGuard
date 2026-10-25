# Security Policy

## Supported versions

Only the latest release on the [Releases](https://github.com/murtaza1905/PanelGuard/releases/latest) page receives fixes. Please update before reporting a problem.

## Reporting a vulnerability

Please do **not** open a public issue for security problems.

Email **muratonurcu@outlook.com** with:

- a description of the issue and its impact,
- steps to reproduce or a proof of concept,
- the PanelGuard version and macOS version you tested on.

You will receive an acknowledgement within 7 days. Once the issue is confirmed, a fix is prepared and published as a new release, and the report is credited in `CHANGELOG.md` unless you prefer to stay anonymous.

## Security model

- PanelGuard needs no special permissions and never asks for any. It adjusts the display gamma table through public CoreGraphics APIs and puts the display to sleep through `pmset displaysleepnow`, which any user may run.
- The original gamma table is restored when the filter is turned off and when the app quits.
- There is no network code, no privileged helper and no background daemon; the app is a single process in the menu bar.
- Releases are built by GitHub Actions from the tagged commit; the workflow is in `.github/workflows/release.yml` and every build log is public.

## Verifying downloads

Every release ships a `SHA256SUMS.txt` file. To verify a download:

```bash
cd ~/Downloads
shasum -a 256 -c SHA256SUMS.txt --ignore-missing
```
