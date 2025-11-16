#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#
# This script is used to set up the monitor settings for a Linux system.
# It configures the display resolution, refresh rate, and other settings using xrandr.
# tested on a 1 monitor setup

function settings() {
    # this is the display name, e.g., HDMI-1, DP-1, etc get these from running xrandr.
    # for example mine is DisplayPort-2
    local display_port="$2"
    local resolution="$3"
    local refresh_rate="$4"

    # Check if xrandr is installed
    if ! command -v xrandr &>/dev/null; then
        echo "xrandr could not be found. Please install it to use this script."
        exit 1
    fi

    if [[ -z "$display_port" ]] && [[ -z "$resolution" ]] && [[ -z "$refresh_rate" ]]; then
        echo "Usage: $0 --s <display_port> <resolution> <refresh_rate>"
        echo "Example: $0 --s DisplayPort-2 1920x1080 60.00"
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
        echo "Resolution not provided."
        echo "Available resolutions for $display_port:"
        xrandr --query | grep -A20 "^$display_port" | awk '/^[ ]+[0-9]+x[0-9]+/ {print $1}'
        exit 1
    else
        # Check if $resolution is valid for the given display
        if ! xrandr --query | grep -A20 "^$display_port" | awk '/^[ ]+[0-9]+x[0-9]+/ {print $1}' | grep -wq "$resolution"; then
            echo "Invalid resolution: $resolution"
            echo "Available resolutions for $display_port:"
            xrandr --query | grep -A20 "^$display_port" | awk '/^[ ]+[0-9]+x[0-9]+/ {print $1}'
            exit 1
        fi
    fi

    if [[ -z "$refresh_rate" ]]; then
        echo "Please provide a refresh rate. Example: 120.00"
        exit 1
    else
        # Check if $refresh_rate is valid for the given display and resolution
        # using AWK to parse and extract the available refresh rates for the specified resolution
        # making sure to strip any non-numeric characters before comparing
        available_rates=$(xrandr --query | awk -v disp="$display_port" -v res="$resolution" '
            $1 == disp {found=1; next}
            found && $1 ~ /^[0-9]+x[0-9]+/ {
                if ($1 == res) {
                    for(i=2;i<=NF;i++) {
                        gsub(/[^0-9.]/, "", $i)
                        if($i != "") print $i
                    }
                } else {found=0}
            }
        ')
        if ! echo "$available_rates" | grep -wq "$refresh_rate"; then
            echo "Invalid refresh rate: $refresh_rate"
            echo "Available refresh rates for $display_port at $resolution:"
            echo "$available_rates"
            exit 1
        fi
    fi

    # Set the monitor settings using xrandr
    xrandr --output "$display_port" --mode "$resolution" --rate "$refresh_rate"
    if [ $? -ne 0 ]; then
        echo "Failed to set monitor settings. Please check the display port and resolution."
        exit 1
    fi
    echo "Monitor settings updated successfully: $display_port $resolution $refresh_rate"
}

function monitors() {
    # Show all connected displays with their port, current resolution, and refresh rate
    xrandr --query | awk '
        /^[^ ]+ connected/ {
            display=$1
            # Find the current mode and refresh rate marked with "*"
            while (getline && $1 ~ /^[ ]*[0-9]+x[0-9]+/) {
                res=$1
                for(i=2;i<=NF;i++) {
                    if ($i ~ /\*/) {
                        rate=$i
                        gsub(/[^0-9.]/, "", rate)
                        print display, res, rate
                        break
                    }
                }
                if (rate != "") break
            }
            rate=""
        }
    '
}
function help(){
        echo "Usage: $0 --s <display_port> <resolution> <refresh_rate>"
        echo "Example: $0 --s DisplayPort-2 1920x1080 60.00"
        exit 1
}

if [ "$1" == "--monitors" ] || [ "$1" == "--m" ]; then
    monitors
elif [ "$1" == "--help" ] || [ "$1" == "--h" ]; then
    help
elif  [ "$1" == "--settings" ] || [ "$1" == "--s" ] || [ "$1" == "--set" ]; then
    settings "$@"
else
    help
fi
