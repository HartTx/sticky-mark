# Install and set up Sticky Mark

This guide shows you how to install Sticky Mark on a Mac, either to rebuild it on a new computer or to recover it after something goes wrong.

It takes about 10 minutes.

## Before you begin

You need:

- A Mac running a recent version of macOS.
- An administrator account (to grant Accessibility permission).
- [Homebrew](https://brew.sh), a tool for installing apps from Terminal. To check whether you have it, open Terminal and run `brew --version`. If you see a version number, you have it.

If you don't want to use Homebrew, you can download Hammerspoon from [hammerspoon.org](https://www.hammerspoon.org) instead. Then skip to [Step 2](#step-2-install-the-script).

## Step 1: Install Hammerspoon

1. Open Terminal.
2. Run this command:

   ```bash
   brew install --cask hammerspoon
   ```

   When it finishes, you see `hammerspoon was successfully installed!`

## Step 2: Install the script

> [!WARNING]
> If `~/.hammerspoon/init.lua` already exists, the next steps replace it. Copy the old file somewhere safe first if it has anything you want to keep.

1. In Terminal, create the Hammerspoon folder:

   ```bash
   mkdir -p ~/.hammerspoon
   ```

2. Download the script:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/HartTx/sticky-mark/main/init.lua -o ~/.hammerspoon/init.lua
   ```

> [!TIP]
> If you'd rather pull updates with Git, clone the repository and link the script instead of downloading it:
>
> ```bash
> git clone https://github.com/HartTx/sticky-mark.git ~/sticky-mark
> ln -sf ~/sticky-mark/init.lua ~/.hammerspoon/init.lua
> ```

## Step 3: Start Hammerspoon and grant permission

> [!IMPORTANT]
> Without Accessibility permission, the keyboard shortcuts and dragging don't work. The flag still appears, which can make it look like the setup worked when it didn't.

1. Open **Hammerspoon** from your Applications folder.
2. If macOS asks for permission, click **Open System Settings**. If it doesn't ask, open **System Settings > Privacy & Security > Accessibility** yourself.
3. Turn on **Hammerspoon**. You might need to enter your password.
4. Click the Hammerspoon icon (a hammer) in the menu bar, then click **Reload Config**.

   A "Post-it flag ready" message appears, and a pink arrow appears near the top middle of the screen.

## Step 4: Start Hammerspoon automatically

1. Click the Hammerspoon icon in the menu bar, then click **Preferences**.
2. Select **Launch Hammerspoon at login**.

## Verify the setup

Test each feature. All of these should work:

| Test | Expected result |
| --- | --- |
| Drag the flag | The flag follows the mouse. |
| Press ⌃⌥↓ | The flag moves down a little. |
| Press ⌃⌥C | The flag turns blue. |
| Press ⌃⌥3 | The flag turns yellow. |
| Press ⌃⌥R | The flag points up. |
| Press ⌃⌥E | The flag points left again. |
| Press ⌃⌥F twice | The flag disappears, then reappears next to the mouse pointer. |

If anything doesn't work, see [Troubleshooting](troubleshooting.md).

## Optional: Check from Terminal

The script loads `hs.ipc`, so you can query the running flag from Terminal:

```bash
hs -c 'return postitFlag:isShowing()'
```

If the flag is loaded, this prints `true`.

## Uninstall

1. Quit Hammerspoon from its menu bar icon.
2. Remove the app and its configuration:

   ```bash
   brew uninstall --cask hammerspoon
   ```

   ```bash
   rm -r ~/.hammerspoon
   ```

3. In **System Settings > Privacy & Security > Accessibility**, remove Hammerspoon from the list.

## Next steps

- Learn the shortcuts: [Keyboard shortcuts](keyboard-shortcuts.md)
- Customize the flag: [Configuration](configuration.md)

Back to [README](../README.md).
