# Changelog

All notable changes to Sticky Mark are documented here. The newest version is first.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2026-11-03

### Added

- **Rotate shortcut (⌃⌥R).** Turns the flag 90 degrees clockwise around its center: left, up, right, down.
- **Terminal control.** The script now loads `hs.ipc`, so the `hs` command can reload the configuration and check the flag from Terminal.

### Changed

- The arrow shape is now built by the `arrowShape(n)` function, instead of a fixed list of points, so it can be drawn in any direction.

## [1.0.0] - 2026-11-02

### Added

- Floating, semi-transparent arrow flag that stays on top of all windows, on every desktop.
- Drag to move.
- ⌃⌥↓ and ⌃⌥↑ to move one step down or up, with key repeat.
- ⌃⌥F to hide the flag, or show it next to the mouse pointer.
- ⌃⌥C to cycle through pink, blue, yellow, and green.

[1.1.0]: https://github.com/HartTx/sticky-mark/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/HartTx/sticky-mark/releases/tag/v1.0.0
