#!/usr/bin/env python3
"""
Modern GTK3 'Exit Options' panel with dynamic icons and HiDPI support.

Requirements:
- Python 3
- PyGObject (Gtk-3.0)
- Optional: wmctrl (to prevent duplicate windows)
- Optional: i3lock (for lock)
"""

import sys
import os
import shutil
import subprocess
import signal
import logging
from pathlib import Path

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GdkPixbuf, GLib

# ---------------------------
# Config
# ---------------------------
SCRIPT_DIR = Path(__file__).resolve().parent
ICONS_DIR = SCRIPT_DIR / "icons"
HOME = Path.home()

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 80
BUTTON_SIZE = 70
BOX_SPACING = 40

# Logging
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
logger = logging.getLogger("PowerWindow")

# ---------------------------
# Utility functions
# ---------------------------
def safe_run(cmd_list, check=False):
    try:
        cp = subprocess.run(cmd_list, check=check, capture_output=True, text=True)
        if cp.returncode != 0:
            logger.warning("Command %s failed (%d): %s", cmd_list, cp.returncode, cp.stderr.strip())
        return cp
    except FileNotFoundError:
        logger.warning("Command not found: %s", cmd_list[0])
        return None
    except Exception as e:
        logger.exception("Error running command %s: %s", cmd_list, e)
        return None


def is_window_active_by_name(name: str) -> bool:
    if not shutil.which("wmctrl"):
        logger.debug("wmctrl not found, skipping duplicate-window check")
        return False
    try:
        cp = subprocess.run(["wmctrl", "-l", "-x"], capture_output=True, text=True)
        return any(name in line for line in (cp.stdout or "").splitlines())
    except Exception as e:
        logger.warning("wmctrl check failed: %s", e)
        return False


def load_scaled_pixbuf(path: Path, size: int, scale: int = 1) -> GdkPixbuf.Pixbuf:
    try:
        pix = GdkPixbuf.Pixbuf.new_from_file(path.as_posix())
        return pix.scale_simple(size * scale, size * scale, GdkPixbuf.InterpType.BILINEAR)
    except Exception as e:
        logger.warning("Failed to load icon '%s': %s", path, e)
        return GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, True, 8, size * scale, size * scale)


# ---------------------------
# Main class
# ---------------------------
class PowerWindow:
    def __init__(self):
        self.window = Gtk.Window(title="Exit Options")
        self.window.set_default_size(WINDOW_WIDTH, WINDOW_HEIGHT)
        self.window.set_resizable(False)
        self.window.set_decorated(False)
        self.window.set_app_paintable(True)
        self.window.connect("destroy", Gtk.main_quit)
        self.window.connect("key-press-event", self._on_key_press)
        self.window.connect("size-allocate", self._on_resize)
        self.current_scale = 1

        # Transparent if composited
        screen = Gdk.Screen.get_default()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.window.set_visual(visual)

        # Outer box
        self.box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=BOX_SPACING)
        self.box.set_margin_top(8)
        self.box.set_margin_bottom(8)
        self.box.set_margin_left(12)
        self.box.set_margin_right(12)
        self.window.add(self.box)

        # CSS
        self.css_provider = Gtk.CssProvider()
        self._load_css()

        # Button pixbuf cache
        self._pixbuf_cache = {}

        # Create buttons
        self._create_buttons()

        # Signal handlers
        signal.signal(signal.SIGTERM, self._signal_quit)
        signal.signal(signal.SIGINT, self._signal_quit)

    # ---------------------------
    # CSS
    # ---------------------------
    def _load_css(self):
        css = """
        window {
            background-color: rgba(0,0,0,0.35);
        }
        .power-button {
            transition: opacity 120ms ease;
            border-radius: 12px;
            padding: 2px;
        }
        .power-button:hover {
            opacity: 1.0;
        }
        """
        try:
            self.css_provider.load_from_data(css.encode())
            Gtk.StyleContext.add_provider_for_screen(
                Gdk.Screen.get_default(), self.css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            )
        except Exception as e:
            logger.warning("Failed to load CSS: %s", e)

    # ---------------------------
    # Scale factor
    # ---------------------------
    def _get_scale_factor(self):
        screen = self.window.get_screen()
        gtk_scale = self.window.get_scale_factor()
        dpi = screen.get_resolution() or 96
        dpi_scale = 2 if dpi >= 192 else 1.5 if dpi >= 144 else 1
        return max(gtk_scale, dpi_scale)

    # ---------------------------
    # Button creation
    # ---------------------------
    def _create_power_button(self, default_name: str, hover_name: str, handler):
        default_path = ICONS_DIR / default_name
        hover_path   = ICONS_DIR / hover_name

        scale = self._get_scale_factor()
        default_pix = load_scaled_pixbuf(default_path, BUTTON_SIZE, scale)
        hover_pix   = load_scaled_pixbuf(hover_path, BUTTON_SIZE, scale)

        image = Gtk.Image.new_from_pixbuf(default_pix)
        event_box = Gtk.EventBox()
        event_box.set_property("can-focus", True)

        event_box.default_pix = default_pix
        event_box.hover_pix   = hover_pix
        event_box.default_path = default_path
        event_box.hover_path   = hover_path

        # Hover handlers
        def on_enter(widget, event): widget.get_child().set_from_pixbuf(widget.hover_pix); return False
        def on_leave(widget, event): widget.get_child().set_from_pixbuf(widget.default_pix); return False
        def on_click(widget, event): GLib.idle_add(handler, widget, event); return True

        event_box.connect("enter-notify-event", on_enter)
        event_box.connect("leave-notify-event", on_leave)
        event_box.connect("button-release-event", on_click)

        event_box.add(image)
        style = event_box.get_style_context()
        style.add_provider(self.css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        style.add_class("power-button")

        self.box.pack_start(event_box, False, False, 0)
        return event_box

    # ---------------------------
    # Button handlers
    # ---------------------------
    def handle_cancel(self, widget=None, event=None):
        logger.info("Cancel pressed -> closing UI")
        Gtk.main_quit()

    def handle_lock(self, widget=None, event=None):
        logger.info("Lock pressed -> launching i3lock if available")
        self.window.hide()
        lock_wallpaper = HOME / ".local/share/backgrounds/lock_wallpaper_4K.png"
        cmd = ["i3lock", "-i", str(lock_wallpaper)] if lock_wallpaper.exists() else ["i3lock"]
        safe_run(cmd)
        Gtk.main_quit()

    def handle_logout(self, widget=None, event=None):
        logger.info("Logout pressed -> terminating user session")
        uid = str(os.getuid())
        safe_run(["loginctl", "terminate-user", uid])
        Gtk.main_quit()

    def handle_reboot(self, widget=None, event=None):
        logger.info("Reboot pressed -> calling systemctl reboot")
        safe_run(["systemctl", "reboot"])
        Gtk.main_quit()

    def handle_shutdown(self, widget=None, event=None):
        logger.info("Shutdown pressed -> calling systemctl poweroff")
        safe_run(["systemctl", "poweroff"])
        Gtk.main_quit()

    # ---------------------------
    # Create all buttons
    # ---------------------------
    def _create_buttons(self):
        self.cancel_box = self._create_power_button("cancel_default.svg", "cancel_hover.svg", self.handle_cancel)
        self.lock_box = self._create_power_button("lock_default.svg", "lock_hover.svg", self.handle_lock)
        self.logout_box = self._create_power_button("logout_default.svg", "logout_hover.svg", self.handle_logout)
        self.reboot_box = self._create_power_button("reboot_default.svg", "reboot_hover.svg", self.handle_reboot)
        self.shutdown_box = self._create_power_button("shutdown_default.svg", "shutdown_hover.svg", self.handle_shutdown)

    # ---------------------------
    # Dynamic resizing
    # ---------------------------
    def _on_resize(self, widget, allocation):
        scale = self._get_scale_factor()
        if scale == self.current_scale: return
        self.current_scale = scale
        logger.info(f"Scaling icons → scale factor: {scale}")

        for btn in (self.cancel_box, self.lock_box, self.logout_box, self.reboot_box, self.shutdown_box):
            btn.default_pix = load_scaled_pixbuf(btn.default_path, BUTTON_SIZE, scale)
            btn.hover_pix   = load_scaled_pixbuf(btn.hover_path, BUTTON_SIZE, scale)
            btn.get_child().set_from_pixbuf(btn.default_pix)

        self.window.queue_draw()

    # ---------------------------
    # Keypress
    # ---------------------------
    def _on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            Gtk.main_quit()
        elif event.keyval in (Gdk.KEY_l, Gdk.KEY_L):
            GLib.idle_add(self.handle_lock)
        return False

    # ---------------------------
    # Signal quit
    # ---------------------------
    def _signal_quit(self, signum, frame):
        logger.info("Received signal %s -> quitting", signum)
        Gtk.main_quit()

    # ---------------------------
    # Show
    # ---------------------------
    def show_and_run(self):
        if is_window_active_by_name("Exit Options"):
            logger.info("Exit Options window already active; exiting.")
            return
        self.window.show_all()
        Gtk.main()


# ---------------------------
# Entrypoint
# ---------------------------
def main():
    try:
        app = PowerWindow()
        app.show_and_run()
    except Exception as e:
        logger.exception("Fatal error: %s", e)
        sys.exit(1)


if __name__ == "__main__":
    main()
