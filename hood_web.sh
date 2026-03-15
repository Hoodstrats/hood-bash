#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

function entry(){
  if [[ -z $1  || $1 == "-h" || $ == "--help" ]]; then
    help
  elif [[ $1 == "-o" || $1 == "--open" ]]; then
    open_url "$2"
  elif [[ $1 == "-s" || $1 == "--search" ]]; then
    search "$2"
  elif [[ $1 == "-y" || $1 == "--youtube" ]]; then
    youtube "$2"
  elif [[ $1 == "-t" || $1 == "--twitch" ]]; then
    twitch "$2"
  else
    help
  fi
}

function search() {
  if [ -z "$1" ]; then
    echo "Please provide a search term."
    exit 1
  fi

  echo -e "\e[32mSearching for '$1' with that duck...\e[0m"
  xdg-open "https://www.duckduckgo.com/search?q=$1" >/dev/null 2>&1 &
}

function open_url() {
  url="$1"
  # Add "https://www." if missing
  if [[ ! "$url" =~ ^https://www\. ]]; then
    url="https://www.$url"
  fi
  echo -e "\e[32mOpening URL '$url' GL HF...\e[0m"
  xdg-open "$url" >/dev/null 2>&1 &
}

function youtube() {
  echo -e "\e[32mSearching Youtube '$1'...\e[0m"
  xdg-open "https://www.youtube.com/results?search_query=$1" >/dev/null 2>&1 &
}

function twitch() {
  echo -e "\e[32mOpening Twitch channel '$1'...\e[0m"
  xdg-open "https://www.twitch.tv/$1" >/dev/null 2>&1 &
}

function help() {
  echo "Usage: hood_web.sh [option] [argument]"
  echo "Options:"
  echo "  -o, --open [url] Open the specified URL in the default web browser."
  echo "  -s, --search [term] Search DuckDuckGo for the specified term."
  echo "  -y, --youtube [term] Search YouTube for the specified term."
  echo "  -t, --twitch [channel] Open the specified Twitch channel."
  echo "Example: hood_web.sh -s "linux gaming" (searches duckduckgo for linux gaming)"
  exit 1
}

entry "$@"
