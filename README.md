# Minimal Code Editor

<p align="center">
  <img src="assets/banner.png" alt="Minimal Code Editor Promo Card" width="100%" />
</p>

**Minimal** is a lightning-fast, distraction-free code editor combining the raw speed of Neovim with the familiar 1-to-1 muscle memory of VS Code. Built for developers who want instantaneous startup, modeless typing, zero Electron bloat, and standard cross-platform keybindings across Linux, Windows, and macOS.

---

## ⚡ Key Highlights

- **Sub-25ms Startup:** Memory footprint under ~30MB with zero Electron overhead.
- **Pure Modeless Editing:** Starts directly in write mode—no Vim mode hurdles, modal traps, or unexpected navigation keys. Press <kbd>Esc</kbd> to dismiss suggestion popups cleanly with zero cursor jitter.
- **1-to-1 VS Code Keybindings:** Exactly one sensible shortcut per operation (<kbd>Ctrl+S</kbd>, <kbd>Ctrl+P</kbd>, <kbd>Ctrl+F</kbd>, <kbd>Ctrl+H</kbd>, <kbd>Ctrl+W</kbd>, <kbd>Ctrl+Q</kbd> on Linux/Windows; native <kbd>Cmd ⌘</kbd> on macOS).
- **Curated Themes with Live Preview & Syntax Showroom:** 9 bespoke handcrafted themes (🔮 **Dark Magic**, 🌌 **Cyber Aurora**, 📜 **Medieval Scriptorium**, 🧪 **Phosphor Terminal**, ☕ **Espresso Roast**, ❄️ **Glacial Arctic**, 🪼 **Abyssal Trench**, 🩸 **Crimson Nocturne**, ⚠️ **Cyberdeck Industrial**) with instantaneous live preview via <kbd>Ctrl+K Ctrl+T</kbd>, <kbd>Ctrl+K t</kbd>, or <kbd>Alt+T</kbd>, plus one-key cycling with <kbd>F10</kbd>. Live showroom preview renders full syntax tokens automatically when browsing from empty files or the dashboard.
- **Floating Yazi Document Review & Chooser:** Built-in floating Yazi integration (<kbd>Alt+Y</kbd> / <kbd>Ctrl+Shift+E</kbd> / `:Yazi`). Inspect documents, image previews, and directory trees, then press <kbd>Enter</kbd> to open directly in Minimal.
- **In-Editor Markdown Document Review:** Real-time formatting for Markdown files (<kbd>Alt+M</kbd> / <kbd>Ctrl+K V</kbd>) with icons for headers, interactive checkboxes, Unicode table borders, and GitHub callout badges (`[!NOTE]`, `[!WARNING]`, `[!TIP]`).
- **Real-Time Inline Error Messages (Error Lens):** Direct on-the-line diagnostics (` Error`, ` Warning`) styled with your active theme’s colored highlight pills, updating live as you type across all files (<kbd>Ctrl+K D</kbd> / `:ToggleInlineErrors`).
- **One-Key Code Runner:** Run current files in a sleek bottom terminal drawer with <kbd>F5</kbd> or <kbd>Ctrl+F5</kbd> (:Run), with auto-saving and smart runtime detection for Python, JS/TS, Go, Rust, C/C++, Shell, and Lua.
- **Zen Mode & Sticky Scroll:** Distraction-free writing with Zen Mode (<kbd>Alt+Z</kbd> / <kbd>Ctrl+K Z</kbd>) and VS Code-style Sticky Scroll breadcrumbs pinned to the top of functions and classes.
- **Glowing Indent Scope & Fluid Cursor:** LazyVim-inspired glowing emerald indent scope guides and silky smooth cursor flow that feels like gliding through air.
- **Smart Code Suggestions:** Powered by `blink.cmp` with intelligent multi-source completions (LSP, friendly-snippets, file paths, and dictionary).
- **Out-of-the-Box Multi-Language Support:** First-class syntax highlighting and LSP intelligence for **Go**, **Python**, **JavaScript/TypeScript/React/TSX**, **HTML**, **CSS**, **Tailwind CSS**, **Rust**, **C/C++**, **Lua**, **Bash**, **YAML**, and **JSON**.
- **100% Isolated & Safe:** Runs under an isolated `NVIM_APPNAME="vsc"` sandbox. It will **never** alter or interfere with your existing Neovim, Kitty, Ghostty, or desktop setups.
- **Self-Updating:** Keep Minimal cutting-edge with a single command: `minimal update`.

---

## 📦 Prerequisites

Minimal requires **Neovim** (>= 0.10.0, recommended 0.11+) and **Git**. Minimal runs out-of-the-box in any modern terminal (**Kitty**, **Ghostty**, **WezTerm**, **Alacritty**, or standard system terminals). On Linux and macOS, Kitty or Ghostty provides the dedicated borderless GUI window.

### Windows (Native PowerShell)
```powershell
winget install Neovim.Neovim Git.Git
```

### macOS (via Homebrew)
```bash
brew install neovim kitty ghostty git
```

### Linux
- **Arch Linux / Manjaro / EndeavourOS:**
  ```bash
  sudo pacman -S neovim kitty ghostty git
  ```
- **Ubuntu / Debian / Linux Mint:**
  ```bash
  sudo apt install neovim kitty git
  ```
- **Fedora:**
  ```bash
  sudo dnf install neovim kitty git
  ```

*(Recommended)* Install a Nerd Font such as **JetBrainsMono Nerd Font** for clean icons and status glyphs.

---

## 🚀 Installation & Update

### Universal Linux & macOS Installer
Run in your terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.sh | bash
```

### Native Windows PowerShell Installer
Run in PowerShell:
```powershell
irm https://raw.githubusercontent.com/utkarshIsAProgrammer/minimal-code-editor/main/install.ps1 | iex
```

### Updating Minimal
Whenever a new feature or fix lands, update seamlessly from your terminal:
```bash
minimal update
# or
msc update
```

---

## 💻 How to Use

Launch Minimal from anywhere in your terminal or app launcher:

```bash
minimal             # Opens homescreen / empty workspace
minimal .           # Opens current folder as workspace
minimal main.py     # Opens specific file
```

---

## ⌨️ Essential Shortcuts

| Action | Linux & Windows | macOS (`Cmd` / `⌘`) | Description |
| :--- | :--- | :--- | :--- |
| **Dismiss Popups** | <kbd>Esc</kbd> | <kbd>Esc</kbd> | Dismisses completion popups/menus cleanly with zero cursor jitter |
| **Save File** | <kbd>Ctrl</kbd>+<kbd>S</kbd> | <kbd>⌘</kbd>+<kbd>S</kbd> | Saves current file |
| **Save As** | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> | Prompts for path/name |
| **Close Tab** | <kbd>Ctrl</kbd>+<kbd>W</kbd> | <kbd>⌘</kbd>+<kbd>W</kbd> | Closes active tab |
| **Quit Minimal** | <kbd>Ctrl</kbd>+<kbd>Q</kbd> | <kbd>⌘</kbd>+<kbd>Q</kbd> | Prompts to save dirty files and exits cleanly |
| **Open File (Quick Open)** | <kbd>Ctrl</kbd>+<kbd>P</kbd> | <kbd>⌘</kbd>+<kbd>P</kbd> | Fuzzy-search files in workspace |
| **Open Folder** | <kbd>Ctrl</kbd>+<kbd>O</kbd> | <kbd>⌘</kbd>+<kbd>O</kbd> | Select or type any folder path to open as workspace |
| **Command Palette** | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> *(or <kbd>F1</kbd>)* | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> *(or <kbd>F1</kbd>)* | Fuzzy-search and execute all editor commands |
| **Toggle Sidebar** | <kbd>Ctrl</kbd>+<kbd>B</kbd> | <kbd>⌘</kbd>+<kbd>B</kbd> | Opens/closes Explorer file tree |
| **Run Current File** | <kbd>F5</kbd> *(or <kbd>Ctrl</kbd>+<kbd>F5</kbd>)* | <kbd>F5</kbd> *(or <kbd>⌘</kbd>+<kbd>F5</kbd>)* | Executes active code file in bottom terminal drawer |
| **Live Server** | <kbd>Alt</kbd>+<kbd>L</kbd> *(or <kbd>F6</kbd>)* | <kbd>⌥</kbd>+<kbd>L</kbd> *(or <kbd>F6</kbd>)* | Toggles local live HTTP reload server with auto-browser opening |
| **Toggle Terminal** | <kbd>Ctrl</kbd>+<kbd>`</kbd> | <kbd>⌘</kbd>+<kbd>`</kbd> | Opens/closes active terminal panel |
| **New Terminal Instance**| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> | Spawns a new independent terminal instance (#1, #2, #3...) |
| **Cycle Terminal Layout**| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>L</kbd> *(or <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd>)*| <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>L</kbd> | Switches layout: Bottom Drawer → Right Split → Centered Float |
| **Terminal Profiles** | <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>T</kbd> | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>T</kbd> | Launch profiles: Shell, Python REPL, Bun/Node REPL, Git, Btop |
| **Active Terminals Picker**| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>P</kbd> | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>P</kbd> | Fuzzy-search and jump between open terminal instances |
| **Resize Terminal Drawer**| <kbd>Ctrl</kbd>+<kbd>Up</kbd> / <kbd>Down</kbd> / <kbd>Left</kbd> / <kbd>Right</kbd> | <kbd>Ctrl</kbd>+Arrows | Expands or shrinks the terminal window on the fly |
| **Yazi Doc Review** | <kbd>Alt</kbd>+<kbd>Y</kbd> *(or <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>)* | <kbd>⌥</kbd>+<kbd>Y</kbd> *(or <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>)* | Floating Yazi document reviewer & chooser |
| **Markdown Live Review**| <kbd>Alt</kbd>+<kbd>M</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>V</kbd>)* | <kbd>⌥</kbd>+<kbd>M</kbd> *(or <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>V</kbd>)* | In-editor rich Markdown formatting |
| **Zen / Focus Mode** | <kbd>Alt</kbd>+<kbd>Z</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Z</kbd>)* | <kbd>⌥</kbd>+<kbd>Z</kbd> *(or <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>Z</kbd>)* | Distraction-free document writing mode |
| **Color Theme Picker** | <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>T</kbd> *(or <kbd>Alt</kbd>+<kbd>T</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>T</kbd> | Interactive theme picker with live syntax showroom |
| **Cycle Theme** | <kbd>F10</kbd> *(or <kbd>Alt</kbd>+<kbd>F10</kbd>)* | <kbd>F10</kbd> | Sequential cycle through all 9 bespoke themes |
| **Edit Keybindings** | <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>S</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>s</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>S</kbd> | Opens keybindings configuration file |

📖 For the full keybindings manual, refer to **[docs/shortcuts.md](docs/shortcuts.md)** or the **[Printable PDF Cheatsheet](docs/shortcuts.pdf)**.

---

## 🗑️ Clean Uninstallation

Minimal is completely isolated. To uninstall:

```bash
cd minimal-code-editor && ./uninstall.sh
```

---

## 📄 License

This project is open-source under the MIT License.
