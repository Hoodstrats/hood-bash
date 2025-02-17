# TODO: add the option to make Flatpak only show offically approved packages 
# flatpak remote-modify --subset=verified flathub

#set the current directory to the directory of the script
#this way we have a reference point for the stores.txt file
cd "$(dirname "$0")"

stores=()

#populate this after search with results
checkedStores=()

# FIXME: extend stores file to include the search command
searchCommands=(
  #apt can also use regular expressions with ^$ to match the exact name ex: apt search --names-only ^python3$
  "search --names-only"
  #brew, snap
  "search"
  #flatpak
  "search --columns=name"
)
#stores that have the app after search
storesWithApps=()

#just incase we add more stores with different install commands
installCommands=(
  #apt,brew, snap, flatpak
  "install"
)

#get stores from a text file within the same directory seperated by new lines
mapfile -t stores <./stores.txt

#set the color of the text to bright green
echo -e "\e[32m"
echo "==============================="
echo "Hoodstrats Search Utility v1.0"
echo "==============================="
echo -e "\e[0m"

#just to make sure there's internet available period
check_internet() {
  echo -e "\e[33mChecking for internet connection...\e[0m"
  if ping -c 1 8.8.8.8 &>/dev/null; then
    echo -e "\e[32mInternet connection available\e[0m"
    checkStores
  else
    echo -e "\e[31mNo internet connection\e[0m"
    echo -e "\e[31mExiting...\e[0m"
  fi
}

#check installed stores
function checkStores() {
  echo -e "\nChecking for installed update stores..."
  for store in "${stores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      echo -e "\e[32m$store is installed\e[0m"
      #populate with actually installed stores
      checkedStores+=("$store")
    else
      echo -e "\e[31m$store is not installed\e[0m"
    fi
  done
  echo "==============================="
  searchStores
}

# TODO:extend this to account for whether or not the user passed in -b flag
# if -b flag is passed in then remove specific search
function searchStores() {
  read -p "What APP would you like to search for? " RESPONSE
  #search each available store for the app
  for store in "${checkedStores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      case $store in
      "apt")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        # sudo apt ${searchCommands[0]} "^$RESPONSE$"
        search_output=$(apt ${searchCommands[0]} "^$RESPONSE"'$')
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;

      "brew")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        search_output=$(brew ${searchCommands[1]} "/^$RESPONSE/")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      "flatpak")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        search_output=$(flatpak ${searchCommands[1]} "$RESPONSE")
        #grep the search output for the exact name of the app
        #using -i to ignore case and -w to match whole words
        search_output=$(echo "$search_output" | grep -iw "$RESPONSE")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;

      "snap")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        search_output=$(snap ${searchCommands[1]} "$RESPONSE")
        addCheckedStores "$store" "$search_output" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      *)
        echo -e "\e[32mStore not found...\e[0m"
        ;;
      esac
    fi
  done
  #ask user to choose which store to install from
  chooseStore "$RESPONSE"
}

function addCheckedStores() {
  # Check if the search term is within the results
  #using grep -i to ignore case and -w to match whole words -q to suppress output
  #using ^$ to match the exact name of the app like we do for apt
  if echo "$2" | grep -iqw "$3"; then
    echo -e "\e[32m$1 found $3\e[0m"
    storesWithApps+=("$1")
    echo "$2"
  else
    echo -e "\e[31m$1 did not find $3\e[0m"
  fi
}

function chooseStore() {
  echo -e "\e[32mChoose which store you would like to install the APP from:\e[0m"
  number=0
  for store in "${storesWithApps[@]}"; do
    echo "$number.$store"
    number=$((number + 1))
  done
  echo -e "\e[32m"
  read -p "Which store would you like to download from? " storeNumber
  echo "You chose ${storesWithApps[$storeNumber]}..."
  echo -e "\e[0m"
  installAPP "$RESPONSE" "${storesWithApps[$storeNumber]}"
}

function installAPP() {
  echo -e "\e[32mAttempting to install $1 from $2...\e[0m"
  echo -e "\n"
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
  *)
    echo -e "\e[32mStore not found...\e[0m"
    ;;
  esac
  echo -e "\n"
  # store this info right here into a text file or the stores text
  echo -e "\e[32m$1 has been installed from $2...\e[0m"
  # print the installed info to file
  # using >> instead > APPENDS to file and doesn't overwrite it
  printf "%s\n" "$1 from $2" >>installed.txt

  echo -e "\nJobs done, exiting script!"
  exit 1
}

#check to see if the response is one of the flags
if [[ "$1" == "-installed" || "$1" == "-i" ]]; then
  echo -e "\e[32mList of apps installed using this tool:\e[0m"
  cat installed.txt
else
  check_internet
fi
