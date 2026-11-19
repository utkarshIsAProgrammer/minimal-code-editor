# Minimal Code Editor

Minimal is a lightweight code editor combining the performance of Neovim with the familiar keybindings of VS Code. It runs inside an optimized Kitty terminal profile with an isolated configuration.

## Key Features

- **Sub-25ms Startup:** Minimal memory footprint with zero Electron bloat.
- **Familiar Controls:** Modeless typing with standard shortcuts (<kbd>Ctrl+S</kbd>, <kbd>Ctrl+P</kbd>, <kbd>Ctrl+F</kbd>, <kbd>Ctrl+Q</kbd>).
- **Non-Destructive:** Runs under an isolated `NVIM_APPNAME="vsc"` environment, preserving any existing Neovim or Kitty configurations.
- **Cross-Platform:** Installs across Linux distributions and macOS.

---

## Quick Installation

Run the one-line installer in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.sh | bash
```

### Manual Installation

Clone the repository and run the setup script:

```bash
git clone https://github.com/utkarshIsAProgrammer/minimal-code-editor.git
cd minimal-code-editor
chmod +x install.sh
./install.sh
```

---

## Shortcuts Reference

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| <kbd>Esc</kbd> | Normal Mode | Switch to command/navigation mode. |
| <kbd>Ctrl</kbd> + <kbd>S</kbd> | Save | Saves the active buffer. |
| <kbd>Ctrl</kbd> + <kbd>P</kbd> | Find File | Search files in workspace. |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | Command Palette | Fuzzy find editor actions. |
| <kbd>Ctrl</kbd> + <kbd>Q</kbd> | Smart Quit | Prompts to save before quitting. |
| <kbd>Ctrl</kbd> + <kbd>N</kbd> | New File | Opens an empty buffer. |
| <kbd>Ctrl</kbd> + <kbd>W</kbd> | Close Tab | Closes current buffer tab. |

For the full shortcut list, see [docs/shortcuts.md](docs/shortcuts.md).

---

## Uninstallation

To cleanly remove Minimal and its configurations:

```bash
cd minimal-code-editor && ./uninstall.sh
```

---

## License

This project is licensed under the MIT License.
