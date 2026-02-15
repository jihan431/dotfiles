#!/bin/bash
# Battery Fill Script for Waybar
# Outputs JSON with battery info and combined CSS class

get_battery_info() {
    local capacity=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    local status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
    
    if [ -z "$capacity" ]; then
        echo '{"text": "", "tooltip": "No battery found", "class": "no-battery", "percentage": 0}'
        return
    fi

    # Round to nearest 5 for CSS class
    local level=$(( (capacity / 5) * 5 ))

    # Determine charging state and build class name
    local class="level-${level}"
    local icon=" "
    if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
        class="level-${level}-charging"
        icon="󱐋"
    fi

    # Add state suffix


    echo "{\"text\": \"${icon}\", \"tooltip\": \"Battery: ${capacity}% (${status})\", \"class\": \"${class}\", \"percentage\": ${capacity}}"
}

get_battery_info
