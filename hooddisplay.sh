#!/bin/bash
# This script is used to set up the monitor settings for a Linux system.
# It configures the display resolution, refresh rate, and other settings using xrandr.
# tested on a 1 monitor setup

function set_display() {
    # this is the display name, e.g., HDMI-1, DP-1, etc get these from running xrandr.
    # for example mine is DisplayPort-2
    local display_port="$1"
    local resolution="$2"
    local refresh_rate="$3"

    # Check if xrandr is installed
    if ! command -v xrandr &>/dev/null; then
        echo "xrandr could not be found. Please install it to use this script."
        exit 1
    fi

    if [[ -z "$display_port" ]] && [[ -z "$resolution" ]] && [[ -z "$refresh_rate" ]]; then
        echo "Usage: $0 <display_port> <resolution> <refresh_rate>"
        echo "Example: $0 DisplayPort-2 1920x1080 60.00"
        exit 1
    fi

    # if empty then show the available display ports
    # if not empty then check if the display port is valid
    if [[ -z "$display_port" ]]; then
        echo "Display port not provided."
        echo "Available display ports:"
        xrandr --query | grep -E "^[^ ]+ connected" | awk '{print $1}'
        exit 1
    else
        if ! xrandr --query | grep -E "^[^ ]+ connected" | awk '{print $1}' | grep -wq "$display_port"; then
            echo "Invalid display port: $display_port"
            echo "Display ports in use:"
            xrandr --query | grep -E "^[^ ]+ connected" | awk '{print $1}'
            exit 1
        fi
    fi

    if [[ -z "$resolution" ]]; then
        # Check if $2 is a valid resolution for the given display
        if ! xrandr --query | grep -A20 "^$display_port" | awk '{print $1}' | grep -wq "$2"; then
            echo "Invalid resolution: $resolution"
            echo "Available resolutions for $display_port:"
            xrandr --query | grep -A20 "^$display_port" | awk '/^[ ]+[0-9]+x[0-9]+/ {print $1}'
            exit 1
        fi
        local res=$(xrandr | grep "*" | awk '{print $1}' | head -n 1)
        resolution="$res"
        echo "Resolution not provided, using default: $resolution"
    fi

    if [[ -z "$refresh_rate" ]]; then
        echo "Please provide a refresh rate. Example: 120.00"
        exit 1
    else
        # Check if $3 is a valid refresh rate for the given display
        if ! xrandr --query | grep -A20 "^$display_port" | awk '{print $1}' | grep -wq "$3"; then
            echo "Invalid refresh rate: $refresh_rate"
            echo "Available refresh rates for the current resolution $resolution:"
            xrandr --query | grep -A20 "^$display_port" | awk -v res="$resolution" '$1 == res {for(i=2;i<=NF;i++) if($i ~ /^[0-9.]+$/) print $i}'
            exit 1
        fi
    fi

    # Set the monitor settings using xrandr
    xrandr --output "$display" --mode "$resolution" --rate "$refresh_rate"
    if [ $? -ne 0 ]; then
        echo "Failed to set monitor settings. Please check the display port and resolution."
        exit 1
    fi
    echo "Monitor settings updated successfully: $display_port $resolution $refresh_rate"
}

set_display "$@"
