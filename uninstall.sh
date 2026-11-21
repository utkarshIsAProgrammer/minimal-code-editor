#!/usr/bin/env bash
# ===================================================================
#  ⚡ Minimal Code Editor - Uninstaller
# ===================================================================

set -e

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
BOLD="\033[1m"
RESET="\033[0m"

echo -e "${YELLOW}${BOLD}Uninstalling Minimal Code Editor...${RESET}\n"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
BIN_DIR="$HOME/.local/bin"

# Remove Config
if [ -d "$XDG_CONFIG_HOME/vsc" ]; then
    rm -rf "$XDG_CONFIG_HOME/vsc"
    echo -e "  ${GREEN}✔${RESET} Removed config: $XDG_CONFIG_HOME/vsc"
fi

if [ -f "$XDG_CONFIG_HOME/kitty/minimal.conf" ]; then
    rm -f "$XDG_CONFIG_HOME/kitty/minimal.conf"
    echo -e "  ${GREEN}✔${RESET} Removed kitty profile: $XDG_CONFIG_HOME/kitty/minimal.conf"
fi

# Remove Binaries
rm -f "$BIN_DIR/minimal" "$BIN_DIR/msc" "$BIN_DIR/minimal-font"
echo -e "  ${GREEN}✔${RESET} Removed binaries: $BIN_DIR/minimal, $BIN_DIR/msc, $BIN_DIR/minimal-font"

# Remove Data and State
rm -rf "$XDG_DATA_HOME/vsc" "$XDG_STATE_HOME/vsc"
echo -e "  ${GREEN}✔${RESET} Cleaned plugin cache & states"

# Remove Desktop Integration
rm -f "$XDG_DATA_HOME/applications/minimal.desktop"
rm -f "$XDG_DATA_HOME/icons/minimal.png" "$XDG_DATA_HOME/icons/minimal.svg"
rm -f "$XDG_DATA_HOME/icons/hicolor/scalable/apps/minimal.svg"
rm -f "$XDG_DATA_HOME/icons/hicolor/512x512/apps/minimal.png"
rm -f "$XDG_DATA_HOME/icons/hicolor/256x256/apps/minimal.png"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$XDG_DATA_HOME/applications" >/dev/null 2>&1 || true
fi

echo -e "\n${GREEN}${BOLD}Minimal has been completely removed from your system.${RESET}"
