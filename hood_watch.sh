#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

# Handle Ctrl+C gracefully
trap "echo -e \"\e[31mClosing stream safely so this doesn't randomly run again...\e[0m\"; exit 130" SIGINT

function watch() {
  CHAT=0
  RECORD=0
  PLATFORM=""
  CHANNEL=""
  QUALITY=""
  for arg in "$@"; do
    if [ "$arg" == "--chat" ] || [ "$arg" == "-c" ]; then
      CHAT=1
    elif [ "$arg" == "--record" ] || [ "$arg" == "-r" ]; then
      RECORD=1
    elif [ "$arg" == "-y" ] || [ "$arg" == "--youtube" ]; then
      PLATFORM="youtube"
    elif [ "$arg" == "-t" ] || [ "$arg" == "--twitch" ]; then
      PLATFORM="twitch"
    elif [ "$arg" == "-k" ] || [ "$arg" == "--kick" ]; then
      PLATFORM="kick"
    elif [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
      help
    elif [ -z "$CHANNEL" ]; then
      CHANNEL="$arg"
    else
      QUALITY="$arg"
    fi
  done
  if [ "$PLATFORM" == "youtube" ]; then
    echo -e "\e[33mYoutube support is currently disabled due to some issues with it (classic Youtube).\e[0m"
    echo -e "\e[33mMainly cause of this issue here:\e[0m"
    echo -e "\e[33mhttps://github.com/streamlink/streamlink/issues/6775#issuecomment-3760050631\e[0m"
  elif [ "$PLATFORM" == "twitch" ]; then
    twitch "$CHANNEL" "$QUALITY"
  elif [ "$PLATFORM" == "kick" ]; then
    kick "$CHANNEL" "$QUALITY"
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
    check_output=$(streamlink --stream-url https://www.youtube.com/@"$1" 480p 2>&1)
    if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31m480p not available, trying default 720p...\e[0m"
      check_output=$(streamlink --stream-url https://www.youtube.com/@"$1" 720p 2>&1)
      if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
        echo -e "\e[31m720p not available, trying best quality...\e[0m"
        check_output=$(streamlink --stream-url https://www.youtube.com/@"$1" best 2>&1)
      if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
        echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
        exit 1
      else
        if [ $CHAT -eq 1 ]; then
          xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
        fi
        if [ $RECORD -eq 1 ]; then
          streamlink -p mpv --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.youtube.com/@"$1" best
        else
          streamlink -p mpv https://www.youtube.com/@"$1" best
        fi
      fi
      else
        if [ $CHAT -eq 1 ]; then
          xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
        fi
        if [ $RECORD -eq 1 ]; then
          streamlink -p mpv --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.youtube.com/@"$1" 720p
        else
          streamlink -p mpv https://www.youtube.com/@"$1" 720p
        fi
      fi
      else
        if [ $CHAT -eq 1 ]; then
          xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
        fi
        if [ $RECORD -eq 1 ]; then
          streamlink -p mpv --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.youtube.com/@"$1" 480p
        else
          streamlink -p mpv https://www.youtube.com/@"$1" 480p
        fi
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    check_output=$(streamlink --stream-url https://www.youtube.com/@"$1" "$2" 2>&1)
    if [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $check_output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$check_output"
      exit 1
    fi
    if [ $CHAT -eq 1 ]; then
      xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
    fi
    if [ $RECORD -eq 1 ]; then
      streamlink -p mpv --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.youtube.com/@"$1" "$2"
    else
      streamlink -p mpv https://www.youtube.com/@"$1" "$2"
    fi
  fi
}

function twitch(){
  if [ -z "$1" ]; then
    echo "Please provide a Twitch channel name."
    exit 1
  fi
  #if argument #2 is nil try to default to 480p then cycle through other resolutions then try best
  if [ -z "$2" ]; then
    echo -e "\e[32mTrying $1 at 480p...\e[0m"
    check_output=$(streamlink --stream-url twitch.tv/"$1" 480p 2>&1)
    if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31m480p not available, trying default 720p60...\e[0m"
      check_output=$(streamlink --stream-url twitch.tv/"$1" 720p60 2>&1)
      if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
        echo -e "\e[31m720p60 not available, trying best quality...\e[0m"
        check_output=$(streamlink --stream-url twitch.tv/"$1" best 2>&1)
        if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
          echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
          exit 1
        else
          if [ $CHAT -eq 1 ]; then
            xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
          fi
          if [ $RECORD -eq 1 ]; then
            streamlink -p mpv --twitch-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" twitch.tv/"$1" best
          else
            streamlink -p mpv --twitch-low-latency twitch.tv/"$1" best
          fi
        fi
      else
        if [ $CHAT -eq 1 ]; then
          xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
        fi
        if [ $RECORD -eq 1 ]; then
          streamlink -p mpv --twitch-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" twitch.tv/"$1" 720p60
        else
          streamlink -p mpv --twitch-low-latency twitch.tv/"$1" 720p60
        fi
      fi
    else
      if [ $CHAT -eq 1 ]; then
        xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
      fi
      if [ $RECORD -eq 1 ]; then
        streamlink -p mpv --twitch-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" twitch.tv/"$1" 480p
      else
        streamlink -p mpv --twitch-low-latency twitch.tv/"$1" 480p
      fi
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    check_output=$(streamlink --stream-url twitch.tv/"$1" "$2" 2>&1)
    if [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $check_output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$check_output"
      exit 1
    fi
    if [ $CHAT -eq 1 ]; then
      xdg-open "https://www.twitch.tv/popout/$1/chat?popout=" >/dev/null 2>&1 &
    fi
    if [ $RECORD -eq 1 ]; then
      streamlink -p mpv --twitch-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" twitch.tv/"$1" "$2"
    else
      streamlink -p mpv --twitch-low-latency twitch.tv/"$1" "$2"
    fi
  fi
}
function kick() {
  if [ -z "$1" ]; then
    echo "Please provide a Kick channel name."
    exit 1
  fi
  #if argument #2 is nil try to default to 480p then cycle through other resolutions then try best
  if [ -z "$2" ]; then
    echo -e "\e[32mTrying $1 at 480p...\e[0m"
    check_output=$(streamlink --stream-url https://www.kick.com/"$1" 480p 2>&1)
    if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31m480p not available, trying 720p60...\e[0m"
      check_output=$(streamlink --stream-url https://www.kick.com/"$1" 720p60 2>&1)
      if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
        echo -e "\e[31m720p60 not available, trying best quality...\e[0m"
        check_output=$(streamlink --stream-url https://www.kick.com/"$1" best 2>&1)
        if [[ $check_output == *"error"* ]] || [[ $check_output == *"playable"* ]]; then
          echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
          exit 1
        else
          if [ $RECORD -eq 1 ]; then
            streamlink -p mpv --kick-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.kick.com/"$1" best
          else
            streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" best
          fi
        fi
      else
        if [ $RECORD -eq 1 ]; then
          streamlink -p mpv --kick-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.kick.com/"$1" 720p60
        else
          streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" 720p60
        fi
      fi
    else
      if [ $RECORD -eq 1 ]; then
        streamlink -p mpv --kick-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.kick.com/"$1" 480p
      else
        streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" 480p
      fi
    fi
  elif [ "$2" != null ]; then
    echo -e "\e[32mTrying $1 at $2...\e[0m"
    check_output=$(streamlink --stream-url https://www.kick.com/"$1" "$2" 2>&1)
    if [[ $check_output == *"playable"* ]]; then
      echo -e "\e[31mFailed to start stream. Channel might be offline or unavailable.\e[0m"
      exit 1
    fi
    if [[ $output == *"error"* ]]; then
      echo -e "\e[31m$2 not available, try one of the resolutions listed below...\e[0m"
      echo "$output"
      exit 1
    fi
    if [ $RECORD -eq 1 ]; then
      streamlink -p mpv --kick-low-latency --record "{author}-{time:%Y%m%d%H%M%S}.ts" https://www.kick.com/"$1" "$2"
    else
      streamlink -p mpv --kick-low-latency https://www.kick.com/"$1" "$2"
    fi
  fi
}
function help() {
  echo "Usage: hood_watch.sh [platform] [channel] [quality] [options]"
  echo "Options:"
  echo "  -y, --youtube [channel]  Watch a Youtube stream (currently disabled)"
  echo "  -t, --twitch [channel]   Watch a Twitch stream"
  echo "  -k, --kick [channel]     Watch a Kick stream"
  echo "  [quality]                Optional stream quality (e.g., 480p, 720p, best)"
  echo "  --chat, -c               Open chat in the default web browser"
  echo "  --record, -r             Record the stream while playing"
  echo "  -h, --help               Show this help message"
  echo "Examples:"
  echo "  hood_watch.sh -t ninja 720p -c"
  echo "  hood_watch.sh -k xqc best -r"
  echo "  hood_watch.sh -t shroud -r -c"
  echo "If quality is not specified, it tries 480p, 720p, and finally best available."
  echo -e "\e[31mNOTE: Youtube currently disabled - https://github.com/streamlink/streamlink/issues/6775\e[0m"
  exit 0
}

watch "$@" 
