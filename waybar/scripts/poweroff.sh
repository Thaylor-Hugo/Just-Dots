#!/usr/bin/env bash
# Use walker in dmenu mode as a replacement for wofi.
# walker reads newline-separated options from stdin and prints the
# selected option to stdout.

choice=$(printf '%s\n' \
    "Shutdown" \
    "Reboot" \
    "Log off" \
    "Sleep" \
    "Lock" \
    "Cancel" | walker -d --width 40 --height 8)

case "${choice}" in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Lock")
        loginctl lock-session
        ;;
    "Log off")
        hyprctl dispatch exit
        ;;
esac