# Just-Dots

This repository contains my personal dotfiles and configuration files for the Hyprland ecosystem, Waybar, and Zsh.

Updated for clean CachyOS install with no default DE.

## Contents

- **hypr**: Configuration files for the [Hyprland](https://github.com/hyprwm/Hyprland) window manager.
- **waybar**: Configuration files for the [Waybar](https://github.com/Alexays/Waybar) status bar.
- **.zshrc and .oh-my-zsh**: Configuration files and customizations for the [Zsh](https://www.zsh.org/) shell.

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Thaylor-Hugo/Just-Dots.git
    cd Just-Dots
    ```

2. Run the install dots script:
    ```sh
    ./install_dots.sh
    ```
    It creates a symlink of this repo files on the expected location (e.g. ~/.config). This way its possible to update the files direct in this repo with the git workflow without needing to recopy the files in every change.

## Dependencies

- **Just-Wifi-Menu**: Custom Wi-Fi menu for Waybar/Hyprland ([Thaylor-Hugo/Just-Wifi-Menu](https://github.com/Thaylor-Hugo/Just-Wifi-Menu)), automatically cloned and installed by `install_dots.sh` (requires `gtk4`, `gtk4-layer-shell`, `networkmanager`, and `rust`/`cargo` to build).
- `python-pyqt6`: Required for the Waybar battery UI (`waybar/scripts/battery/batteryUI.py`).
    ```sh
    sudo pacman -S --asexplicit python-pyqt6
    ```
