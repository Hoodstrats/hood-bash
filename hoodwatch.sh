#!/bin/bash
# Personal use wrapper for Streamlink cli tool
# requires streamlink and mpv to be installed

function watch() {
  #if argument #2 is nil then we try 480p straight up
  if [ -z "$2" ]; then
    streamlink -p mpv --twitch-low-latency twitch.tv/"$1" 480p
  elif [ "$2" != null ]; then
    streamlink -p mpv --twitch-low-latency twitch.tv/"$1" "$2"
  else
    streamlink -p mpv --twitch-low-latency twitch.tv/"$1" best
  fi
}

watch "$@" 
