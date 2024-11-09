#!/bin/bash
#TODO: UDPATE THE SCRIPT WITH THE CHECKEDSTORES ARRAY FUNCTIONALITY FROM SEARCH SCRIPT

#set the current directory to the directory of the script
#this way we have a reference point for the stores.txt file
cd "$(dirname "$0")"

stores=()
#get stores from a text file within the same directory seperated by new lines
mapfile -t stores <./stores.txt

#set the color of the text to bright green
echo -e "\e[32m"
echo "==============================="
echo "Hoodstrats Update Utility v1.0"
echo "==============================="
echo -e "\e[0m"

#add another choice and run the hoodsearch bash script if they choose it
function checkForInput() {
  #this is the first argument passed to the function
  local args=$1
  if [ "$1" == "y" ]; then
    checkStores
    sleep 2
    runUpdate
  elif [ "$1" == "n" ]; then
    echo -e "\n"
    read -p "Would you like to search for an APP? (y/n) " RESPONSE
    if [ "$RESPONSE" == "y" ]; then
      ./hoodsearch.sh
    else
      echo -e "\e[31mOk. Guess not...\e[0m"
      exit 1
    fi
  else
    echo -e "\e[31mOk. Guess not...\e[0m"
    exit 1
  fi
}

function checkStores() {
  echo -e "Checking for installed update stores..."
  for store in "${stores[@]}"; do
    if [ -x "$(command -v $store)" ]; then
      echo -e "\e[32m$store is installed\e[0m"
    else
      echo -e "\e[31m$store is not installed\e[0m"
    fi
  done
  echo "==============================="
}

function runUpdate() {
  echo "Checking for regular System updates..."
  sudo apt update
  # List upgradable packages and count them
  numUpgradable=$(sudo apt list --upgradable 2>/dev/null | grep -c upgradable)

  # Check if there are updates available
  if [ "$numUpgradable" -eq 0 ]; then
    echo "No updates available..."
  else
    echo "There are $numUpgradable updates available."
    sudo apt upgrade -y
  fi
  sleep 1
  echo "==============================="
  if [ -x "$(command -v flatpak)" ]; then
    echo -e "Checking for Flatpak updates...\n"
    flatpak update
  fi
  sleep 1
  echo "==============================="
  #check if the user has brew installed
  if [ -x "$(command -v brew)" ]; then
    echo -e "Checking for brew updates...\n"
    brew update
    #check if there are any upgrades available
    if [ -n "$(brew outdated)" ]; then
      brew upgrade
    else
      echo -e "No brew upgrades available...\n"
    fi
  fi
  sleep 1
  echo "==============================="
  if [ -x "$(command -v snap)" ]; then
    echo -e "Checking for Snap updates...\n"
    sudo snap refresh
  fi
  echo -e "\nAll updates have been checked for and installed."
  runClean
}

function runClean() {
  echo -e "==============================="
  echo -e "Doing some house keeping...\n"

  echo -e "Cleaning up APT...\n"
  sudo apt auto-remove -y
  sudo apt autoclean
  sleep 1
  echo -e "==============================="

  if [ -x "$(command -v flatpak)" ]; then
    echo -e "Cleaning up Flatpak...\n"
    flatpak uninstall --unused
  fi

  sleep 1
  echo "==============================="

  if [ -x "$(command -v brew)" ]; then
    echo -e "Cleaning up Brew...\n"
    brew cleanup
  fi

  sleep 1
  echo "==============================="
  echo -e "\nJobs done, exiting script!"
  sleep 1
  exit 1
}

#open the script with this but wihin the checkforinput method if they say n give them the other option
#to run the search script
read -p "Yo, you want to check for updates? (y/n) " RESPONSE

#call the function and pass the RESPONSE variable
checkForInput $RESPONSE
