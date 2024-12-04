#!/bin/bash

# Changes the current wallpaper link for the next wallpaper in the wallpapers directory
# Uses link to auto update the wallpaper and lockscreen

current_wallpaper=$HOME/.config/hypr/wallpapers/current_wallpaper.link

wallpapers=($(ls $HOME/.config/hypr/wallpapers/*.jpg)) 

real_wallpaper=$(readlink $current_wallpaper)

# Get the index of the current wallpaper
index=-1

for i in "${!wallpapers[@]}"; do
    if [[ "${wallpapers[i]}" == "$real_wallpaper" ]]; then
        index=$i
        break
    fi
done

# Set next wallpaper
next_index=$(( (index + 1) % ${#wallpapers[@]} ))
next_wallpaper="${wallpapers[next_index]}"

# Update the link
ln -sf $next_wallpaper $current_wallpaper

# Reload hyprpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload $current_wallpaper
hyprctl hyprpaper wallpaper ", $current_wallpaper"
