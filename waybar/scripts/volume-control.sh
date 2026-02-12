#!/bin/bash

# volume-control.sh

function get_volume {
    pamixer --get-volume
}

function is_muted {
    pamixer --get-mute
}

function send_notification {
    if [ "$(is_muted)" = "true" ]; then
        notify-send -h string:x-canonical-private-synchronous:volume_notification \
            "Volume: Muted"
    else
        volume=$(get_volume)
        notify-send -h string:x-canonical-private-synchronous:volume_notification \
            -h int:value:$volume "Volume: ${volume}%"
    fi
}

case $1 in
    i)
        pamixer -i 5
        send_notification
        ;;
    d)
        pamixer -d 5
        send_notification
        ;;
    m)
        pamixer -t
        send_notification
        ;;
esac
