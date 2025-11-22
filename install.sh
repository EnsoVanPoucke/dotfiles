#!/bin/bash

# Dotfiles Installation Script
# This script creates symbolic links for all configuration files

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}   Dotfiles Installation Script${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/directory if it exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing $target to ${target}.backup${NC}"
        mv "$target" "${target}.backup"
    fi
    
    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create the symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked: $target -> $source"
}

echo -e "${BLUE}Installing dotfiles from: ${DOTFILES_DIR}${NC}\n"

# i3 window manager
if [ -d "$DOTFILES_DIR/i3" ]; then
    echo -e "${BLUE}[i3]${NC}"
    create_symlink "$DOTFILES_DIR/i3" "$CONFIG_DIR/i3"
fi

# Kitty terminal
if [ -d "$DOTFILES_DIR/kitty" ]; then
    echo -e "\n${BLUE}[kitty]${NC}"
    create_symlink "$DOTFILES_DIR/kitty" "$CONFIG_DIR/kitty"
fi

# Polybar
if [ -d "$DOTFILES_DIR/polybar" ]; then
    echo -e "\n${BLUE}[polybar]${NC}"
    create_symlink "$DOTFILES_DIR/polybar" "$CONFIG_DIR/polybar"
fi

# Rofi
if [ -d "$DOTFILES_DIR/rofi" ]; then
    echo -e "\n${BLUE}[rofi]${NC}"
    create_symlink "$DOTFILES_DIR/rofi" "$CONFIG_DIR/rofi"
fi

# Picom
if [ -d "$DOTFILES_DIR/picom" ]; then
    echo -e "\n${BLUE}[picom]${NC}"
    create_symlink "$DOTFILES_DIR/picom" "$CONFIG_DIR/picom"
fi

# Starship
if [ -d "$DOTFILES_DIR/starship" ]; then
    echo -e "\n${BLUE}[starship]${NC}"
    create_symlink "$DOTFILES_DIR/starship" "$CONFIG_DIR/starship"
fi

# MPD
if [ -d "$DOTFILES_DIR/mpd" ]; then
    echo -e "\n${BLUE}[mpd]${NC}"
    create_symlink "$DOTFILES_DIR/mpd" "$CONFIG_DIR/mpd"
fi

# RMPC
if [ -d "$DOTFILES_DIR/rmpc" ]; then
    echo -e "\n${BLUE}[rmpc]${NC}"
    create_symlink "$DOTFILES_DIR/rmpc" "$CONFIG_DIR/rmpc"
fi

# Ranger
if [ -d "$DOTFILES_DIR/ranger" ]; then
    echo -e "\n${BLUE}[ranger]${NC}"
    create_symlink "$DOTFILES_DIR/ranger" "$CONFIG_DIR/ranger"
fi

# Wallpaper
if [ -f "$DOTFILES_DIR/wallpapers/DesktopWallpaper.png" ]; then
    echo -e "\n${BLUE}[wallpaper]${NC}"
    echo -e "${GREEN}✓${NC} Wallpaper found: wallpapers/DesktopWallpaper.png"
    echo -e "  Wallpaper will be loaded automatically by i3 on next login/reload"
fi

echo -e "\n${BLUE}=====================================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${BLUE}=====================================${NC}\n"
echo -e "${YELLOW}Note:${NC} If you had existing configurations, they have been backed up with a .backup extension."
echo -e "${YELLOW}Note:${NC} You may need to reload your window manager (Mod+Shift+R in i3) for changes to take effect.\n"
