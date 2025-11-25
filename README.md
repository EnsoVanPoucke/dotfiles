# dotfiles

These are my personal **Linux** dotfiles - a collection of configuration files. 
You’re welcome to use them as a reference or starting point for your own setup.

## Design philosophy

A minimalistic, modern design built for maximum efficiency. The tiling window manager setup keeps every element functional and purposeful, with components customized to maintain a consistent, distraction-free environment.

*[View screenshots](screenshots/)*

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
- `vscode` – code editor settings and preferences
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

As it is, the i3 configuration file points to:

**~/.local/share/backgrounds/desktop_wallpaper_4K.png**

You can either change this path where it says **$desktopWallpaper**, or copy the included wallpapers to this exact location.

### Copy wallpapers to the exact location

First, navigate into the cloned **dotfiles** repository.
Then, create the backgrounds folder and copy the wallpapers into it:

```bash
mkdir -p ~/.local/share/backgrounds
cp wallpapers/* ~/.local/share/backgrounds/
```
