#!/bin/bash
#===============================#
#= @hoodstrats on all socials  =#
#===============================#

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
  checkStores
  sleep 1
  runUpdate
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
}

function runUpdate() {
  echo -e "\e[32m===============================\e[0m"
  echo -e "\e[32mChecking for regular System updates...\e[0m"
  sudo apt update
  # List upgradable packages and count them
  numUpgradable=$(sudo apt list --upgradable 2>/dev/null | grep -c upgradable)

  # Check if there are updates available
  if [ "$numUpgradable" -eq 0 ]; then
    echo -e "\e[33mNo updates available...\e[0m"
  else
    echo -e "\e[32mThere are $numUpgradable updates available.\e[0m"
    sudo apt upgrade -y
  fi
  sleep 1

  if [ -x "$(command -v flatpak)" ]; then
    echo -e "\e[32m===============================\e[0m"
    echo -e "\e[32mChecking for Flatpak updates...\e[0m"
    flatpak update
    echo -e "\e[32m===============================\e[0m"
  fi
  sleep 1

  #check if the user has brew installed
  if [ -x "$(command -v brew)" ]; then
    echo -e "\e[32m===============================\e[0m"
    echo -e "\e[32mChecking for brew updates...\e[0m"
    brew update
    #check if there are any upgrades available
    if [ -n "$(brew outdated)" ]; then
      brew upgrade
    else
      echo -e "\e[33mNo brew upgrades available...\e[0m"
    fi
    echo -e "\e[32m===============================\e[0m"
  fi
  sleep 1

  if [ -x "$(command -v snap)" ]; then
    echo -e "\e[32m===============================\e[0m"
    echo -e "\e[32mChecking for Snap updates...\e[0m"
    sudo snap refresh
    echo -e "\e[32m===============================\e[0m"
  fi
  echo -e "\n\e[32mAll updates have been checked for and installed.\e[0m\n"
  runClean
}

function runClean() {
  echo -e "\e[33m===============================\e[0m"
  echo -e "\e[33mDoing some house keeping...\e[0m"
  echo -e "\e[33m===============================\e[0m"
  echo -e "\e[33mCleaning up APT...\e[0m"
  # Use the correct apt subcommand 'autoremove' if on linux mint
  output=$(sudo apt auto-remove -y 2>&1)
  if [[ $output == *"Linux Mint"* ]]; then
    echo -e "\e[33mDetected Linux Mint, running apt autoremove...\e[0m"
    sudo apt autoremove -y
  else
    sudo apt auto-remove -y
  fi
    sudo apt autoclean -y
  sleep 1

  if [ -x "$(command -v flatpak)" ]; then
    echo -e "\e[33m===============================\e[0m"
    echo -e "\e[33mCleaning up Flatpak...\e[0m"
    flatpak uninstall --unused
  fi

  sleep 1

  if [ -x "$(command -v brew)" ]; then
    echo -e "\e[33m===============================\e[0m"
    echo -e "\e[33mCleaning up Brew...\e[0m"
    brew cleanup
  fi

  sleep 1
  echo -e "\e[33m===============================\e[0m"
  echo -e "\n\e[32mJobs done, exiting script!\e[0m"
  exit 1
}
checkForInput
