#!/bin/bash

# brightness-control.sh

function get_brightness {
    brightnessctl -m | cut -d, -f4 | tr -d '%'
}

function send_notification {
    brightness=$(get_brightness)
    notify-send -h string:x-canonical-private-synchronous:brightness_notification \
        -h int:value:$brightness "Brightness: ${brightness}%"
}

case $1 in
    i)
        brightnessctl set +5%
        send_notification
        ;;
    d)
        brightnessctl set 5%-
        # Limit minimum brightness to 10%
        current=$(get_brightness)
        if [ "$current" -lt 10 ]; then
            brightnessctl set 10%
        fi
        send_notification
        ;;
esac
