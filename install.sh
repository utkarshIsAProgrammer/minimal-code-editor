#!/usr/bin/env bash
# ===================================================================
#  ⚡ Minimal Code Editor - Universal Installer
#  Works on Linux, macOS, and Windows (WSL2)
# ===================================================================

set -e

REPO_URL="https://github.com/utkarshIsAProgrammer/minimal-code-editor.git"
BRANCH="main"

# Colors
CYAN="\033[1;36m"
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
BOLD="\033[1m"
RESET="\033[0m"

echo -e "${CYAN}"
cat << 'EOF'
  __  __ _       _                 _ 
 |  \/  (_)_ __ (_)_ __ ___   __ _| |
 | |\/| | | '_ \| | '_ ` _ \ / _` | |
 | |  | | | | | | | | | | | | (_| | |
 |_|  |_|_|_| |_|_|_| |_| |_|\__,_|_|
EOF
echo -e "${RESET}${BOLD}The Lightning-Fast Minimalist Code Editor${RESET}"
echo -e "${BLUE}https://github.com/utkarshIsAProgrammer/minimal-code-editor${RESET}\n"

# -------------------------------------------------------------------
# 1. Detect Operating System
# -------------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
    Linux*)     PLATFORM="Linux" ;;
    Darwin*)    PLATFORM="macOS" ;;
    *)          PLATFORM="Unknown" ;;
esac

echo -e "📦 Detected Platform: ${GREEN}${PLATFORM}${RESET}"

# -------------------------------------------------------------------
# 2. Dependency Checks
# -------------------------------------------------------------------
echo -e "\n🔍 Checking prerequisites..."

# Check git
if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}✘ Error: 'git' is not installed.${RESET}"
    echo "Please install git and rerun this script."
    exit 1
fi

# Check Neovim
NVIM_FOUND=false
if command -v nvim >/dev/null 2>&1; then
    NVIM_FOUND=true
elif [ -x "/opt/homebrew/bin/nvim" ] || [ -x "/usr/local/bin/nvim" ] || [ -x "$HOME/.local/bin/nvim" ]; then
    NVIM_FOUND=true
fi

if [ "$NVIM_FOUND" = "false" ]; then
    echo -e "${YELLOW}⚠ Warning: 'nvim' (Neovim) was not found in your PATH.${RESET}"
    if [ "$PLATFORM" = "macOS" ]; then
        if command -v brew >/dev/null 2>&1; then
            echo -e "  Attempting to install Neovim via Homebrew..."
            brew install neovim || true
        else
            echo -e "  Install with: ${CYAN}brew install neovim${RESET} or download from https://neovim.io"
        fi
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "  Install with: ${CYAN}sudo pacman -S neovim${RESET}"
    elif command -v apt >/dev/null 2>&1; then
        echo -e "  Install with: ${CYAN}sudo apt install neovim${RESET}"
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "  Install with: ${CYAN}sudo dnf install neovim${RESET}"
    fi
else
    NVIM_VER="$(nvim --version 2>/dev/null | head -n 1 || /opt/homebrew/bin/nvim --version 2>/dev/null | head -n 1 || echo 'Neovim')"
    echo -e "  ${GREEN}✔${RESET} Found ${NVIM_VER}"
fi

# Check Kitty / Ghostty
if command -v kitty >/dev/null 2>&1 || [ -x "/Applications/kitty.app/Contents/MacOS/kitty" ]; then
    echo -e "  ${GREEN}✔${RESET} Found Kitty terminal"
elif command -v ghostty >/dev/null 2>&1 || [ -x "/Applications/Ghostty.app/Contents/MacOS/ghostty" ]; then
    echo -e "  ${GREEN}✔${RESET} Found Ghostty terminal"
else
    echo -e "${YELLOW}⚠ Recommended: 'kitty' or 'ghostty' terminal was not found.${RESET}"
    echo -e "  Minimal runs in any terminal, but Kitty/Ghostty is recommended for the dedicated GUI profile."
    if [ "$PLATFORM" = "macOS" ]; then
        echo -e "  Install with: ${CYAN}brew install kitty${RESET} or ${CYAN}brew install ghostty${RESET}"
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "  Install with: ${CYAN}sudo pacman -S kitty${RESET} or ${CYAN}sudo pacman -S ghostty${RESET}"
    elif command -v apt >/dev/null 2>&1; then
        echo -e "  Install with: ${CYAN}sudo apt install kitty${RESET}"
    fi
fi

# Check System Clipboard Provider on Linux
if [ "$PLATFORM" = "Linux" ]; then
    if command -v wl-copy >/dev/null 2>&1 || command -v xclip >/dev/null 2>&1 || command -v xsel >/dev/null 2>&1; then
        echo -e "  ${GREEN}✔${RESET} Found system clipboard provider"
    else
        echo -e "  ${YELLOW}ℹ Tip: For system clipboard sharing (Ctrl+C / Ctrl+V across external apps), install:${RESET}"
        echo -e "    Wayland: ${CYAN}sudo apt install wl-clipboard${RESET} / ${CYAN}sudo pacman -S wl-clipboard${RESET}"
        echo -e "    X11:     ${CYAN}sudo apt install xclip${RESET} / ${CYAN}sudo pacman -S xclip${RESET}"
    fi
fi

# -------------------------------------------------------------------
# 3. Locate Source Files (Local vs Remote Curl)
# -------------------------------------------------------------------
TEMP_DIR=""
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

if [ -f "$SCRIPT_DIR/config/vsc/init.lua" ]; then
    SRC_DIR="$SCRIPT_DIR"
    echo -e "\n📂 Installing from local directory: ${CYAN}${SRC_DIR}${RESET}"
else
    echo -e "\n🌐 Downloading Minimal repository from GitHub..."
    TEMP_DIR="$(mktemp -d)"
    git clone --depth=1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1
    SRC_DIR="$TEMP_DIR"
fi

# -------------------------------------------------------------------
# 4. Install Configurations
# -------------------------------------------------------------------
echo -e "\n⚙️  Setting up configuration files..."

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$XDG_CONFIG_HOME/vsc"
mkdir -p "$XDG_CONFIG_HOME/kitty"
mkdir -p "$BIN_DIR"
mkdir -p "$XDG_DATA_HOME/icons"
mkdir -p "$XDG_DATA_HOME/applications"

# Copy Neovim VSC config
cp -rf "$SRC_DIR"/config/vsc/* "$XDG_CONFIG_HOME/vsc/"
chmod +x "$XDG_CONFIG_HOME/vsc/bin/"* 2>/dev/null || true
echo -e "  ${GREEN}✔${RESET} Isolated Neovim config installed to ${CYAN}$XDG_CONFIG_HOME/vsc/${RESET}"

# Copy Kitty config
cp -rf "$SRC_DIR/config/kitty/minimal.conf" "$XDG_CONFIG_HOME/kitty/minimal.conf"
echo -e "  ${GREEN}✔${RESET} Kitty editor profile installed to ${CYAN}$XDG_CONFIG_HOME/kitty/minimal.conf${RESET}"

# Pre-bootstrap lazy.nvim plugin engine
LAZY_DIR="$XDG_DATA_HOME/vsc/lazy/lazy.nvim"
if [ ! -d "$LAZY_DIR" ]; then
    echo -e "  ⚡ Pre-bootstrapping lazy.nvim plugin engine..."
    git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git "$LAZY_DIR" >/dev/null 2>&1 || true
    echo -e "  ${GREEN}✔${RESET} lazy.nvim engine initialized"
fi

# -------------------------------------------------------------------
# 5. Install Binaries and Desktop Integration
# -------------------------------------------------------------------
echo -e "\n🚀 Installing executable commands..."

cp -f "$SRC_DIR/bin/minimal" "$BIN_DIR/minimal"
cp -f "$SRC_DIR/bin/msc" "$BIN_DIR/msc"
if [ -f "$SRC_DIR/bin/minimal-font" ]; then
    cp -f "$SRC_DIR/bin/minimal-font" "$BIN_DIR/minimal-font"
    chmod +x "$BIN_DIR/minimal-font"
fi
chmod +x "$BIN_DIR/minimal" "$BIN_DIR/msc"
echo -e "  ${GREEN}✔${RESET} Installed commands: ${CYAN}minimal${RESET}, ${CYAN}msc${RESET}, and ${CYAN}minimal-font${RESET} to ${CYAN}$BIN_DIR/${RESET}"

if [ "$PLATFORM" = "Linux" ]; then
    # Standard Icons & Hicolor spec (prevents older cached icons from overriding)
    mkdir -p "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    mkdir -p "$XDG_DATA_HOME/icons/hicolor/512x512/apps"
    mkdir -p "$XDG_DATA_HOME/icons/hicolor/256x256/apps"

    cp -f "$SRC_DIR/assets/minimal.png" "$XDG_DATA_HOME/icons/minimal.png"
    cp -f "$SRC_DIR/assets/minimal.svg" "$XDG_DATA_HOME/icons/minimal.svg"
    cp -f "$SRC_DIR/assets/minimal.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/minimal.svg"
    cp -f "$SRC_DIR/assets/minimal.png" "$XDG_DATA_HOME/icons/hicolor/512x512/apps/minimal.png"
    cp -f "$SRC_DIR/assets/minimal.png" "$XDG_DATA_HOME/icons/hicolor/256x256/apps/minimal.png"
    echo -e "  ${GREEN}✔${RESET} Desktop icons installed to standard and hicolor themes"

    # Desktop Launcher
    cp -f "$SRC_DIR/desktop/minimal.desktop" "$XDG_DATA_HOME/applications/minimal.desktop"
    echo -e "  ${GREEN}✔${RESET} Desktop entry registered"

    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$XDG_DATA_HOME/applications" >/dev/null 2>&1 || true
    fi
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache -f -t "$XDG_DATA_HOME/icons/hicolor" >/dev/null 2>&1 || true
        gtk-update-icon-cache -f -t "$XDG_DATA_HOME/icons" >/dev/null 2>&1 || true
    fi
fi

# -------------------------------------------------------------------
# 6. Ensure PATH includes ~/.local/bin
# -------------------------------------------------------------------
for RC in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
    if [ -f "$RC" ]; then
        if ! grep -q '\.local/bin' "$RC" 2>/dev/null; then
            echo '' >> "$RC"
            echo '# Minimal Code Editor' >> "$RC"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
            echo -e "  ${GREEN}✔${RESET} Added ~/.local/bin to ${CYAN}$RC${RESET}"
        fi
    fi
done

# Fish shell PATH integration
if [ -d "$HOME/.config/fish" ] || command -v fish >/dev/null 2>&1; then
    FISH_CONF="$HOME/.config/fish/config.fish"
    mkdir -p "$HOME/.config/fish"
    if [ ! -f "$FISH_CONF" ] || ! grep -q '\.local/bin' "$FISH_CONF" 2>/dev/null; then
        echo '' >> "$FISH_CONF"
        echo '# Minimal Code Editor' >> "$FISH_CONF"
        echo 'fish_add_path -a $HOME/.local/bin' >> "$FISH_CONF"
        echo -e "  ${GREEN}✔${RESET} Added ~/.local/bin to ${CYAN}$FISH_CONF${RESET}"
    fi
fi

# -------------------------------------------------------------------
# 7. Complete!
# -------------------------------------------------------------------
echo -e "\n${GREEN}${BOLD}✨ Minimal installed successfully! ✨${RESET}\n"
echo -e "You can launch it anytime by running:"
echo -e "  ${CYAN}minimal${RESET}             # Open editor"
echo -e "  ${CYAN}minimal filename.py${RESET} # Open a specific file"
echo -e "  ${CYAN}minimal .${RESET}           # Open current directory"
if [ "$PLATFORM" = "Linux" ]; then
    echo -e "  Or find ${BOLD}Minimal${RESET} in your application menu/launcher."
fi
echo ""
