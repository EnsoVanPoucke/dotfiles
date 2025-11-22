# dotfiles

This repository contains my personal configuration files (dotfiles) for various command-line tools and development environments.

These configs are part of my **custom Debian setup**, carefully configured to work together for a consistent and efficient workflow. While they can be used as a reference or starting point for your own setup, some adjustments may be necessary on other systems.

## Contents

- `i3` – i3 tiling window manager configuration
- `polybar` – status bar with custom modules
- `rofi` – application launcher and menu (gruvbox-dark-hard theme)
- `picom` – compositor for transparency and visual effects
- `kitty` – terminal emulator with custom opacity and colors
- `starship` – customized shell prompt with git integration
- `mpd` – music player daemon configuration
- `rmpc` – terminal MPD client with Catppuccin Mocha theme
- `ranger` – terminal file manager
- `wallpapers` – desktop wallpaper included for a complete setup

## Features

- **Consistent color scheme**: Custom orange accent (#FF5500) across i3, polybar, and starship
- **Nerd Font support**: Icons and glyphs throughout the terminal and prompt
- **Transparency**: Kitty terminal with 88% opacity for a modern look
- **Belgian keyboard layout**: Preconfigured for Belgian AZERTY layout
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
  ```bash
  # Download from: https://www.nerdfonts.com/
  # Or install via your package manager
  ```

### Optional
- `starship` – Modern shell prompt ([installation guide](https://starship.rs/guide/#-installation))
- `rmpc` – Rust Music Player Client ([installation guide](https://github.com/mierak/rmpc))

## Installation

⚠️ **Note:** These dotfiles are configured for my personal Debian setup. Some paths, programs, or settings may need to be adjusted on your system.

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

## Troubleshooting

### Polybar not launching
- Check if polybar is installed: `which polybar`
- View polybar logs: `cat /tmp/polybar.log`
- Ensure the launch script is executable: `chmod +x ~/.config/polybar/launch.sh`

### Icons not showing
- Install CaskaydiaCove Nerd Font or another Nerd Font
- Verify font installation: `fc-list | grep Caskaydia`
- Restart kitty after font installation

### Keyboard layout issues
- The i3 config sets Belgian layout by default
- Change in `i3/config`: `exec_always --no-startup-id setxkbmap <your-layout>`

### Rofi theme not found
- Install rofi themes: `sudo apt install rofi-themes`
- Or change theme in `rofi/config.rasi` to one you have installed

## Customization

Feel free to customize these configs to your liking:

- **Colors**: Main accent color `#FF5500` is defined in `i3/config` variables
- **Keybindings**: Check `i3/config` for all key combinations
- **Wallpaper**: Replace `wallpapers/DesktopWallpaper.png` with your own or update the path in i3 config
- **Terminal opacity**: Adjust in `kitty/kitty.conf` (`background_opacity`)

## License
Feel free to use and modify these configurations as you wish.
