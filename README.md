# Hood BASH practice repo

## Overview
This is an ever growing collection of Bash scripts I've made and use myself.
There might be other scripts out there that do the same thing but I decided to make my own in order to practice some Bash scripting, as I continue my journey deeper into the Linux.

## Scripts
#### hoodupdate.sh
- I wanted a simple all in 1 command to update all my app repos such as `apt, flatpak, brew, snap` instead of manually stepping through 1 by 1. This script will read the `stores.txt` file, update the app stores listed there and then autoremove/autoclean them. *(Maybe in the future I'll extend this to be dynamic and get update commands from a text file as well)*
	- Make sure to also grab the stores.txt file

#### hoodsearch.sh
- Another all in 1 script. I wanted to be able to search all my installed app stores, instead of manually doing it 1 by 1. This script in particular is a work in progress.
```
GOALS:
1. Search all available app stores on the system using 1 command
	- when you type in "find or search" 'x(name of app)' it'll go and search all the 
	available stores that you have for that app and return 
		- brew currently doesn't have 'x'
		- flatpak found 'x'
		- snap found 'x'
  
2. Ask the user which option they would like to download from 
		- use the 0 - 10 whatever number selector whatever number they choose 
		- it'll go ahead and run the right install command for that store

3. Keep a log of installed apps and from where they were installed for easy back tracking/uninstalling
```
#### hoodtimer.sh
- I wanted an easy to access timer. Something I can access "quick" and since I'm mostly in the terminal this was the obvious approach. 
    - added functionality for dunstify (need dunst installed)

```
Command syntax: 
- `timer 10m` would start a 10 minute timer
- `timer 10` would start a 10 second timer
- `timer shutdown` starts the default 60 second shutdown timer, similar to running just `shutdown`
```
#### hoodyoink.sh
- I just wanted a simple bash script that would sift through any folder I run it in,
extract files that are images but don't have the appropiate file extensions and rename accordingly. 
I also wanted to account for a specific file sizes in order to filter out thumbnails and the like.

``` 
Command syntax: yoink (or whatever alias)
You will then be prompted and asked for size
Size can be KB,MB,GB (case sensative) EG: 5MB
```

#### hooddisplay.sh

```
(To get an example just run the command empty or pass in "example")
Command syntax: set_display (or you're alias or ./hooddisplay.sh)
set_diplay <display_port> <resolution> <refresh_rate>
Example: ./hooddisplay.sh DisplayPort-2 1920x1080 60.00
```

#### hoodwatch.sh

```
Requires: streamlink and mpv
Command syntax: watch (or whatever alias you choose)
Example: watch hoodstrats 480p
```

## Requirements (tools the script uses):
- streamlink (for watch)
- mpv (for watch)
- grep
- cat
- dunst (dunstify, if you want notifications for the timer) 
- xrandr (for the display settings script)

## Installation: setting the different scripts System wide
### **Make the script executable**:
Add execute permissions to the script file by running the following command in the terminal:
```bash
chmod +x /path/to/your/script.sh
```
Replace `/path/to/your/script.sh` with the actual path to your script file.

### **Add the directory to `PATH`**:

### **For Linux-based systems (e.g., Ubuntu, Debian)**:
Edit your shell configuration file (`~/.bashrc` or `~/.zshrc`) and add the following line at the end:
```bash
export PATH=$PATH:/actual/path/to/your/script/directory
```
Replace `/path/to/your/script/directory` with the actual directory path where your script is located.

Then, run the command:
```bash
source ~/.bashrc
```
---
### If you decide to run the script globally and adding it to the PATH isn't working you can try this:

**Verify that the script is now globally accessible**:
Open a new terminal window and type the name of your script (without the `.sh` extension). If everything is set up correctly, you should be able to run the script by simply typing its name.

For example, if your script is named `my_script`, you can run it by typing:
```bash
my_script
```

##### Sometimes this will still not work and you have to add the .sh at the end of the file: 
```bash
my_script.sh
```
##### If this is your situation then simply create an ALIAS within your .bashrc file which points to the now Global script:
```bash
alias script="my_script.sh"
```
## **You may need to restart your terminal or log out and back in for the changes to take effect.**
