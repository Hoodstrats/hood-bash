#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

function watch() {
  if [ "$1" == "-y" ] || [ "$1" == "--youtube" ]; then
    youtube "$2" "$3"
  elif [ "$1" == "-t" ] || [ "$1" == "--twitch" ]; then
    twitch "$2" "$3"
  elif [ "$1" == "-k" ] || [ "$1" == "--kick" ]; then
    kick "$2" "$3"
  elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
  else
    help
  fi
}

function youtube(){
  if [ -z "$1" ]; then
    echo "Please provide a YouTube channel name or ID."
    exit 1
  fi
  
  if [ -z "$2" ]; then
    echo -e "\e[32mTrying $1 at 480p...\e[0m"
    output=$(streamlink -p mpv https://www.youtube.com/@"$1" 480p)
    if [[ $output == *"playable"* ]] || [[ $output == *"protected"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m480p not available, trying best quality...\e[0m"
      streamlink -p mpv https://www.youtube.com/@"$1" best
    else
      echo "No quality specified, defaulting to 480p."
      sleep 1
      echo "$output"
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    output=$(streamlink -p mpv https://www.youtube.com/@"$1" "$2")
    if [[ $output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$output"
      exit 1
    fi
  fi
}

function twitch(){
  if [ -z "$1" ]; then
    echo "Please provide a Twitch channel name."
    exit 1
  fi
  #if argument #2 is nil then we try 480p straight up
  if [ -z "$2" ]; then
    echo -e "\e[32mTrying $1 at 480p...\e[0m"
    output=$(streamlink -p mpv --twitch-low-latency twitch.tv/"$1" 480p)
    if [[ $output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    # check if output contains "error"
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m480p not available, trying best quality...\e[0m"
      streamlink -p mpv --twitch-low-latency twitch.tv/"$1" best
    else
      echo "No quality specified, defaulting to 480p."
      sleep 1
      echo "$output"
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    output=$(streamlink -p mpv --twitch-low-latency twitch.tv/"$1" "$2")
    if [[ $output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$output"
      exit 1
    fi
  fi
}
function kick() {
  if [ -z "$1" ]; then
    echo "Please provide a Kick channel name."
    exit 1
  fi
  #if argument #2 is nil then we try 480p straight up
  if [ -z "$2" ]; then
    echo -e "\e[32mTrying $1 at 480p...\e[0m"
    output=$(streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" 480p)
    if [[ $output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    # check if output contains "error"
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m480p not available, trying best quality...\e[0m"
      streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" best
    else
      echo "No quality specified, defaulting to 480p."
      sleep 1
      echo "$output"
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    output=$(streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" "$2")
    if [[ $output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$output"
      exit 1
    fi
  fi
}
function help() {
  echo -e "\e[32mHoodwatch - A simple Streamlink wrapper for YouTube and Twitch\e[0m"
  echo -e "\e[32mDeveloped by Hoodstrats\e[0m"
  echo -e "\e[33m"
  echo "Options:"
  echo -e "-y, --youtube <channel> [quality] Watch a YouTube channel at specified quality (default 480p)"
  echo -e "-t, --twitch <channel> [quality] Watch a Twitch channel at specified quality (default 480p)"
  echo -e "-k, --kick <channel> [quality] Watch a Kick channel at specified quality (default 480p)"
  echo -e "\e[0m"
  echo -e "\e[31mNOTE: YouTube requires the channels actual @name not display name\e[0m\n"
  echo "Usage: hoodwatch.sh -<platform> <channel> [quality]"
  echo "Example: hoodwatch.sh -t ninja 720p"
  echo "If quality is not specified, it tries 480p."
  exit 0
}

watch "$@" 
