#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

# Get the number of minutes from the argument
VALUE=$1
# parse the input using sed to check whether or not they want minutes or seconds
# is used to match the end of
AMOUNT=$(echo "$VALUE" | sed 's/[^0-9]*$//')
UNIT=$(echo "$VALUE" | sed 's/[0-9]*//')

TIME=$AMOUNT

# check if they want to shutdown or a timer by default shutdown command is 60 secs
check() {
    if [[ $VALUE == "shutdown" ]]; then
        TIME=60
        countdown
        shutdown 0
    elif [[ $VALUE == "-h" || $VALUE == "--help" ]]; then
        usage
    elif [[ $VALUE == "-s" || $VALUE == "--stopwatch" ]]; then
        stopwatch
    else
        timer
    fi
}
stopwatch() {
    echo "Stopwatch started. Press any key to stop."
    local elapsed=0
    while true; do
        mins=$(($elapsed / 60))
        secs=$(($elapsed % 60))
        echo -ne "\r\033[K$mins minutes and $secs seconds"
        sleep 1
        elapsed=$(($elapsed + 1))
        if read -t 0.1 -n 1; then
            break
        fi
    done
    echo -e "\nElapsed time: $mins minutes and $secs seconds."
    exit 0
}
# Function to handle timer expiration
timer() {
    if [[ $UNIT == "m" ]]; then
        echo "Timer set for $AMOUNT minutes."
        #convert to minutes
        TIME=$((AMOUNT * 60))
    elif [[ $UNIT == "s" ]]; then
        echo "Timer set for $AMOUNT seconds."
        TIME=$AMOUNT
    else
        echo "Invalid UNIT. Please use 'm' for minutes or 's' for seconds."
        exit 1
    fi
    countdown
    dunstify --urgency=normal -h string:font:'monospace 24' "⏰ Timer expired!"
    echo -e "\e[31m\nTime's up!"
}
countdown() {
    local total_time=$TIME
    while [ $total_time -gt 0 ]; do
        # Display remaining time in the selected UNIT
        if [ "$UNIT" == "m" ]; then
            #kind of what we do in game dev
            mins=$(($total_time / 60))
            secs=$(($total_time % 60))
            echo -ne "\r\033[KTime remaining: $mins minutes and $secs seconds"
        else
            echo -ne "\r\033[KTime remaining: $total_time seconds"
            if [ $total_time -le 5 ]; then
                echo -ne "\e[31m" # Set text color to red
            elif [ $total_time -le $((TIME / 2)) ]; then
                echo -ne "\e[33m" # Set text color to yellow
            else
                echo -ne "\e[32m" # Set text color to green
            fi
        fi
        # Sleep for one second
        sleep 1
        # Decrement the counter
        total_time=$(($total_time - 1))
    done
}
# Function to display how to use the command
usage() {
    echo "Usage: timer <minutes(m)|seconds(s)>"
    echo "Can also be used to give the 'shutdown' command a timer"
    echo "eg: timer shutdown (defaults to 60 seconds)"
    echo "Or use it as a stopwatch with -s or --stopwatch"
    echo "Press any key to stop it"
    exit 1
}

# Start the timer
# timer
check
