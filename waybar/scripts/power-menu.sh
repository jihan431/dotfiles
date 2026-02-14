#!/usr/bin/env bash

options="\n\n\n"

chosen="$(echo -e "$options" | rofi -dmenu -theme power.rasi -theme-str '#window { fullscreen: true; }'
)",

case $chosen in
    "")
        # Add your lock command here, e.g., swaylock or hyprlock
        hyprlock ;;
    "")
        hyprctl dispatch exit ;;
    "")
        systemctl reboot ;;
    "")
        systemctl poweroff ;;
esac
