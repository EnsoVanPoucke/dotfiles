#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables - Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.config/backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false

# Parse arguments
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}Running in dry-run mode - no changes will be made${NC}\n"
fi

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Check if we're in the dotfiles directory
if [[ ! -d "$DOTFILES_DIR" ]]; then
    print_error "Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

print_success "Found dotfiles directory at $DOTFILES_DIR"
echo

# Check for required packages
echo -e "${BLUE}Checking required packages...${NC}"
MISSING_PACKAGES=()

declare -A PACKAGES=(
    ["i3"]="i3wm"
    ["polybar"]="polybar"
    ["rofi"]="rofi"
    ["kitty"]="kitty"
    ["picom"]="picom"
    ["mpd"]="mpd"
    ["starship"]="starship"
    ["code"]="VSCode"
)

for package in "${!PACKAGES[@]}"; do
    if command -v "$package" &> /dev/null; then
        print_success "${PACKAGES[$package]} is installed"
    else
        print_error "${PACKAGES[$package]} is NOT installed"
        MISSING_PACKAGES+=("$package")
    fi
done
echo

# Prompt user if packages are missing
if [[ ${#MISSING_PACKAGES[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Warning: ${#MISSING_PACKAGES[@]} package(s) are missing!${NC}"
    echo -e "${YELLOW}The following packages are not installed:${NC}"
    for pkg in "${MISSING_PACKAGES[@]}"; do
        echo -e "  - ${PACKAGES[$pkg]} ($pkg)"
    done
    echo
    echo -e "${YELLOW}Configuration files will be symlinked, but the programs won't work until installed.${NC}"
    echo
    read -p "Do you want to continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Installation aborted.${NC}"
        exit 1
    fi
    echo
fi

# Create backup directory
if [[ -d "$HOME/.config" ]]; then
    print_info "Creating backup directory: $BACKUP_DIR"
    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$BACKUP_DIR"
    fi
    echo
fi

# Function to backup and symlink entire directories
symlink_directory() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            print_warning "$name: Removing existing symlink"
            if [[ "$DRY_RUN" == false ]]; then
                rm "$target"
            fi
        else
            print_warning "$name: Backing up existing directory"
            if [[ "$DRY_RUN" == false ]]; then
                mv "$target" "$BACKUP_DIR/$(basename "$target")"
            fi
        fi
    fi

    print_info "$name: Creating symlink $target -> $source"
    if [[ "$DRY_RUN" == false ]]; then
        ln -s "$source" "$target"
    fi
    print_success "$name: Linked successfully"
}

# Function to symlink individual files
symlink_file() {
    local source="$1"
    local target="$2"
    local name="$3"

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        print_info "$name: Creating directory $target_dir"
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "$target_dir"
        fi
    fi

    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            print_warning "$name: Removing existing symlink"
            if [[ "$DRY_RUN" == false ]]; then
                rm "$target"
            fi
        else
            print_warning "$name: Backing up existing file"
            if [[ "$DRY_RUN" == false ]]; then
                mkdir -p "$BACKUP_DIR/$(dirname "$(basename "$target")")"
                mv "$target" "$BACKUP_DIR/$(basename "$target")"
            fi
        fi
    fi

    print_info "$name: Creating symlink $target -> $source"
    if [[ "$DRY_RUN" == false ]]; then
        ln -s "$source" "$target"
    fi
    print_success "$name: Linked successfully"
}

# Symlink config directories
echo -e "${BLUE}Symlinking configuration directories...${NC}"
symlink_directory "$DOTFILES_DIR/i3" "$HOME/.config/i3" "i3"
symlink_directory "$DOTFILES_DIR/polybar" "$HOME/.config/polybar" "polybar"
symlink_directory "$DOTFILES_DIR/rofi" "$HOME/.config/rofi" "rofi"
symlink_directory "$DOTFILES_DIR/kitty" "$HOME/.config/kitty" "kitty"
symlink_directory "$DOTFILES_DIR/picom" "$HOME/.config/picom" "picom"
symlink_directory "$DOTFILES_DIR/mpd" "$HOME/.config/mpd" "mpd"
echo

# Symlink individual files
echo -e "${BLUE}Symlinking individual configuration files...${NC}"
symlink_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml" "starship"
symlink_file "$DOTFILES_DIR/vscode/settings.json" "$HOME/.config/Code/User/settings.json" "VSCode"
echo

# Copy wallpapers
echo -e "${BLUE}Copying wallpapers...${NC}"
print_info "Creating backgrounds directory: ~/.local/share/backgrounds"
if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$HOME/.local/share/backgrounds"
fi

if [[ -d "$DOTFILES_DIR/wallpapers" ]]; then
    print_info "Copying wallpapers from $DOTFILES_DIR/wallpapers/"
    if [[ "$DRY_RUN" == false ]]; then
        cp -r "$DOTFILES_DIR/wallpapers/." "$HOME/.local/share/backgrounds/"
    fi
    print_success "Wallpapers copied successfully"
else
    print_warning "Wallpapers directory not found"
fi
echo

# Create required directories
echo -e "${BLUE}Creating required directories...${NC}"
print_info "Creating Screenshots directory: ~/Pictures/Screenshots"
if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$HOME/Pictures/Screenshots"
fi
print_success "Screenshots directory created"

print_info "Creating MPD directories"
if [[ "$DRY_RUN" == false ]]; then
    mkdir -p "$HOME/.local/share/mpd/playlists"
    mkdir -p "$HOME/.cache/mpd"
fi
print_success "MPD directories created"
echo

# Final message
if [[ "$DRY_RUN" == true ]]; then
    echo -e "${YELLOW}Dry-run complete. No changes were made.${NC}"
    echo -e "${YELLOW}Run without --dry-run to apply changes.${NC}"
else
    echo -e "${GREEN}Installation complete!${NC}"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Reload i3: \$mod+Shift+r"
    echo "  2. Restart polybar: killall polybar && polybar &"
    echo "  3. Enable starship in your shell config"
    echo "  4. Restart VSCode to apply settings"
    echo
    if [[ -d "$BACKUP_DIR" ]]; then
        echo -e "${YELLOW}Backup of your previous configs saved to:${NC}"
        echo "  $BACKUP_DIR"
    fi
fi