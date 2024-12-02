#!/bin/bash

# Install dotfiles
# Assumed that the Repo is cloned in the home directory
# Assumed that all dependencies are installed
# Don't forget the sudo non-password access for the battery scripts

# Check if the user is root
if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

# Install battery life scripts
sudo cp ~/Just-Dots/waybar/scripts/battery/battery_life.sh /usr/local/bin/battery_life.sh
sudo cp ~/Just-Dots/waybar/scripts/battery/change_power_mode.sh /usr/local/bin/change_power_mode.sh
sudo cp ~/Just-Dots/waybar/scripts/battery/full_charge.sh /usr/local/bin/full_charge.sh
sudo cp ~/Just-Dots/waybar/scripts/battery/restart_tlp.sh /usr/local/bin/restart_tlp.sh

sudo chown root:root /usr/local/bin/battery_life.sh
sudo chown root:root /usr/local/bin/change_power_mode.sh
sudo chown root:root /usr/local/bin/full_charge.sh
sudo chown root:root /usr/local/bin/restart_tlp.sh

sudo chmod 700 /usr/local/bin/battery_life.sh
sudo chmod 700 /usr/local/bin/change_power_mode.sh
sudo chmod 700 /usr/local/bin/full_charge.sh
sudo chmod 700 /usr/local/bin/restart_tlp.sh

# Create a symbolic link to the dotfiles
ln -sf ~/Just-Dots/waybar ~/.config/waybar
ln -sf ~/Just-Dots/hypr ~/.config/hypr
ln -sf ~/Just-Dots/.zshrc ~/.zshrc
ln -sf ~/Just-Dots/.oh-my-zsh/custom/themes/just_theme.zsh-theme ~/.oh-my-zsh/custom/themes/just_theme.zsh-theme
