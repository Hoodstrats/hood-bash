#!/bin/bash

#===============================#
#= @hoodstrats on all socials  =#
#===============================#

# make sure we're in the script's directory
# this is where the game database will be stored
cd "$(dirname "$0")"

# Assign your Steam library path "steamapps" directory
ACF_DIR="/home/$USER/.steam/debian-installation/steamapps"
DATA_DIR="compatdata"
SHADER_DIR="shadercache"
INSTALL_DIR="common"
# this is where the save files and some config files are stored for the games
USER_DATA_DIR="/home/$USER/.steam/debian-installation/userdata"

# the fields we're looking for in the acf files
FIELD1="appid"
FIELD2="name"
GAME_DB="installed_games.db"

help() {
  echo "Usage: locate or delete Steam games installed on your system."
  echo "[-l] locate - List all installed Steam games with their appid and name."
  echo "[-d] delete - Delete a specified Steam game by name (not case-sensitive)."
  exit 1
}

games() {
  find "$ACF_DIR" -type f -name "*.acf" | while read -r acf_file; do
      appid=$(grep -m1 '"appid"' "$acf_file" | sed 's/.*"\([0-9]*\)".*/\1/')
      name=$(grep -m1 '"name"' "$acf_file" | sed 's/.*"\([^"]*\)".*/\1/')
      if [[ "$name" != *Steam* ]]; then
      {
        echo "File: $acf_file"
        echo "  $FIELD1: $appid"
        echo "  $FIELD2: $name"
        echo
      } | tee -a "$GAME_DB"
      fi
    done
    echo -e "\e[32m----Game database generated at ("$PWD"/"$GAME_DB")----\e[0m"
    echo
}

delete(){
  if [ ! -f "$GAME_DB" ]; then
    echo "Game database not found. Generating..."
    output=$(games)
    echo "$output" > "$GAME_DB"
    echo -e "\e[32m----Game database generated at ("$PWD"/"$GAME_DB")----\e[0m"
  fi
  # take input from the user and delete the corresponding acf file
  # along with all the folders that share the same appid
  read -p "Enter the name of the game you want to delete: " del
  find "$ACF_DIR" -type f -name "*.acf" | while read -r acf_file; do
      appid=$(grep -m1 '"appid"' "$acf_file" | sed 's/.*"\([0-9]*\)".*/\1/')
      name=$(grep -m1 '"name"' "$acf_file" | sed 's/.*"\([^"]*\)".*/\1/')
      if [[ "${name,,}" == *"${del,,}"* ]]; then
            echo -e "\e[31mDeleting game: $name (AppID: $appid)\e[0m"

          # remove the dirs under compatdata and shadercache
          for data_dir in "$ACF_DIR/$DATA_DIR" "$ACF_DIR/$SHADER_DIR" "$ACF_DIR/$INSTALL_DIR"; do
            if [ -d "$data_dir" ]; then
              if [ -e "$data_dir/$appid" ] || [ -L "$data_dir/$appid" ]; then
                rm -rf "$data_dir/$appid"
                echo -e "\e[31mRemoved $data_dir/$appid\e[0m"
              fi
              if [ -e "$data_dir/$name" ] || [ -L "$data_dir/$name" ]; then
                rm -rf "$data_dir/$name"
                echo -e "\e[31mRemoved $data_dir/$name\e[0m"
              fi
              # since the user_data_dir has multiple folders 1 level down need to check for the appid in all of those
              if [ -d "$USER_DATA_DIR" ]; then
               find "$USER_DATA_DIR" -type d -name "$appid" -exec rm -rf {} + -print 2>/dev/null | while read -r removed_dir; do
                  echo -e "\e[31mRemoved $removed_dir\e[0m"
                done
              fi
            fi
          done
          echo -e "\e[31mRemoved appid $appid from compatdata/shadercache and other library folders\e[0m"
      fi
  done
  # regenerate the game database
  echo -e "\e[33mRegenerating game database...\e[0m"
  output=$(games)
  echo "$output" > "$GAME_DB"
  echo -e "\e[32m----Game database generated at ("$PWD"/"$GAME_DB")----\e[0m"
}
entry(){
  if [[ -z $1 ]]; then
    help
  elif [[ $1 == "-l" ]]; then
    games
  elif [[ $1 == "-d" ]]; then
    delete
  else
    help
  fi
}
entry "$@"
