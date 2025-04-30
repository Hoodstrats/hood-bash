#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

# Function to display how to use the command
usage() {
    echo "Usage: timer <minutes(m)|seconds(s)>"
    echo "Can also be used to give the 'shutdown' command a timer"
    echo "eg: timer shutdown (defaults to 60 seconds)"
    exit 1
}

# Check if the correct number of arguments is provided (no less than)
if [ "$#" -ne 1 ]; then
    usage
fi

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
    else
        timer
    fi
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
    dunstify --urgency=normal "Timer expired!"
    echo -e "\nTime's up!"
}
countdown() {
    echo "Timer starting..."
    local total_time=$TIME
    while [ $total_time -gt 0 ]; do
        # Display remaining time in the selected UNIT
        if [ "$UNIT" == "m" ]; then
            #kind of what we do in game dev
            mins=$(($total_time / 60))
            secs=$(($total_time % 60))
            echo -ne "Time remaining: $mins minutes and $secs seconds\r"
        else
            echo -ne "Time remaining: $total_time seconds\r"
        fi
        # Sleep for one second
        sleep 1
        # Decrement the counter
        total_time=$(($total_time - 1))
    done
}

# Start the timer
# timer
check
