# dotfiles

This repository contains my personal configuration files (dotfiles) for various command-line tools and development environments.

## Contents

- `i3` – i3 tiling window manager
- `polybar` – polybar status bar
- `rofi` – application launcher and menu
- `kitty` – terminal emulator
- `starship` – shell prompt
- `mpd` – music player daemon
- `rmpc` – terminal mpd client
- `picom` – compositor settings for transparency and animations
- `ranger` – terminal file manager

- Other configuration files for tools and editors

## Installation

```bash
# Clone the repo
git clone https://github.com/EnsoVanPoucke/dotfiles.git ~/dotfiles

# Navigate to the repo
cd ~/dotfiles

# Example: link i3 config
ln -s ~/dotfiles/i3/config ~/.config/i3/config

# Repeat for other configs
