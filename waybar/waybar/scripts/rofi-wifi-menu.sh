#!/bin/bash

# rofi-wifi-menu.sh
# Custom Wi-Fi menu using nmcli and rofi
# Limits display to only available networks

# Rofi configuration
# Use the custom theme we created
THEME="/home/lyon/.config/rofi/network-menu.rasi"

# Get list of networks
# Fields: SSID, SECURITY, BARS
# We use awk to format it nicely
# We use -rescan yes to get fresh list
notify-send "Getting Wi-Fi networks..."
LIST=$(nmcli --fields "SSID,SECURITY,BARS" device wifi list --rescan yes | sed 1d | sed 's/  */ /g' | sed -E "s/^ +//g" | sed -E "s/ +$//g" | uniq)

# Should we add a toggle option? No, user requested ONLY networks.
# But we might want to filter out empty SSIDs
LIST_CLEAN=$(echo "$LIST" | grep -v "^--")

# Show rofi menu
# We use -p "Wi-Fi" for prompt
CHOSEN=$(echo "$LIST_CLEAN" | rofi -dmenu -i -selected-row 0 -p "Wi-Fi" -theme "$THEME")

# Exit if nothing selected
if [ -z "$CHOSEN" ]; then
    exit 0
fi

# Extract SSID (assuming SSID is the first field and might have spaces, but usually separated by security which has distinctive format or we can just assume SSID is everything before the last two columns if properly formatted, but nmcli output varies.
# Let's try to grab SSID. The output from our sed command compacted spaces.
# A safer way to get SSID is to use the chosen line to grep the full info or just assume SSID.
# Simple approach: extracting SSID is tricky if it has spaces.
# Let's use the line as is to find the network, or better, re-parse.
# Actually, let's just use the CHOSEN line to extract SSID. 
# "SSID SECURITY BARS"
# Security usually "WPA2" "WPA1" "--" etc. Bars "▂▄▆█"
# We can assume the last column is bars, second to last is security.
# But security can be "WPA2 802.1X".
# Let's use a standard trick: assume SSID is everything up to the known security columns or use nmcli with strictly separated columns.

# Better approach for selection:
# Use unique SSIDs.
SSID=$(echo "$CHOSEN" | awk -F'  ' '{print $1}' | awk '{$1=$1;print}')
# The above awk might fail if we compacted spaces.
# Let's try to just select the SSID directly if we can.
# Alternatively, simpler script logic:

# Get SSID from the selected line
# We can assume the BARS are at the end.
# Let's just try to connect to the raw choice string? No.

# Let's refine the list generation to make parsing easier.
# Use tab separator for display but might look ugly.
# Or just accept that we need to parse it back.

# Let's try to simply extract the SSID.
# SSID is usually the first part.
# Let's rely on nmcli to handle the connection if we pass the SSID.
# But we need the exact SSID.

# Refined command to get proper columns, maybe wider spacing?
# nmcli -f SSID,SECURITY,BARS device wifi list
# We can maintain the spacing and use fixed width parsing? No, Rofi trims.

# Workaround:
# 1. Get list of SSIDs separately for logic, but we need to show info.
# 2. Use a specific delimiter that is unlikely to be in SSID?
# Let's use the fact that BARS (▂▄▆█) are distinctive.
# We can use that as a marker? No.

# Let's use `nmcli`'s built-in connect which is smart enough usually.
# If we just pass the SSID.
# Let's try to get the SSID by removing the last few words.
# Bars is 1 word. Security is usually 1 word (WPA2).
# So remove last 2 words?
# Some networks have no security (--) and bars.
# Some might have "WPA2 802.1X".

# Let's simplify: Display SSID only?
# User might want to see signal strength.

# Let's try this:
# Pass the full line to `nmcli device wifi connect`? No, it expects SSID.

# Let's try to extract SSID by matching the line against the list again?
# Or we can just use `nmcli` to connect assuming the user selected a known index? No, list changes.

# Okay, simpler approach used by many scripts:
# Get the SSID from the selection key.
# Use `-format` in rofi?

# Let's stick to a robust parsing:
# Get SSID by removing the last columns.
# Security column width is variable.
# Bars is 4 chars usually? No, it's a string.

# Let's just ask user for password if connection fails?
# Or check if saved.

# Function to get SSID
read -r SSID <<< $(echo "$CHOSEN" | sed -r 's/\s+[^[:space:]]+\s+[^[:space:]]+$//')
# This removes the last two whitespace-separated fields (Bars and Security).
# Does it work?
# "My Hostspot WPA2 ▂▄▆█" -> "My Hotspot"
# "OpenWifi -- ▂▄▆█" -> "OpenWifi"
# Seems reasonable.

# Trim trailing whitespace
SSID=$(echo "$SSID" | sed 's/ *$//')

notify-send "Connecting to $SSID..."

# Check if we have a saved connection for this SSID
if nmcli connection show "$SSID" > /dev/null 2>&1; then
    nmcli connection up "$SSID"
else
    # New connection
    # Check if security is needed
    # We can check the CHOSEN string for security type
    if [[ "$CHOSEN" =~ "WPA" ]] || [[ "$CHOSEN" =~ "WEP" ]]; then
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
