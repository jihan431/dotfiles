#!/bin/bash

# rofi-bluetooth.sh
# Managing Bluetooth via Rofi

# Constants
THEME="/home/lyon/dotfiles/rofi/bluetooth.rasi"

# Functions

# Power state
power_on() {
    bluetoothctl power on
}

power_off() {
    bluetoothctl power off
}

# Scan state
# We can't easily toggle scan in a one-shot menu, but we can just run a scan.
toggle_scan() {
    # If we are here, user wants to create a new scan or stop it.
    # But for a menu, usually we just want to ensure we see devices.
    # We'll just run a background scan.
    if pgrep -f "bluetoothctl scan on" > /dev/null; then
        killall bluetoothctl
        notify-send "Bluetooth" "Scan stopped."
    else
        bluetoothctl scan on &
        notify-send "Bluetooth" "Scanning started..."
    fi
}

# Get status
get_status() {
    if [ $(bluetoothctl show | grep "Powered: yes" | wc -l) -eq 1 ]; then
        echo "  Power: ON"
    else
        echo "  Power: OFF"
    fi
}

# Main Logic

STATUS=$(get_status)
OPTION_POWER_ON="󰐥  Turn On"
OPTION_POWER_OFF="󰐥  Turn Off"
OPTION_EXIT="󰅖  Exit"

# Power Check
if [[ "$STATUS" == *"ON"* ]]; then
    # Auto-Scan Logic
    # We want to ensure we have fresh devices.
    # To see new devices, we should scan for a bit and then show the list.
    # If we just background scan, `bluetoothctl devices` might not pick them up immediately if they are not cached.
    
    if ! pgrep -f "bluetoothctl scan on" > /dev/null; then
        notify-send "Bluetooth" "Scanning for new devices (4s)..."
        # Start scanning in background
        bluetoothctl scan on > /dev/null 2>&1 &
        SCAN_PID=$!
        # Wait for discovery
        sleep 4
        # We don't kill it yet, so devices list is fresh
    fi
    
    POWER_OPTION="$OPTION_POWER_OFF"
else
    POWER_OPTION="$OPTION_POWER_ON"
fi

# Build Menu
if [[ "$STATUS" == *"OFF"* ]]; then
    echo -e "$OPTION_POWER_ON\n$OPTION_EXIT" | rofi -dmenu -i -p "Bluetooth" -theme "$THEME" -mesg "$STATUS" > /tmp/rofi_bt_selection
else
    # Printing options
    echo -e "$OPTION_POWER_OFF"
    echo -e "󰑐  Rescan"
    
    # Separator (No newline at start to avoid empty box)
    echo -e "--- Devices ---"
    
    bluetoothctl devices | while read -r line; do
        MAC=$(echo "$line" | cut -d ' ' -f 2)
        NAME=$(echo "$line" | cut -d ' ' -f 3-)
        
        # Check if connected
        if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
            ICON="󰂱" 
        else
            ICON=""
        fi
        
        echo "$ICON  $NAME  <span weight='light' size='small'>($MAC)</span>"
    done
fi | rofi -dmenu -i -p "Bluetooth" -theme "$THEME" -mesg "$STATUS" -markup-rows > /tmp/rofi_bt_selection

# Handle Selection
SELECTION=$(cat /tmp/rofi_bt_selection)
rm /tmp/rofi_bt_selection

if [ -z "$SELECTION" ]; then
    exit 0
fi

case "$SELECTION" in
    "$OPTION_POWER_ON")
        power_on
        ;;
    "$OPTION_POWER_OFF")
        power_off
        ;;
    "󰑐  Rescan")
        killall bluetoothctl
        bluetoothctl scan on > /dev/null 2>&1 &
        notify-send "Bluetooth" "Rescanning..."
        ;;
    "$OPTION_EXIT")
        exit 0
        ;;
    "--- Devices ---")
        exit 0
        ;;
    *)
        # It's a device
        # Extract MAC address from the parenthesis
        MAC=$(echo "$SELECTION" | sed -n 's/.*(\(.*\)).*/\1/p')
        
        if [ -n "$MAC" ]; then
            DEV_NAME=$(echo "$SELECTION" | sed 's/  <.*//' | sed 's/^...  //')
            
            ACTION=$(echo -e "Connect\nDisconnect\nPair\nTrust\nRemove" | rofi -dmenu -i -p "$DEV_NAME" -theme "$THEME")
            
            case "$ACTION" in
                "Connect")
                    notify-send "Bluetooth" "Connecting to $DEV_NAME..."
                    bluetoothctl connect "$MAC"
                    ;;
                "Disconnect")
                    bluetoothctl disconnect "$MAC"
                    ;;
                "Pair")
                    bluetoothctl pair "$MAC"
                    ;;
                "Trust")
                    bluetoothctl trust "$MAC"
                    ;;
                "Remove")
                    bluetoothctl remove "$MAC"
                    ;;
            esac
        fi
        ;;
esac
