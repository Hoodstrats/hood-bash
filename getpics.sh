#!/bin/bash

# change the case statement to check for -ge instead of -lt and do the conversion
function check_files() {
  read -p "What size image would you like to search for? " RESPONSE
  size=$(echo "$RESPONSE" | sed 's/[^0-9]*$//')
  unit=$(echo "$RESPONSE" | sed 's/[0-9]*//')

  # Loop through all files in the current directory
  for file in *; do
    # Check if the file is a regular file and doesn't alreaady have an extension
    if [ -f "$file" ] && [[ "$file" != *.* ]]; then
      # Use the 'file' command to check if the file is an image by checking the description using grep if it contains 'image' or 'bitmap'
      if file "$file" | grep -qE 'image|bitmap'; then
        case $unit in
        "KB")
          # Check if the file size matches the user's response
          if [ $(stat -c%s "$file") -ge $(($size * 1024)) ]; then
            convert_to_png "$file"
          else
            echo "$file is not the size you are looking for."
          fi
          ;;
        "MB")
          if [ $(stat -c%s "$file") -ge $(($size * 1024 * 1024)) ]; then
            convert_to_png "$file"
          else
            echo "$file is not the size you are looking for."
          fi
          ;;
        "GB")
          if [ $(stat -c%s "$file") -ge $(($size * 1024 * 1024 * 1024)) ]; then
            convert_to_png "$file"
          else
            echo "$file is not the size you are looking for."
          fi
          ;;
        *)
          echo "Invalid unit. Please use 'KB', 'MB', or 'GB'."
          ;;
        esac
      else
        echo "$file is not an image."
      fi
    fi
  done
}

# TODO: check for duplicate files after conversion so like check their meta data
function convert_to_png() {
  # Check if the 'png_images' directory exists, if not, create it
  if [ ! -d png_images ]; then
    mkdir -p png_images
  fi
  # Use the 'convert' command from ImageMagick to convert the image to PNG
  mv "$1" "$1.png" && mv "$1.png" png_images
  echo "Converted $1 to PNG."
}

check_files
