#!/bin/bash

#add list of available update stores like flatpak, snap, brew, etc
cd "$(dirname "$0")"

stores=()
#get stores from a text file within the same directory seperated by new lines
mapfile -t stores <./stores.txt

#set the color of the text to bright yellow
echo -e "\e[33m"
echo "==============================="
echo "Hoodstrats Update Utility v1.0"
echo -e "==============================="
echo -e "\e[0m"

function checkForInput() {
  #this is the first argument passed to the function
  local args=$1
  if [ "$1" != "y" ]; then
    echo -e "\e[33m"
    echo "Ok. Guess not..."
    exit 1
  else
    checkStores
    sleep 2
    runUpdate
  fi
}

function checkStores() {
  echo -e "Checking for installed update stores..."
  for store in "${stores[@]}"; do
    sleep 1
    if [ -x "$(command -v $store)" ]; then
      echo -e "\e[32m"
      echo -e "$store is installed"
    else
      echo -e "\e[31m"
      echo -e "$store is not installed"
    fi
  done
  echo -e "\e[0m"
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
    snap refresh
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
  echo -e "\nJobs done!"
  echo -e "\nExiting script!"
  sleep 1
  exit 1
}

read -p "Yo, you want to check for updates? (y/n) " RESPONSE

#call the function and pass the RESPONSE variable
checkForInput $RESPONSE
