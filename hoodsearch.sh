#set the current directory to the directory of the script
#this way we have a reference point for the stores.txt file
cd "$(dirname "$0")"

stores=()

checkedStores=()

searchCommands=(
  #apt
  "search --names-only"
  #brew, snap, flatpak
  "search"
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

#check installed stores
function checkStores() {
  echo -e "\nChecking for installed update stores..."
  for store in "${stores[@]}"; do
    sleep 1
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
#TODO: for each store that gets a hit back we must put it in a array and then ask the user which store they would like to download from using numbers or just letters to simplify the process/less typing....
#then run the appropiate INSTALL command just like we use the correct install command
function searchStores() {
  read -p "What APP would you like to search for? " RESPONSE
  for store in "${checkedStores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      case $store in
      "apt")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        sudo apt ${searchCommands[0]} $RESPONSE
        #add to array of stores that have the app
        addCheckedStores "$store" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      "brew")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        brew ${searchCommands[1]} $RESPONSE
        addCheckedStores "$store" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      "snap")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        snap ${searchCommands[1]} $RESPONSE
        addCheckedStores "$store" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      "flatpak")
        echo -e "\e[33mSearching $store for $RESPONSE...\e[0m"
        flatpak ${searchCommands[1]} $RESPONSE
        addCheckedStores "$store" "$RESPONSE"
        echo "==============================="
        echo -e "\n"
        ;;
      *)
        echo -e "\e[32mStore not found...\e[0m"
        ;;
      esac
    fi
  done
  #TODO: ask user which store they would like to download from
  #create function
  #pass in the response (the app name)
  chooseStore "$RESPONSE"
}

function addCheckedStores() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m$1 found $2\e[0m"
    storesWithApps+=("$1")
  else
    echo -e "\e[31m$1 did not find $2\e[0m"
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
  echo -e "\e[32m$1 has been installed from $2...\e[0m"
  echo -e "\nJobs done, exiting script!"
  exit 1
}
checkStores
