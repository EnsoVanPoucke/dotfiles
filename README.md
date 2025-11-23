# dotfiles

These are my personal **Linux** dotfiles - a collection of configuration files.
You’re welcome to use them as a reference or starting point for your own setup. Some tweaks may be necessary depending on your system.

## Design philosophy

This setup follows a modern, minimalistic, and visually appealing design. The goal is to reduce distractions while keeping the interface beautiful and intuitive, allowing you to stay focused and productive within your workflow. Every element — from window borders to the desktop wallpaper selection — is chosen to be functional without clutter, so your workspace feels clean and comfortable.

## Contents

- `i3` – tiling window manager
- `polybar` – status bar
- `rofi` – application launcher and menu
- `kitty` – terminal emulator
- `starship` – shell prompt customization
- `ranger` – terminal file manager
- `mpd` – music player daemon
- `rmpc` – terminal MPD client
- `picom` – compositor
- `wallpapers` – matching desktop wallpaper

## Get started

Clone the repository:

```bash
git clone https://github.com/EnsoVanPoucke/dotfiles.git
```

## Resources

For more information:

- [i3 Window Manager](https://i3wm.org/)
- [Polybar](https://polybar.github.io/)
- [Rofi](https://davatorium.github.io/rofi/)
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/quickstart/)
- [Starship Prompt](https://starship.rs/)
- [Ranger File Manager](https://ranger.fm/)
- [Music Player Daemon (MPD)](https://www.musicpd.org/)
- [RMPC](https://rmpc.mierak.dev/)
- [Picom](https://github.com/yshui/picom)
- [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads)

## Installing wallpapers

By default, the i3 configuration file points to:

**~/.local/share/backgrounds/desktop_wallpaper_4K.png**

You can either change this path in the i3 config file where it says **$desktopWallpaper**, or copy the included images to this exact location.

### Copy wallpapers

First, navigate into the cloned **dotfiles** repository.

Create the backgrounds folder if it doesn't exist, and copy the wallpapers into it:

```bash
mkdir -p ~/.local/share/backgrounds
cp wallpapers/* ~/.local/share/backgrounds/
```
