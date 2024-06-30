# Hoodstrats Update Utility

## Overview

This is V1.0 of an update utility I made for Linux. I got tired of having to manually type in "sudo apt update" then "sudo apt upgrade" etc... I wanted one simple command that would go ahead and update all my app package managers at once. With this script all you have to do is type "update" or whatever alias you decide to give this script in your bash/zsh setup and it will check/update apt, flatpak, snap, and brew if you have them installed. 

### This script assumes you have the following utilities installed:
#### *it will skip the ones you don't*

- Bash shell (can also work for zsh)
- `sudo` privileges for installing updates
  - `apt` 
  - `flatpak` 
  - `brew` 
  - `snap` 

## Installation: setting the script up Globally
### **Make the script executable**:
Add execute permissions to the script file by running the following command in the terminal:
```bash
chmod +x /path/to/your/script.sh
```
Replace `/path/to/your/script.sh` with the actual path to your script file.

### **Add the directory to `PATH`**:

a. **For Linux-based systems (e.g., Ubuntu, Debian)**:
Edit your shell configuration file (`~/.bashrc` or `~/.zshrc`) and add the following line at the end:
```bash
export PATH=$PATH:/actual/path/to/your/script/directory
```
Replace `/path/to/your/script/directory` with the actual directory path where your script is located.

Then, run the command:
```bash
source ~/.bashrc
```

b. **For macOS (with Bash shell)**:
Edit your `~/.bash_profile` file and add the following line at the end:
```bash
export PATH=$PATH:/path/to/your/script/directory
```
Replace `/path/to/your/script/directory` with the actual directory path where your script is located.

Then, run the command:
```bash
source ~/.bash_profile
```
### ZShell:
Edit your `~/.zshrc` file and add the following line at the end:
```bash
export PATH=$PATH:/path/to/your/script/directory
```
Then, run the command:
```bash
source ~/.zshrc
```

## If you decide to run the script globally and adding it to the PATH isn't working you can try this:

**Verify that the script is now globally accessible**:
Open a new terminal window and type the name of your script (without the `.sh` extension). If everything is set up correctly, you should be able to run the script by simply typing its name.

For example, if your script is named `my_script`, you can run it by typing:
```bash
my_script
```

### Sometimes this will still not work and you have to add the .sh at the end of the file: 
```bash
my_script.sh
```
#### If this is your situation then simply create an ALIAS within your .bashrc file which points to the now Global script:
```bash
alias script="my_script.sh"
```
### *Note that you may need to restart your terminal or log out and back in for the changes to take effect.*