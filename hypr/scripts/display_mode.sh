#!/bin/bash

set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
state_file="$state_dir/display_mode"

mkdir -p "$state_dir"

hdmi_connected() {
    hyprctl monitors | grep -q '^Monitor HDMI-A-1 '
}

apply_layout() {
    case "$1" in
        native)
            hyprctl keyword monitor "eDP-1,1920x1080@60.0,0x0,1"
            hyprctl keyword monitor "HDMI-A-1,disable"
            ;;
        extend)
            hyprctl keyword monitor "eDP-1,1920x1080@60.0,0x0,1"
            hyprctl keyword monitor "HDMI-A-1,1920x1080@60.0,1920x0,1"
            ;;
        mirror)
            hyprctl keyword monitor "HDMI-A-1,1920x1080@60.0,0x0,1"
            hyprctl keyword monitor "eDP-1,1920x1080@60.0,0x0,1,mirror,HDMI-A-1"
            ;;
        external)
            hyprctl keyword monitor "eDP-1,disable"
            hyprctl keyword monitor "HDMI-A-1,1920x1080@60.0,0x0,1"
            ;;
    esac
}

current_mode=""
if [[ -f "$state_file" ]]; then
    current_mode="$(<"$state_file")"
fi

if [[ "${1:-}" == "init" ]]; then
    if hdmi_connected; then
        current_mode="extend"
    else
        current_mode="native"
    fi
else
    if ! hdmi_connected; then
        current_mode="native"
    elif [[ -z "$current_mode" ]]; then
        current_mode="extend"
    else
        case "$current_mode" in
            native) current_mode="extend" ;;
            extend) current_mode="mirror" ;;
            mirror) current_mode="external" ;;
            external) current_mode="native" ;;
            *) current_mode="extend" ;;
        esac
    fi
fi

printf '%s\n' "$current_mode" > "$state_file"
apply_layout "$current_mode"