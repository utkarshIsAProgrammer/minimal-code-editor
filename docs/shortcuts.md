# Minimal Code Editor — Standard Shortcuts Reference

Minimal bridges the speed of Neovim with the familiar 1-to-1 muscle memory of VS Code.

> **Cross-Platform Design:**
> - **Linux & Windows:** Use standard <kbd>Ctrl</kbd> and <kbd>Alt</kbd> combinations.
> - **macOS:** Native <kbd>Cmd (⌘)</kbd> and <kbd>Option (⌥)</kbd> shortcuts.

---

## 🛠️ General & Application Control

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Esc</kbd> | <kbd>Esc</kbd> | **Dismiss Popups** | Dismisses suggestion popups/menus cleanly with zero cursor jitter. |
| <kbd>Ctrl</kbd>+<kbd>S</kbd> | <kbd>⌘</kbd>+<kbd>S</kbd> | **Save File** | Saves current file. If untitled, prompts for filename/path. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>S</kbd> | **Save As** | Prompts to save the file under a new name or path. |
| <kbd>Ctrl</kbd>+<kbd>W</kbd> | <kbd>⌘</kbd>+<kbd>W</kbd> | **Close Tab** | Closes active editor tab / buffer. |
| <kbd>Ctrl</kbd>+<kbd>Q</kbd> | <kbd>⌘</kbd>+<kbd>Q</kbd> | **Quit Minimal** | Prompts to save modified files, then exits cleanly. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> *(or <kbd>F1</kbd>)* | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> *(or <kbd>F1</kbd>)* | **Command Palette** | Search and immediately execute any editor command. |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>S</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>s</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>S</kbd> | **Edit Keybindings** | Opens keybindings configuration file directly. |

---

## 📂 File & Workspace Management

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>N</kbd> | <kbd>⌘</kbd>+<kbd>N</kbd> | **New Blank File** | Creates a fresh, empty buffer and enters typing mode. |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | <kbd>⌘</kbd>+<kbd>P</kbd> | **Open File (Quick Open)** | Fuzzy-search and jump to any file in your workspace. |
| <kbd>Ctrl</kbd>+<kbd>O</kbd> | <kbd>⌘</kbd>+<kbd>O</kbd> | **Open Folder** | Select or type any folder path to open as workspace. |
| <kbd>Ctrl</kbd>+<kbd>B</kbd> | <kbd>⌘</kbd>+<kbd>B</kbd> | **Toggle Explorer Sidebar**| Shows/hides project file tree sidebar. |
| <kbd>Ctrl</kbd>+<kbd>0</kbd> | <kbd>⌘</kbd>+<kbd>0</kbd> | **Focus Sidebar** | Moves focus into the Explorer sidebar. |
| <kbd>Ctrl</kbd>+<kbd>1</kbd> | <kbd>⌘</kbd>+<kbd>1</kbd> | **Focus Editor** | Moves focus from sidebar back into the code editor. |
| <kbd>Ctrl</kbd>+<kbd>`</kbd> | <kbd>⌘</kbd>+<kbd>`</kbd> *(or <kbd>Ctrl</kbd>+<kbd>`</kbd>)* | **Toggle Terminal** | Opens/closes active terminal panel. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> | **New Terminal Instance** | Spawns a new independent terminal instance (Terminal #1, #2, #3...). |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>L</kbd> *(or <kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>L</kbd> | **Cycle Terminal Layout** | Switches layout: Bottom Drawer → Right Split → Centered Float. |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>T</kbd> | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>T</kbd> | **Terminal Profiles** | Launch dedicated profiles: Shell, Python REPL, Bun/Node, Git/Lazygit, Btop. |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>P</kbd> | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>P</kbd> | **Terminal Instance Picker**| Fuzzy-search and jump between open active terminal instances. |
| <kbd>Ctrl</kbd>+<kbd>Up</kbd> / <kbd>Down</kbd> / <kbd>Left</kbd> / <kbd>Right</kbd> | <kbd>Ctrl</kbd>+Arrows | **Resize Terminal Drawer** | Dynamically expands or shrinks the terminal window on the fly. |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | **Next Tab** | Cycles forward through open tabs. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Tab</kbd> | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Tab</kbd> | **Previous Tab** | Cycles backward through open tabs. |

---

## 🔍 Search & Replace

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>F</kbd> | <kbd>⌘</kbd>+<kbd>F</kbd> | **Find in File** | Interactive search within the current buffer. |
| <kbd>Ctrl</kbd>+<kbd>H</kbd> | <kbd>⌘</kbd>+<kbd>H</kbd> | **Replace in File** | Interactive find-and-replace in current file. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>F</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>F</kbd> | **Find in Files (Grep)** | Global search across all project files. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>H</kbd> | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>H</kbd> | **Replace in Files** | Project-wide search and replace across all files. |
| <kbd>Ctrl</kbd>+<kbd>G</kbd> | <kbd>⌘</kbd>+<kbd>G</kbd> | **Go to Line** | Jump to line number (e.g. `45` or `45:10`). |

---

## ✏️ Editing & Clipboard

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>Z</kbd> | <kbd>⌘</kbd>+<kbd>Z</kbd> | **Undo** | Reverts previous edits. |
| <kbd>Ctrl</kbd>+<kbd>Y</kbd> *(or <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Z</kbd>)* | <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>Z</kbd> | **Redo** | Reapplies undone changes. |
| <kbd>Ctrl</kbd>+<kbd>A</kbd> | <kbd>⌘</kbd>+<kbd>A</kbd> | **Select All** | Selects entire document text. |
| <kbd>Ctrl</kbd>+<kbd>C</kbd> | <kbd>⌘</kbd>+<kbd>C</kbd> | **Copy** | Copies selection or current line to system clipboard. |
| <kbd>Ctrl</kbd>+<kbd>X</kbd> | <kbd>⌘</kbd>+<kbd>X</kbd> | **Cut** | Cuts selection or current line to system clipboard. |
| <kbd>Ctrl</kbd>+<kbd>V</kbd> | <kbd>⌘</kbd>+<kbd>V</kbd> | **Paste** | Pastes from system clipboard (auto-indented). |
| <kbd>Ctrl</kbd>+<kbd>Backspace</kbd> | <kbd>⌥</kbd>+<kbd>Backspace</kbd> | **Delete Word Left** | Deletes word before the cursor. |
| <kbd>Ctrl</kbd>+<kbd>Delete</kbd> | <kbd>⌥</kbd>+<kbd>Delete</kbd> | **Delete Word Right** | Deletes word after the cursor. |
| <kbd>Shift</kbd>+<kbd>Delete</kbd> | <kbd>Shift</kbd>+<kbd>Delete</kbd> | **Delete Line** | Deletes entire current line. |

---

## 📋 Comments & Line Manipulation

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>/</kbd> | <kbd>⌘</kbd>+<kbd>/</kbd> | **Toggle Line Comment** | Toggles single or multiline comments (`//`, `#`, `--`). |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>A</kbd> | <kbd>Shift</kbd>+<kbd>⌥</kbd>+<kbd>A</kbd> | **Toggle Block Comment**| Toggles block comment (`/* */`, `<!-- -->`). |
| <kbd>Alt</kbd>+<kbd>Up</kbd> | <kbd>⌥</kbd>+<kbd>Up</kbd> | **Move Line Up** | Slides current line or selection upward. |
| <kbd>Alt</kbd>+<kbd>Down</kbd> | <kbd>⌥</kbd>+<kbd>Down</kbd> | **Move Line Down** | Slides current line or selection downward. |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Down</kbd>| <kbd>Shift</kbd>+<kbd>⌥</kbd>+<kbd>Down</kbd>| **Duplicate Line Down** | Duplicates current line or selection below. |
| <kbd>Ctrl</kbd>+<kbd>Enter</kbd> | <kbd>⌘</kbd>+<kbd>Enter</kbd> | **Insert Line Below** | Inserts newline below without breaking current line. |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Enter</kbd>| <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>Enter</kbd>| **Insert Line Above** | Inserts newline above without breaking current line. |
| <kbd>Ctrl</kbd>+<kbd>D</kbd> | <kbd>⌘</kbd>+<kbd>D</kbd> | **Multi-Cursor Match** | Selects next occurrence of current word / selection. |

---

## 🧠 Code Intelligence & LSP

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>.</kbd> *(or <kbd>Alt</kbd>+<kbd>Enter</kbd>)* | <kbd>⌘</kbd>+<kbd>.</kbd> | **Quick Fix / Solutions**| Shows available code actions, imports, and autocorrect. |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>I</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>i</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>I</kbd> | **Hover & Diagnostics** | Shows documentation hover and detailed problem diagnostics. |
| <kbd>F2</kbd> | <kbd>F2</kbd> | **Rename Symbol** | Renames symbol across the entire project safely. |
| <kbd>F12</kbd> | <kbd>F12</kbd> | **Go to Definition** | Jumps to function/class/variable declaration. |
| <kbd>Shift</kbd>+<kbd>F12</kbd> | <kbd>Shift</kbd>+<kbd>F12</kbd> | **Find References** | Shows all references across the project. |
| <kbd>F8</kbd> | <kbd>F8</kbd> | **Next Problem** | Jumps to next error / warning in buffer. |
| <kbd>Shift</kbd>+<kbd>F8</kbd> | <kbd>Shift</kbd>+<kbd>F8</kbd> | **Previous Problem** | Jumps to previous error / warning in buffer. |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>F</kbd> | <kbd>Shift</kbd>+<kbd>⌥</kbd>+<kbd>F</kbd> | **Format Document** | Formats buffer via Prettier / Conform / LSP. |
| <kbd>F5</kbd> *(or <kbd>Ctrl</kbd>+<kbd>F5</kbd>)* | <kbd>F5</kbd> *(or <kbd>⌘</kbd>+<kbd>F5</kbd>)* | **Run Current File** | Executes active code file in bottom terminal drawer. |
| <kbd>Alt</kbd>+<kbd>L</kbd> *(or <kbd>F6</kbd>)* | <kbd>⌥</kbd>+<kbd>L</kbd> *(or <kbd>F6</kbd>)* | **Live Server Toggle** | Starts/stops local live HTTP reload server with browser auto-open. |
| <kbd>Esc</kbd> *(or <kbd>Ctrl</kbd>+<kbd>E</kbd> / <kbd>Shift</kbd>+<kbd>Esc</kbd>)* | <kbd>Esc</kbd> | **Dismiss Suggestions** | Closes completion popup synchronously with zero cursor shift. |

---

## 📖 Documentation, Document Review & Focus Tools

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Alt</kbd>+<kbd>Y</kbd> *(or <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>)* | <kbd>⌥</kbd>+<kbd>Y</kbd> *(or <kbd>⌘</kbd>+<kbd>Shift</kbd>+<kbd>E</kbd>)* | **Yazi Document Review** | Pops up floating Yazi file manager with instant image, doc and tree preview. Press <kbd>Enter</kbd> to open. |
| <kbd>Alt</kbd>+<kbd>M</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>V</kbd>)* | <kbd>⌥</kbd>+<kbd>M</kbd> *(or <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>V</kbd>)* | **In-Editor Markdown Review**| Real-time markdown rendering with icons, interactive checkboxes, tables and GitHub callouts. |
| <kbd>Alt</kbd>+<kbd>Z</kbd> *(or <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Z</kbd>)* | <kbd>⌥</kbd>+<kbd>Z</kbd> *(or <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>Z</kbd>)* | **Zen Focus Mode** | Distraction-free reading and writing mode with centered buffer and dimmed chrome. |
| `:StickyScroll` | `:StickyScroll` | **Sticky Scroll Breadcrumbs** | Pins parent class, function, or document section to the top row while scrolling. |

---

## 🎨 Themes & Customization

| Linux / Windows | macOS | Action | Description |
| :--- | :--- | :--- | :--- |
| <kbd>Ctrl</kbd>+<kbd>K</kbd> <kbd>Ctrl</kbd>+<kbd>T</kbd> *(or <kbd>Alt</kbd>+<kbd>T</kbd>)* | <kbd>⌘</kbd>+<kbd>K</kbd> <kbd>⌘</kbd>+<kbd>T</kbd> | **Theme Picker** | Interactive theme picker with live syntax showroom preview across all 9 handcrafted themes. |
| <kbd>F10</kbd> *(or <kbd>Alt</kbd>+<kbd>F10</kbd>)* | <kbd>F10</kbd> | **Cycle Themes** | Quick-cycles: Dark Magic → Cyber Aurora → Medieval → Phosphor → Espresso → Frostbite → Abyssal → Nocturne → Industrial. |
| `:Theme <name>` | `:Theme <name>` | **Command Switch** | Directly sets theme with autocomplete (`:Theme phosphor`, `:Theme espressonoir`, `:Theme abyssal`, etc.). |
| `:IndentRainbow` | `:IndentRainbow` | **Indent Scope** | Toggles glowing LazyVim-style emerald indent scope guides. |
