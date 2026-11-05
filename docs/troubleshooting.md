# Troubleshoot Sticky Mark

Find the problem you're seeing, then follow the fix.

## The flag doesn't appear

**Cause:** Hammerspoon isn't running, or the script didn't load.

1. Look for the hammer icon in the menu bar. If it isn't there, open **Hammerspoon** from your Applications folder.
2. Click the hammer icon, then click **Reload Config**.
3. If the flag still doesn't appear, press ⌃⌥F. The flag might be hidden.
4. If nothing happens, click the hammer icon, then click **Console**. Look for red error text, and see [The script shows an error](#the-script-shows-an-error).

## The flag appears, but shortcuts and dragging don't work

**Cause:** Hammerspoon doesn't have Accessibility permission.

1. Open **System Settings > Privacy & Security > Accessibility**.
2. Make sure **Hammerspoon** is turned on.
3. If it's already on, turn it off and on again. macOS sometimes loses track of permission after an app updates.
4. Click the hammer icon, then click **Reload Config**.

## One shortcut doesn't work, but the others do

**Cause:** Another app is using the same shortcut.

1. Quit other apps one at a time and test the shortcut after each, to find the conflict.
2. Change the shortcut in either app. To change it in Sticky Mark, see [Change the keyboard shortcuts](configuration.md#change-the-keyboard-shortcuts).

## I can't find the flag

**Cause:** It was moved off the screen or onto another display.

- Press ⌃⌥F twice. The flag reappears next to your mouse pointer.

## A Stream Deck button doesn't work

**Cause:** The button sends a different key combination than Sticky Mark expects.

1. In the Stream Deck app, select the button and check its **Hotkey** field. It should show Control, Option, and the key, for example ⌃⌥1.
2. If it doesn't, click the field and press the shortcut again on your keyboard.
3. Test the same shortcut on your keyboard. If the keyboard works but the button doesn't, quit and reopen the Stream Deck app.

## The flag disappears over some apps

**Cause:** The app is in full-screen mode, which can hide floating windows.

- Exit full-screen mode (press **Control + Command + F**, or click the green button in the window's corner). Or use the app in a large regular window instead.

## The arrow keys move the flag too far or not far enough

**Cause:** The step size doesn't match the line spacing of what you're reading.

- Change `STEP`. See [Change the step distance](configuration.md#change-the-step-distance).

## The flag is back to pink and pointing left

**Cause:** Hammerspoon restarted or the configuration reloaded. Sticky Mark doesn't save its state yet.

- This is expected. Press a color key (⌃⌥1 to ⌃⌥4), and ⌃⌥R or ⌃⌥E, to get back to the color and direction you want.

## The script shows an error

**Cause:** A typo or formatting problem in `init.lua`.

1. Click the hammer icon, then click **Console**. The error message includes a line number, for example `init.lua:42:`.
2. Open the script and check that line:

   ```bash
   open -e ~/.hammerspoon/init.lua
   ```

3. Common mistakes:
   - A missing comma between items in a list.
   - A missing `end`, closing bracket `}`, or closing quote.
   - Curly quotes (“ ”) instead of straight quotes (" "). TextEdit can add these automatically. To stop it, click **Edit > Substitutions** and turn off **Smart Quotes**.
4. If you can't find the problem, replace it with a fresh copy of [init.lua](../init.lua) from this repository, then reload.

## The `hs` command says it can't connect

**Cause:** Hammerspoon isn't running, or `hs.ipc` didn't load.

1. Make sure Hammerspoon is running.
2. Make sure `require("hs.ipc")` is near the top of `init.lua`, then reload.

Back to [README](../README.md).
