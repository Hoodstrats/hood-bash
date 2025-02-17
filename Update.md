# Hoodstrats Update Utility

### Overview

This is V1.0 of an update utility I made for Linux. I got tired of having to manually type in "sudo apt update" then "sudo apt upgrade" etc... I wanted one simple command that would go ahead and update all my app package managers at once. With this script all you have to do is type "update" or whatever alias you decide to give this script in your bash/zsh setup and it will check/update apt, flatpak, snap, and brew if you have them installed. 

### This script assumes you have the following utilities installed:
#### *it will skip these automatically if you don't*

- Bash shell (can also work for zsh)
- `sudo` privileges for installing updates
  - `apt` 
  - `flatpak` 
  - `brew` 
  - `snap` 