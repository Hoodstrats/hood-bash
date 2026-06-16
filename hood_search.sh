#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

# TODO: add the option to make Flatpak only show offically approved packages
# flatpak remote-modify --subset=verified flathub

#set the current directory to the directory of the script
#this way we have a reference point for the stores.txt file
cd "$(dirname "$0")"

# replaced mapfile stores.txt with hardcoded array of stores for simplicity and to avoid issues with file reading
stores=(
    apt
    brew
    snap
    flatpak
    cargo
)

#populate this after search with results
checkedStores=()

# FIXME: extend stores file to include the search commands
searchCommands=(
  #apt can also use regular expressions with ^$ to match the exact name ex: apt search --names-only ^python3$
  "search --names-only"
  #brew, snap, cargo
  "search"
  #flatpak
  "search --columns=name"
)
#stores that have the app after search
storesWithApps=()

#just incase we add more stores with different install commands
installCommands=(
  #apt,brew, snap, flatpak, cargo
  "install"
)

# the app name to search for
APP_NAME=""

GREEN='\e[32m'
RED='\e[31m'
YELLOW='\e[33m'
RESET='\e[0m'

color_this() {
  local color
  case "$1" in
    green)  color=$GREEN ;;
    red)    color=$RED ;;
    yellow) color=$YELLOW ;;
    *)      color=$RESET ;;
  esac
  echo -e "${color}${*:2}${RESET}"
}

color_this green "==============================="
color_this green "Hoodstrats Search Utility v1.0"
color_this green "==============================="

#just to make sure there's internet available period
check_internet() {
  color_this yellow "Checking for internet connection..."
  if ping -c 1 8.8.8.8 &>/dev/null; then
    color_this green "Internet connection available"
    checkStores
  else
    color_this red "No internet connection"
    color_this red "Exiting..."
  fi
}

#check installed stores
function checkStores() {
  echo -e "\nChecking for installed update stores..."
  for store in "${stores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      color_this green "$store is installed"
      #populate with actually installed stores
      checkedStores+=("$store")
    else
      color_this red "$store is not installed"
    fi
  done
  echo "==============================="
  searchStores
}

# TODO:extend this to account for whether or not the user passed in -b flag
# if -b flag is passed in then remove specific search
function searchStores() {
  RESPONSE=$APP_NAME
  #search each available store for the app
  for store in "${checkedStores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      case $store in
      "apt")
        color_this yellow "Searching $store for $RESPONSE..."
        # sudo apt ${searchCommands[0]} "^$RESPONSE$"
        # 2>&1 to capture stderr in case --names-only is not supported
        search_output=$(apt ${searchCommands[0]} "^$RESPONSE"'$' 2>&1)
        if echo "$search_output" | grep -q "unrecognized option '--names-only'"; then
          color_this red "'--names-only' not supported, retrying without it..."
          # still uses the ^$ to match the exact name of the app regardless of not having the --names-only flag
          search_output=$(apt search "^$RESPONSE"'$')
        fi
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        ;;

      "brew")
        color_this yellow "Searching $store for $RESPONSE..."
        search_output=$(brew ${searchCommands[1]} "/^$RESPONSE/")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        ;;
      "flatpak")
        color_this yellow "Searching $store for $RESPONSE..."
        search_output=$(flatpak ${searchCommands[1]} "$RESPONSE")
        #grep the search output for the exact name of the app
        #using -i to ignore case and -w to match whole words
        search_output=$(echo "$search_output" | grep -iw "$RESPONSE")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        ;;

      "snap")
        color_this yellow "Searching $store for $RESPONSE..."
        search_output=$(snap ${searchCommands[1]} "$RESPONSE")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        ;;
      "cargo")
        color_this yellow "Searching $store for $RESPONSE..."
        search_output=$(cargo ${searchCommands[1]} "$RESPONSE")
        #grep the search output for the exact name of the app
        #using -i to ignore case and -w to match whole words
        search_output=$(echo "$search_output" | grep -iw "$RESPONSE")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        ;;
      *)
        color_this green "Store not found..."
        ;;
      esac
    fi
  done
  chooseStore "$RESPONSE"
}

function addCheckedStores() {
  # Check if the search term is within the results
  #using grep -i to ignore case and -w to match whole words -q to suppress output
  #using ^$ to match the exact name of the app like we do for apt
  if echo "$2" | grep -iqw "$3"; then
    color_this green "$1 found $3"
    storesWithApps+=("$1")
    echo "$2"
  else
    color_this red "$1 did not find $3"
  fi
}

function chooseStore() {
  number=0
  for store in "${storesWithApps[@]}"; do
    echo "$number.$store"
    number=$((number + 1))
  done
  if [[ $number -eq 0 ]]; then
    color_this red "No stores found with the app"
    exit 1
  fi
  color_this green "Choose which store you would like to install the APP from:"
  echo -e "$GREEN"
  read -p "Which store would you like to download from? " storeNumber
  echo "You chose ${storesWithApps[$storeNumber]}..."
  echo -e "$RESET"
  installAPP "$RESPONSE" "${storesWithApps[$storeNumber]}"
}

function installAPP() {
  color_this green "Attempting to install $1 from $2..."
  case $2 in
  "apt")
    sudo apt ${installCommands[0]} $1
    ;;
  "brew")
    brew ${installCommands[0]} $1
    ;;
  "snap")
    snap ${installCommands[0]} $1
    ;;
  "flatpak")
    flatpak ${installCommands[0]} $1
    ;;
  "cargo")
    cargo ${installCommands[0]} $1
    ;;
  *)
    color_this green "Store not found..."
    ;;
  esac
  # store this info right here into a text file or the stores text
  color_this green "$1 has been installed from $2..."
  # print the installed info to file
  # using >> instead > APPENDS to file and doesn't overwrite it
  printf "%s\n" "$1 from $2" >>installed.txt

  color_this green "\nJobs done, exiting script!"
  exit 1
}

how_to()
{
  color_this yellow "Usage: hoodsearch.sh [app-name]"
  color_this yellow "Example: hoodsearch.sh firefox"
  color_this yellow "This will search all installed package managers for the app and give you the option to install it from one of them."
  color_this yellow "If you would like to see a list of installed apps use alias + --installed or -i"
  color_this yellow "Example: hoodsearch.sh -i"
}
#check to see if the response is one of the flags
if [[ "$1" == "--installed" || "$1" == "-i" ]]; then
  color_this green "List of apps installed using this tool:"
  cat installed.txt
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
  how_to
elif [[ -n "$1" ]]; then
  APP_NAME="$1"
  check_internet
else
  how_to
fi
