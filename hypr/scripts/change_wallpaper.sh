#!/bin/bash

# Change the hyprpaper wallpaper to the next wallpaper in the wallpapers directory
# Uses the hyprpaper.conf file to keep track of the current wallpaper

hyprpaper_conf="$HOME/.config/hypr/hyprpaper.conf"

wallpapers=($(ls $HOME/.config/hypr/wallpapers/*)) 

last_wallpaper=$(grep "preload" "$hyprpaper_conf" | cut -d'=' -f2 | tr -d ' ')

# Get the index of the current wallpaper
index=-1

for i in "${!wallpapers[@]}"; do
    if [[ "${wallpapers[i]}" == "$last_wallpaper" ]]; then
        index=$i
        break
    fi
done

# Set next wallpaper
next_index=$(( (index + 1) % ${#wallpapers[@]} ))

next_wallpaper="${wallpapers[next_index]}"

# Update the hyprpaper.conf file
sed -i "s|preload = .*|preload = $next_wallpaper|" "$hyprpaper_conf"
sed -i "s|wallpaper = , .*|wallpaper = , $next_wallpaper|" "$hyprpaper_conf"

# Change the wallpaper
hyprctl hyprpaper unload all
hyprctl hyprpaper preload $next_wallpaper
hyprctl hyprpaper wallpaper ", $next_wallpaper"
