# Sticky Mark

A floating digital Post-it flag for macOS that marks your place in step-by-step instructions.

![macOS](https://img.shields.io/badge/macOS-15%20Sequoia-black?logo=apple)
![Hammerspoon](https://img.shields.io/badge/Hammerspoon-1.1-orange)
![Lua](https://img.shields.io/badge/Lua-5.4-2C2D72?logo=lua)
![License: MIT](https://img.shields.io/badge/license-MIT-blue)

<!-- Screenshot or GIF of the flag goes here, for example: ![Sticky Mark pointing at a step](docs/images/demo.gif) -->

## Why

When I follow written instructions, I used to stick a Post-it arrow flag on my monitor next to the current step, then move it down as I went. When I looked back at the screen, my eye went straight to the right place.

Sticky Mark does the same thing digitally. A colored arrow floats on top of every window. You park it next to the step you're on, and move it down one step with a keystroke.

## Features

- **Always on top.** Floats above every window, on every desktop.
- **Step-by-step movement.** Moves one line down or up with a shortcut. Hold the keys to keep moving.
- **Drag anywhere.** Click and drag it into place.
- **Hide and summon.** Hides with one shortcut, and comes back next to the mouse pointer.
- **Four colors.** Pink, blue, yellow, and green, like the paper flags.
- **Four directions.** Turns 90 degrees clockwise or counterclockwise, to point at rows or columns.

## Keyboard shortcuts

| Shortcut | Action |
| --- | --- |
| ⌃⌥↓ / ⌃⌥↑ | Move one step down / up |
| ⌃⌥F | Hide, or show at the mouse pointer |
| ⌃⌥C | Cycle colors |
| ⌃⌥R / ⌃⌥E | Turn clockwise / counterclockwise |

⌃⌥ means Control + Option. See [Keyboard shortcuts](docs/keyboard-shortcuts.md) for details and tips.

## Quick start

1. Install [Hammerspoon](https://www.hammerspoon.org):

   ```bash
   brew install --cask hammerspoon
   ```

2. Download the script:

   ```bash
   mkdir -p ~/.hammerspoon && curl -fsSL https://raw.githubusercontent.com/HartTx/sticky-mark/main/init.lua -o ~/.hammerspoon/init.lua
   ```

3. Open Hammerspoon, and turn it on in **System Settings > Privacy & Security > Accessibility**.
4. In the Hammerspoon menu bar icon, click **Reload Config**. A pink arrow appears.

For the full guide, including permissions and uninstalling, see [Installation and setup](docs/installation.md).

## How it works

Sticky Mark is a single [Lua script](init.lua) of about 100 lines that runs inside Hammerspoon:

- An `hs.canvas` draws a five-point arrow polygon at the overlay window level.
- Global `hs.hotkey` bindings move, recolor, hide, and rotate it. Rotation is a quarter-turn coordinate transform applied around the flag's center.
- Dragging uses an `hs.eventtap` that follows the mouse from mouse-down to mouse-up.

Read [How Sticky Mark works](docs/architecture.md) for the full design, including the rotation math and design decisions.

## Documentation

| Document | Read it when you want to… |
| --- | --- |
| [Keyboard shortcuts](docs/keyboard-shortcuts.md) | Look up a shortcut. |
| [Installation and setup](docs/installation.md) | Install it or rebuild it on a new Mac. |
| [How Sticky Mark works](docs/architecture.md) | Understand the design and the code. |
| [Configuration](docs/configuration.md) | Change the size, colors, step distance, or shortcuts. |
| [Troubleshooting](docs/troubleshooting.md) | Fix something that isn't working. |
| [Changelog](CHANGELOG.md) | See what changed in each version. |

## Requirements

- macOS (tested on macOS 15 Sequoia, Apple silicon)
- Hammerspoon 1.1 or later
- Accessibility permission for Hammerspoon

## Built with Claude Code

I designed Sticky Mark around my own workflow and built it with [Claude Code](https://claude.com/claude-code) as a pair programmer. I set the requirements, tested each version on my own setup, and directed the fixes. Claude wrote most of the code and documentation, and it's credited as a co-author on each commit.

## License

[MIT](LICENSE) © 2026 Michael Hart
