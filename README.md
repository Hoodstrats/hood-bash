# Hood BASH practice repo

## Overview
This is an ever growing collection of Bash scripts I've made and use myself.
There might be other scripts out there that do the same thing but I decided to make my own in order to practice some Bash scripting, as I continue my journey deeper into the Linux.

## Scripts
#### hood_steam.sh
- I was tired of looking up the game store appids in order to clean up any leftover files and folders when I uninstalled them. 
    - RUN THIS SCRIPT FIRST with the delete [-d] flag and type in the game name not case-sensitive ``you can also type in partial names as well. Just make sure you don't try to delete "demo" and there's more than 1 game with that name, etc``
    this will clean up the compatdata, shadercache, userdata and common folders ``the common folder installs sometimes have a different naming scheme so they might dodge the deletion``

		##### ``WARNING: this will delete your save files or anything else the game stores in USERDATA``
    - you still have to manually run the uninstall from within steam AFTER DOING THE SCRIPT PART 
- running it with list [-l] flag will simply list all the steam games you currently have installed and create a installed_games.db file within the script's directory
```
#NOTE: MAKE SURE TO CHANGE LINE 12 WITH YOUR STEAMAPPS LOCATION 

Usage: locate or delete Steam games installed on your system."
[-l] locate - List all installed Steam games with their appid and name."
[-d] delete - Delete a specified Steam game by name (not case-sensitive)"
```
#### hood_update.sh
- I wanted a simple all in 1 command to update all my app repos such as `apt, flatpak, brew, snap` instead of manually stepping through 1 by 1. This script will read the `stores.txt` file, update the app stores listed there and then autoremove/autoclean them. *(Maybe in the future I'll extend this to be dynamic and get update commands from a text file as well)*
	- Make sure to also grab the stores.txt file

#### hood_search.sh
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
#### hood_timer.sh
- I wanted an easy to access timer. Something I can access "quick" and since I'm mostly in the terminal this was the obvious approach. 
    - added functionality for dunstify (need dunst installed)

```
Command syntax: 
- `timer 10m` would start a 10 minute timer
- `timer 10` would start a 10 second timer
- `timer shutdown` starts the default 60 second shutdown timer, similar to running just `shutdown`
```
#### hood_yoink.sh
- I just wanted a simple bash script that would sift through any folder I run it in,
extract files that are images but don't have the appropiate file extensions and rename accordingly. 
I also wanted to account for a specific file sizes in order to filter out thumbnails and the like.

``` 
Command syntax: yoink (or whatever alias)
You will then be prompted and asked for size
Size can be KB,MB,GB (case sensative) EG: 5MB
```

#### hood_display.sh

```
(To get an example just run the command empty or pass in --h)
Command syntax: display (or you're alias or ./hood_display.sh)
display --s <display_port> <resolution> <refresh_rate>
Example: ./hood_display.sh --s DisplayPort-2 1920x1080 60.00
```

#### hood_watch.sh

```
Requires: streamlink and mpv
Command syntax: watch (or whatever alias you choose)
Example: watch hoodstrats 480p
```

### Requirements (tools some the scripts use):
- streamlink (for watch)
- mpv (for watch)
- grep
- cat
- dunst (dunstify, if you want notifications for the timer) 
- xrandr (for the display settings script)

###### [Here's a small read me for those that don't know how to setup scripts yet!](HOWTOSCRIPTS.md)
