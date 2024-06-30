#!/bin/bash

#center this text
echo "==============================="
echo "Hoodstrats Update Utility v1.0"
echo "==============================="

function checkForInput() {
  #this is the first argument passed to the function
  local args=$1
  if [ "$1" != "y" ]; then
    echo "Ok. Guess not..."
    exit 1
  else
    runUpdate
  fi
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
  sleep 2
  if [ -x "$(command -v flatpak)" ]; then
    echo -e "Checking for Flatpak updates...\n"
    flatpak update
  fi
  sleep 2
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
  sleep 2
  if [ -x "$(command -v snap)" ]; then
    echo -e "Checking for Snap updates...\n"
    snap refresh
  fi
  echo -e "\nAll updates have been checked for and installed."
  echo -e "\nExiting terminal..."
  sleep 2
  exit 1
}

read -p "Yo, you want to check for updates? (y/n) " RESPONSE

#call the function and pass the RESPONSE variable
checkForInput $RESPONSE
