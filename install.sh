#!/usr/bin/env bash

set -e

### ====== CONFIG ====== ###
CONFIG_SRC="./config"
CONFIG_DEST="$HOME/.config"
THEMES_SRC="./themes"
THEMES_DEST="$HOME/.local/share/themes"
### ===================== ###

### ==== COLORS ==== ###
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"
### ================= ###


confirm() {
    read -rp "$(echo -e "${YELLOW}?${RESET} $1 (y/n): ")" choice
    case "$choice" in 
        y|Y ) return 0 ;;
        n|N ) return 1 ;;
        * ) echo -e "${RED}Invalid response.${RESET}"; confirm "$1" ;;
    esac
}

pause() {
    read -rp "$(echo -e "${BLUE}Press Enter to continue...${RESET}")"
}

echo -e "${BLUE}---------------------------------------------"
echo -e "  Hyprland Dotfiles Installer (Safe Mode)"
echo -e "---------------------------------------------${RESET}"

# ================================
# 🛑 IMPORTANT BACKUP WARNING
# ================================
echo -e "${RED}⚠ WARNING: Before you continue ⚠${RESET}"
echo -e "${YELLOW}You should BACK UP your current configs manually.${RESET}"
echo -e ""
echo -e "If anything goes wrong or if your repo has outdated configs,"
echo -e "you will want your original files to restore."
echo -e ""
echo -e "Recommended backup commands:"
echo -e "${BLUE}"
echo "  mkdir -p ~/dotfiles_backup"
echo "  cp -r ~/.config ~/dotfiles_backup/"
echo "  cp -r ~/.local/share/themes ~/dotfiles_backup/"
echo -e "${RESET}"
pause

# Detect Wayland
if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$(pgrep -x Hyprland)" ]; then
    echo -e "${YELLOW}⚠ Wayland/Hyprland does not seem to be running.${RESET}"
    if ! confirm "Continue anyway?"; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ Wayland/Hyprland detected.${RESET}"
fi

# Check for Arch Linux
if ! command -v pacman &>/dev/null; then
    echo -e "${RED}❌ This script only supports Arch Linux.${RESET}"
    exit 1
fi

# Ask before package installation
if confirm "Install required packages?"; then
    echo -e "${GREEN}📦 Installing packages...${RESET}"
    sudo pacman -S --needed --noconfirm \
        swww cava kitty waybar rofi dunst hyprland wayland

    # Install yay if not found
    if ! command -v yay &>/dev/null; then
        echo -e "${BLUE}Installing yay...${RESET}"
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
    fi

    echo -e "${GREEN}📦 Installing wlogout (AUR)...${RESET}"
    yay -S --needed --noconfirm wlogout
else
    echo -e "${YELLOW}Skipping package installation.${RESET}"
fi


### ===== COPY DOTFILES (SAFE MODE) ===== ###
echo -e "${BLUE}---------------------------------------------"
echo -e "     Installing dotfiles (Safe Copy)"
echo -e "---------------------------------------------${RESET}"

echo -e "${YELLOW}Your existing configs will NOT be deleted.${RESET}"
echo -e "${YELLOW}Files with the same name will be overwritten.${RESET}"
echo
if confirm "Proceed with copying configs to ~/.config/?"; then
    mkdir -p "$CONFIG_DEST"
    cp -vr "$CONFIG_SRC"/* "$CONFIG_DEST"
    echo -e "${GREEN}✓ Configs copied safely.${RESET}"
else
    echo -e "${YELLOW}Skipped copying configs.${RESET}"
fi

if confirm "Copy themes to ~/.local/share/themes/?"; then
    mkdir -p "$THEMES_DEST"
    cp -vr "$THEMES_SRC"/* "$THEMES_DEST"
    echo -e "${GREEN}✓ Themes installed.${RESET}"
else
    echo -e "${YELLOW}Skipped copying themes.${RESET}"
fi


echo -e "${BLUE}---------------------------------------------"
echo -e "⚠️  SDDM theme must be installed manually:"
echo -e "   https://github.com/Keyitdev/sddm-astronaut-theme/tree/master"
echo -e "---------------------------------------------${RESET}"

echo -e "${GREEN}🎉 Installation complete!${RESET}"
echo -e "${GREEN}Remember: You can restore your backup if needed.${RESET}"
