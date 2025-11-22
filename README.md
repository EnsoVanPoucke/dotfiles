# dotfiles

This repository contains my personal **Debian Linux** configuration files (dotfiles).

These files are configured to work together for a consistent and efficient workflow. While they can be used as a reference or starting point for your own setup, some adjustments may be necessary on other systems.

## Contents

- `i3` – tiling window manager
- `polybar` – status bar with custom modules
- `rofi` – application launcher and menu
- `kitty` – terminal emulator (supports GPU rendering)
- `starship` – customized shell prompt with git integration
- `mpd` – music player daemon configuration
- `rmpc` – terminal MPD client with Catppuccin Mocha theme
- `ranger` – terminal file manager
- `picom` – compositor for transparency and visual effects
- `wallpapers` – desktop wallpaper included for a complete setup

## Features

- **Consistent color scheme**: Custom color scheme across i3, polybar, starship, rmpc, wallpaper,...
- **Nerd Font support**: Icons and glyphs throughout the terminal and prompt
- **Transparency**: 88% opacity for a modern look
- **Belgian keyboard layout**: Preconfigured for Belgian AZERTY iso layout
- **Music setup**: Complete MPD + RMPC configuration with custom theme
- **Gruvbox aesthetics**: Rofi themed with gruvbox-dark-hard

## Prerequisites

Before installing these dotfiles, ensure you have the following packages installed:

### Core Requirements
```bash
sudo apt install i3 polybar rofi picom kitty feh
```

### Additional Tools
```bash
sudo apt install mpd ranger
```

### Fonts
- **CaskaydiaCove Nerd Font** (required for icons in kitty and starship)
  Download from: https://www.nerdfonts.com/
  Or install via your package manager

### Optional
- `starship` – Modern shell prompt ([installation guide](https://starship.rs/guide/#-installation))
- `rmpc` – Rust Music Player Client ([installation guide](https://github.com/mierak/rmpc))

## Installation

### Quick Install (Recommended)

Clone the repository and run the installation script:

```bash
git clone https://github.com/EnsoVanPoucke/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles
./install.sh
```

The script will:
- Create symbolic links for all configurations
- Backup any existing configs with a `.backup` extension
- Set up the proper directory structure

### Manual Installation

If you prefer to install configurations individually:

```bash
# Clone the repository
git clone https://github.com/EnsoVanPoucke/dotfiles.git ~/Github/dotfiles

# Create config directory if needed
mkdir -p ~/.config

# Link individual configs
ln -s ~/Github/dotfiles/i3 ~/.config/i3
ln -s ~/Github/dotfiles/kitty ~/.config/kitty
ln -s ~/Github/dotfiles/polybar ~/.config/polybar
ln -s ~/Github/dotfiles/rofi ~/.config/rofi
ln -s ~/Github/dotfiles/picom ~/.config/picom
ln -s ~/Github/dotfiles/starship ~/.config/starship
ln -s ~/Github/dotfiles/mpd ~/.config/mpd
ln -s ~/Github/dotfiles/rmpc ~/.config/rmpc
ln -s ~/Github/dotfiles/ranger ~/.config/ranger
```

### Post-Installation

1. **Set your wallpaper**: The included wallpaper will be used automatically. Alternatively, update the path in `i3/config`:
   ```bash
   set $desktopWallpaper ~/Github/dotfiles/wallpapers/DesktopWallpaper.png
   ```

2. **Reload i3**: Press `Mod+Shift+R` or log out and back in

3. **Enable starship**: Add to your `~/.bashrc` or `~/.zshrc`:
   ```bash
   eval "$(starship init bash)"  # or 'zsh' for zsh
   ```

## Resources

For more information about the tools used in this setup:

- [i3 Window Manager](https://i3wm.org/)
- [Polybar](https://polybar.github.io/)
- [Rofi](https://davatorium.github.io/rofi/)
- [Picom](https://github.com/yshui/picom)
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/quickstart/)
- [Starship Prompt](https://starship.rs/)
- [Music Player Daemon (MPD)](https://www.musicpd.org/)
- [RMPC](https://rmpc.mierak.dev/)
- [Ranger File Manager](https://ranger.fm/)

## License
Feel free to use and modify these configurations as you wish.
