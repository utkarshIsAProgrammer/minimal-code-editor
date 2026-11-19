# Minimal Code Editor

Minimal is a lightning-fast, distraction-free code editor combining the raw speed of Neovim with the familiar keybindings of VS Code. It runs inside an optimized Kitty terminal profile with a completely isolated configuration.

---

## ⚡ Key Features

- **Sub-25ms Startup:** Minimal memory footprint (~30MB) with zero Electron bloat.
- **Familiar Muscle Memory:** Modeless typing with standard shortcuts (<kbd>Ctrl+S</kbd>, <kbd>Ctrl+P</kbd>, <kbd>Ctrl+F</kbd>, <kbd>Ctrl+Q</kbd>).
- **100% Non-Destructive:** Runs under an isolated `NVIM_APPNAME="vsc"` environment. It will **never** overwrite or conflict with your existing Neovim or Kitty configurations.
- **Cross-Platform:** Full native support across Linux and macOS.

---

## 📦 Prerequisites

Minimal requires **Neovim** (>= 0.9.0) and **Kitty** terminal.

### macOS (via Homebrew)
```bash
brew install neovim kitty
```

### Linux

- **Arch Linux / Manjaro / EndeavourOS:**
  ```bash
  sudo pacman -S neovim kitty git
  ```
- **Ubuntu / Debian / Linux Mint:**
  ```bash
  sudo apt install neovim kitty git
  ```
- **Fedora:**
  ```bash
  sudo dnf install neovim kitty git
  ```

*(Recommended)* Install a Nerd Font such as **JetBrainsMono Nerd Font** for icons.

---

## 🚀 Quick Installation

Run the universal one-line installer in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.sh | bash
```

### Manual Installation

Alternatively, clone the repository and run the setup script:

```bash
git clone https://github.com/utkarshIsAProgrammer/minimal-code-editor.git
cd minimal-code-editor
chmod +x install.sh
./install.sh
```

---

## 💻 How to Use

Once installed, launch Minimal from anywhere in your terminal:

```bash
minimal             # Launch empty editor
minimal .           # Open current directory workspace
minimal main.py     # Open a specific file
```

On Linux, you can also launch **Minimal** directly from your application launcher (Rofi, Wofi, GNOME, KDE, or Hyprland).

---

## ⌨️ Shortcuts Reference

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| <kbd>Esc</kbd> | Normal Mode | Switch to command / navigation mode. |
| <kbd>Ctrl</kbd> + <kbd>S</kbd> | Save File | Saves the active buffer. |
| <kbd>Ctrl</kbd> + <kbd>P</kbd> | Find File | Fuzzy search files in workspace. |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> | Command Palette | Search all editor actions. |
| <kbd>Ctrl</kbd> + <kbd>Q</kbd> | Smart Quit | Prompts to save before quitting. |
| <kbd>Ctrl</kbd> + <kbd>N</kbd> | New File | Opens an empty buffer tab. |
| <kbd>Ctrl</kbd> + <kbd>W</kbd> | Close Tab | Closes current buffer tab. |
| <kbd>Ctrl</kbd> + <kbd>Tab</kbd> | Next Tab | Switch to next open buffer. |

For the complete shortcuts list, see [docs/shortcuts.md](docs/shortcuts.md).

---

## 🗑️ Uninstallation

Minimal is completely isolated. If you ever wish to remove it cleanly:

```bash
cd minimal-code-editor && ./uninstall.sh
```

---

## 📄 License

This project is open-source under the MIT License.
