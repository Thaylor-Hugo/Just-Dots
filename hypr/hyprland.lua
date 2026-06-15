-- Hyprland Lua config
-- Author: Thaylor Hugo

require("monitors")
require("workspaces")
require("hyprshortcuts")
require("hyprsubmaps")
require("hyprwinrules")

local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "walker"

hl.on("hyprland.start", function()
  hl.exec_cmd("ibus-daemon -rxRd")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("~/.config/hypr/scripts/change_wallpaper.sh")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("mako")
  hl.exec_cmd("waybar")
  hl.exec_cmd("setxkbmap -model abnt2 -layout br -variant thinkpad")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("sleep 0.9 && (pidof hyprlock || hyprlock)")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("udiskie")
  hl.exec_cmd("elephant")
  hl.exec_cmd("walker --gapplication-service")

  hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
  hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"')
end)

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_IM_MODULE", "ibus")
hl.env("QT_IM_MODULE", "ibus")
hl.env("XMODIFIERS", "@im=ibus")
hl.env("XDG_DATA_DIRS", "/usr/share:/usr/local/share:" .. os.getenv("HOME") .. "/.local/share")

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 3,
    border_size = 3,
    col = {
      active_border = {
        colors = { "rgba(070177ff)", "rgba(3cc3ffff)", "rgba(5eb7deff)", "rgba(00ffd5ff)" },
        angle = 45,
      },
      inactive_border = "rgba(222222aa)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
    snap = {
      enabled = true,
    },
  },
  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 0.9,
    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 8,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
    smart_split = true,
    use_active_for_splits = false,
  },
  master = {
    new_status = "master",
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },
  debug = {
    vfr = true,
  },
  input = {
    kb_layout = "br",
    kb_variant = "thinkpad",
    follow_mouse = 2,
    sensitivity = 0,
    numlock_by_default = true,
    touchpad = {
      natural_scroll = true,
    },
  },
  group = {
    insert_after_current = false,
    focus_removed_window = false,
    col = {
      border_active = {
        colors = { "rgba(070177ff)", "rgba(3c1081ff)", "rgba(662c95ff)", "rgba(802188ff)" },
        angle = 45,
      },
      border_inactive = "rgba(222222aa)",
    },
    groupbar = {
      col = {
        active = "rgba(3c1081ff)",
        inactive = "rgba(3c108155)",
      },
    },
  },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
