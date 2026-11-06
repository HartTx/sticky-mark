# How Sticky Mark works

This document explains the design of Sticky Mark: what each part does, how the parts fit together, and why it was built this way. For the code itself, see [init.lua](../init.lua).

## Overview

Sticky Mark has no app of its own. It is a script that Hammerspoon loads when it starts. Hammerspoon is a macOS app that exposes system features (windows, drawing, the keyboard, the mouse) to a built-in Lua scripting engine.

When Hammerspoon starts, it runs `~/.hammerspoon/init.lua`. The script:

1. Creates a transparent drawing surface (a *canvas*) on the screen.
2. Draws an arrow shape on that canvas.
3. Sets the canvas to float above every other window.
4. Registers a mouse handler so you can drag the canvas.
5. Registers global keyboard shortcuts (*hotkeys*) that move, hide, recolor, and rotate it.

After that, the script does nothing until you press a shortcut or click the flag. Hammerspoon keeps the canvas and handlers alive in the background.

```
┌──────────────────────── Hammerspoon.app ────────────────────────┐
│                                                                  │
│   init.lua                                                       │
│   ├── postitFlag (hs.canvas) ──── draws the arrow on screen      │
│   │      └── element 1: filled 5-point polygon                   │
│   ├── mouseCallback ──── starts a drag on mouse-down             │
│   │      └── postitDrag (hs.eventtap) ── follows the mouse       │
│   ├── hs.hotkey bindings ── ⌃⌥ ↓ ↑ F C 1-4 R E                  │
│   │      └── nudge / toggle / setColor / nextColor / rotate      │
│   └── hs.ipc ──── lets the `hs` terminal command talk to it      │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Components

### The canvas

The flag is an `hs.canvas` object stored in the global variable `postitFlag`. A canvas is a borderless, transparent window that you can draw shapes on.

Two settings make it behave like a sticky note:

| Setting | Value | Effect |
| --- | --- | --- |
| `level` | `hs.canvas.windowLevels.overlay` | Places the canvas above normal app windows, so it never gets covered. |
| `behavior` | `canJoinAllSpaces`, `stationary`, `fullScreenAuxiliary` | Shows the canvas on every desktop (Space), keeps it still when you switch desktops or open Mission Control, and lets it appear over apps in full-screen mode. |

The variable is **global** on purpose. Lua frees objects that nothing refers to. If `postitFlag` were local, Lua could free it after the script finishes, and the flag would disappear at a random moment. The same applies to `postitDrag`.

### The arrow shape

The arrow is a single canvas element: a closed polygon (`type = "segments"`, `closed = true`) filled with color at 85% opacity. The slight transparency lets you see text under the flag if you place it on top of something.

In its default position, the arrow points left, like a paper flag. It fits in a box 70 pixels wide and 28 pixels tall, and has five corners:

```
        (14,0) ┌───────────────────┐ (70,0)
              ╱                    │
    (0,14)  <                      │
              ╲                    │
       (14,28) └───────────────────┘ (70,28)
```

The point is a right angle because the slanted edges run from the tip at mid-height to points that are half the box height (14 pixels) in from the left edge.

### Rotation

The `arrowShape(n)` function returns the five corner points after turning the arrow clockwise *n* quarter turns, along with the new box width and height.

Screen coordinates start at the top-left corner, and *y* increases downward. In that system, a 90-degree clockwise turn of a point inside a box of width *w* and height *h* is:

```
new x = h − old y
new y = old x
```

The box then swaps dimensions: the new width is the old height, and the new height is the old width. The function applies this formula *n* times.

The `rotate(dir)` function adds `dir` to the turn counter: `1` for clockwise (⌃⌥R) or `−1` for counterclockwise (⌃⌥E). The counter wraps with `% 4`. In Lua, `%` always returns a non-negative result for a positive divisor, so turning counterclockwise from 0 gives 3 (down) rather than −1. A counterclockwise turn is three clockwise turns, so `arrowShape` only needs the clockwise formula. The function then gets the new shape and resizes the canvas around its **center point**. Keeping the center fixed means the flag turns in place instead of jumping sideways.

| `turns` | Direction | Box size |
| --- | --- | --- |
| 0 | Left | 70 × 28 |
| 1 | Up | 28 × 70 |
| 2 | Right | 70 × 28 |
| 3 | Down | 28 × 70 |

### Dragging

Hammerspoon canvases don't support dragging on their own, so Sticky Mark builds it in two stages:

1. **Mouse-down.** The arrow element has `trackMouseDown = true`, so clicking it calls the canvas's `mouseCallback`. The callback records how far the mouse pointer is from the canvas's top-left corner (the *offset*).
2. **Following the mouse.** The callback then starts an `hs.eventtap`, which watches system-wide mouse events. On each `leftMouseDragged` event, it moves the canvas to the mouse position minus the offset. On `leftMouseUp`, it stops itself.

Using the offset keeps the flag from snapping its corner to the pointer when you start dragging. Each handler returns `false`, which passes the mouse event on to macOS unchanged, so other apps aren't affected.

Event taps watch input from every app, so macOS requires **Accessibility** permission for them. That's why dragging doesn't work until you grant it.

### Keyboard shortcuts

`hs.hotkey.bind` registers global shortcuts that work no matter which app is in front. Each shortcut calls one small function:

| Function | What it does |
| --- | --- |
| `nudge(dy)` | Moves the canvas up or down by `dy` pixels. The arrow keys pass `+STEP` or `−STEP`. |
| `toggle()` | Hides the canvas if it's showing. Otherwise, moves it next to the mouse pointer and shows it. |
| `setColor(i)` | Sets the arrow's fill to color number `i` in the `COLORS` list. ⌃⌥1 to ⌃⌥4 call it directly. |
| `nextColor()` | Calls `setColor` with the next color in the list, wrapping from the last back to the first. ⌃⌥C calls it. |
| `rotate(dir)` | Turns the arrow 90 degrees clockwise (`dir = 1`) or counterclockwise (`dir = -1`). See [Rotation](#rotation). |

The color number shortcuts are created in a loop, one for each entry in `COLORS` (up to 9), so adding a color to the list adds its shortcut automatically.

The arrow-key shortcuts pass the same function twice: once as the *pressed* action and once as the *repeat* action. That's what makes the flag keep moving when you hold the keys down.

### Terminal control (`hs.ipc`)

The line `require("hs.ipc")` loads Hammerspoon's inter-process communication module. It lets the `hs` terminal command send Lua code to the running Hammerspoon. This isn't needed to use Sticky Mark. It lets you reload the configuration or check the flag's state from Terminal without clicking anything. For example:

```bash
hs -c 'hs.reload()'
```

## Code map

[`init.lua`](../init.lua) reads top to bottom in this order:

| Section | Purpose |
| --- | --- |
| Header comment | Lists the controls, so the file explains itself. |
| `require("hs.ipc")` | Enables the `hs` command-line tool. |
| `STEP` to `turns` | Settings you can change, plus the current color and direction. |
| `arrowShape` | Builds the arrow's corner points for any direction. |
| `hs.canvas.new` block | Creates the floating window and the arrow. |
| `mouseCallback` block | Moves the flag with the mouse. |
| `nudge`, `toggle`, `setColor`, `nextColor`, `rotate` | One function per action. |
| `hs.hotkey.bind` lines | Connect keys to actions. |
| Last two lines | Show the flag and confirm it loaded. |

### Hammerspoon APIs used

| API | Used for |
| --- | --- |
| [`hs.canvas`](https://www.hammerspoon.org/docs/hs.canvas.html) | Drawing the flag and keeping it on top |
| [`hs.eventtap`](https://www.hammerspoon.org/docs/hs.eventtap.html) | Following the mouse while dragging |
| [`hs.hotkey`](https://www.hammerspoon.org/docs/hs.hotkey.html) | Global keyboard shortcuts |
| [`hs.mouse`](https://www.hammerspoon.org/docs/hs.mouse.html) | Reading the mouse pointer position |
| [`hs.screen`](https://www.hammerspoon.org/docs/hs.screen.html) | Finding the main screen for the starting position |
| [`hs.alert`](https://www.hammerspoon.org/docs/hs.alert.html) | The "ready" message |
| [`hs.ipc`](https://www.hammerspoon.org/docs/hs.ipc.html) | Terminal control |

## Design decisions

| Decision | Reason |
| --- | --- |
| Hammerspoon instead of a native Swift app | No code signing, Xcode project, or build step. Edits take effect on reload. |
| One flag, not several | Matches how the paper flag is used: one marker for "you are here." |
| Fixed step size (28 pixels) | Close to the line height of typical instructions in a browser or document at normal zoom. |
| Vertical-only keyboard movement | Instructions run top to bottom; sideways placement is a one-time drag. |
| 85% opacity | Visible at a glance, but you can still read text under it. |
| Overlay window level | High enough to sit above apps, but below system alerts and the screensaver. |

## Known limitations

- **State isn't saved.** Position, color, and direction reset when Hammerspoon restarts or reloads. The flag always starts pointing left, in pink, near the top middle of the main screen.
- **Toggle position after rotating.** When the flag is pointing up or down, ⌃⌥F places it slightly off center from the mouse pointer, because `toggle()` uses the original box height for its offset.
- **Full-screen apps.** Each full-screen app is its own Space. `canJoinAllSpaces` alone doesn't include those Spaces, which is why version 1.4 added `fullScreenAuxiliary`. Without it, the flag only shows on the regular desktop.
- **Shortcut conflicts.** If another app uses the same ⌃⌥ shortcut, whichever app registered it first usually wins.

Back to [README](../README.md).
