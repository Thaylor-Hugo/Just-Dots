# Just-Dots

This repository contains my personal dotfiles and configuration files for the Hyprland ecosystem, Waybar, and Zsh.

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
