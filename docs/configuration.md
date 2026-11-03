# Configure Sticky Mark

This guide shows you how to change Sticky Mark's size, colors, step distance, and shortcuts. Every change follows the same pattern: edit one line in the script, save, and reload.

## Edit and reload the script

> [!TIP]
> Before you make big changes, copy `init.lua` somewhere safe. If a change breaks the script, you can put the copy back.

1. Open the script in TextEdit:

   ```bash
   open -e ~/.hammerspoon/init.lua
   ```

2. Make your change and save the file.
3. Click the Hammerspoon icon in the menu bar, then click **Reload Config**.

   If the change worked, the "Post-it flag ready" message appears. If it didn't, Hammerspoon opens its Console with an error. See [Troubleshooting](troubleshooting.md).

Reloading resets the flag to its starting position, color, and direction.

## Settings reference

| Setting | Default | What it controls |
| --- | --- | --- |
| `STEP` | `28` | Pixels the flag moves per arrow-key press. |
| `W` | `70` | Flag length in pixels (when pointing left or right). |
| `H` | `28` | Flag thickness in pixels (when pointing left or right). |
| `COLORS` | Pink, blue, yellow, green | Colors that ⌃⌥C cycles through. The first one is the starting color. |
| `alpha` | `0.85` | Opacity, from `0` (invisible) to `1` (solid). Appears twice: in the canvas setup and in `nextColor`. |
| `mods` | `{ "ctrl", "alt" }` | The modifier keys used by every shortcut. |

## Change the step distance

If one press of ⌃⌥↓ moves the flag past the next step, make `STEP` smaller. If you need several presses per step, make it bigger.

```lua
local STEP = 40          -- how far one key press moves the flag, in pixels
```

A good way to choose: measure the distance between two steps on your screen with **Command + Shift + 4**. macOS shows the pixel size as you drag. (On a Retina screen, divide that number by 2.)

## Change the size

Change `W` (length) and `H` (thickness). The arrow point and rotation adjust automatically.

```lua
local W, H = 100, 36      -- flag size
```

## Change the colors

Edit the `COLORS` list. Each color is a hex code. You can have as many as you want.

```lua
local COLORS = { "#FF2D95", "#FF8C00", "#9B59B6" }
```

To start with a different color, put it first.

## Change the opacity

Change `alpha = 0.85` in **both** places it appears: the `appendElements` block and the `nextColor` function. If you only change one, the flag changes opacity the first time you press ⌃⌥C.

## Change the keyboard shortcuts

To change the modifier keys for all shortcuts, edit `mods`. Valid names are `"cmd"`, `"alt"` (Option), `"ctrl"`, and `"shift"`.

```lua
local mods = { "cmd", "ctrl" }
```

To change a single key, edit its `hs.hotkey.bind` line. For example, to hide and show the flag with ⌃⌥H instead of ⌃⌥F:

```lua
hs.hotkey.bind(mods, "H", toggle)
```

> [!WARNING]
> Avoid shortcuts that macOS or your apps already use. For example, ⌃↓ and ⌃↑ (without Option) open App Exposé and Mission Control.

After changing shortcuts, update [Keyboard shortcuts](keyboard-shortcuts.md) so it stays accurate.

## Ideas for future work

These need more than a one-line edit. Issues and pull requests are welcome:

- **Remember position and color** after a restart, using `hs.settings`.
- **Move sideways** with ⌃⌥← and ⌃⌥→.
- **Add a second flag** for marking two places at once.
- **Show a step number** on the flag.

Back to [README](../README.md).
