# dotfiles

This repository contains my personal configuration files (dotfiles) for various command-line tools and development environments.

These configs are part of my **custom Debian setup**, carefully configured to work together for a consistent and efficient workflow. While they can be used as a reference or starting point for your own setup, some adjustments may be necessary on other systems.

## Contents

- `i3` – i3 tiling window manager
- `polybar` – polybar status bar
- `rofi` – application launcher and menu
- `picom` – compositor settings for transparency and animations
- `kitty` – terminal emulator
- `starship` – shell prompt
- `mpd` – music player daemon
- `rmpc` – terminal mpd client
- `ranger` – terminal file manager

- Other configuration files for tools and editors

## Installation

⚠️ **Note:** These dotfiles are configured for my personal Debian setup. Some paths, programs, or settings may need to be adjusted on your system.

```bash
# Clone the repo
git clone https://github.com/EnsoVanPoucke/dotfiles.git ~/dotfiles

# Navigate to the repo
cd ~/dotfiles

# Example: link i3 config
ln -s ~/dotfiles/i3/config ~/.config/i3/config

# Repeat for other configs
