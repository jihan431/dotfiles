#!/bin/bash

# rofi-wifi-menu.sh
# Custom Wi-Fi menu using nmcli and rofi
# Limits display to only available networks

# Rofi configuration
THEME="/home/lyon/.config/rofi/network-menu.rasi"

# Get list of networks
# IN-USE: * for connected
# SSID: Network name
# SECURITY: Security type
# BARS: Signal strength
# -t for terse (colon separated), -f for fields
notify-send "Getting Wi-Fi networks..."
LIST=$(nmcli -t -f IN-USE,SSID,SECURITY device wifi list --rescan yes)

# Build formatted list and data arrays
declare -a SSIDS
declare -a SECURITIES
declare -A SEEN

OPTIONS=""
INDEX=0

# Use loop to process raw list
while IFS=: read -r IN_USE SSID SECURITY; do
    # Unescape colons in SSID if needed (nmcli escapes them as \:)
    SSID=$(echo "$SSID" | sed 's/\\:/:/g')
    
    # Skip rows with empty SSID (hidden networks sometimes output empty)
    if [[ -z "$SSID" ]]; then continue; fi
    
    # Deduplicate SSIDs (nmcli shows all APs)
    if [[ -n "${SEEN[$SSID]}" ]]; then continue; fi
    SEEN[$SSID]=1
    
    # Store data
    SSIDS[$INDEX]="$SSID"
    SECURITIES[$INDEX]="$SECURITY"
    
    # visual formatting
    # Active indicator
    ACTIVE_MARK=""
    if [[ "$IN_USE" == "*" ]]; then
        ACTIVE_MARK="<span color='#a6da95'><b>(Connected)</b></span>"
    fi
    
    # Security/Lock visual
    LOCK=""
    if [[ "$SECURITY" != "" ]] && [[ "$SECURITY" != "--" ]]; then
        LOCK=""
    fi
    
    # Format: "SSID   Lock   Active"
    # Using Pango markup
    DISPLAY="<b>$SSID</b>   <span size='small' color='#6c6c8c'>$LOCK $SECURITY</span>   $ACTIVE_MARK"
    
    OPTIONS+="$DISPLAY\n"
    ((INDEX++))
    
done <<< "$LIST"

# Show rofi menu
# -format i returns the selected index (0-based)
# -markup-rows enables Pango markup
CHOSEN_INDEX=$(echo -e "$OPTIONS" | rofi -dmenu -i -selected-row 0 -p "Wi-Fi" -theme "$THEME" -markup-rows -format i)

# Exit if nothing selected
if [ -z "$CHOSEN_INDEX" ]; then
    exit 0
fi

# Retrieve real data using index
SSID="${SSIDS[$CHOSEN_INDEX]}"
CHOSEN_SECURITY="${SECURITIES[$CHOSEN_INDEX]}"

notify-send "Connecting to $SSID..."

# Check if we have a saved connection for this SSID
# Using exact string match for connection name is safer, but connection names are not always SSID.
# nmcli connection show --active? 
# Simplest: try up, if fail, connect.
if nmcli connection show "$SSID" > /dev/null 2>&1; then
    nmcli connection up "$SSID"
else
    # New connection
    # Check if security is needed
    if [[ "$CHOSEN_SECURITY" != "" ]] && [[ "$CHOSEN_SECURITY" != "--" ]]; then
        # Needs password
        PASSWORD=$(rofi -dmenu -p "Password for $SSID" -password -theme "$THEME")
        if [ -n "$PASSWORD" ]; then
            nmcli device wifi connect "$SSID" password "$PASSWORD"
        fi
    else
        # Open network
        nmcli device wifi connect "$SSID"
    fi
fi

if [ $? -eq 0 ]; then
    notify-send "Connected to $SSID"
else
    notify-send "Connection failed"
fi
