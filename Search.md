# Summary of idea/goal      
- New bash script Store searcher
	- checks for all installed stores like the auto updater
	- when you type in "find or search" 'x(name of app)' it'll go and search all the 
	available stores that you have for that app and return 
		- brew currently doesn't have 'x'
		- flatpak found 'x'
		- snap found 'x'
	- asks the user which option they would like to download from 
		- use the 1 - whatever number selector from the godot update bash script and
		whatever number they choose it'll go ahead and run the right command for that store
		
# ADDED:
-[x] Made the APT portion of the search get EXACT matches using the ^name$ syntax. eg: apt search ^python$
each different search
-[x] when and if the user decides to install make it write to file, to keep track of what app and which store (currently "installed.txt")
-[x] add function to retrieve list of already installed applications 
   -[x] extend the base function "search" to take account for a "-installed" parameter
 
# FIXED:
-[x] Specific name search using ^name$ syntax working for APT portion 

-[x] when adding to checked stores it was also passing down that ^name$
syntax as a parameter which made the if statement grep check not work

-[x] BREW portion of the search is returning multiple results and not specific. Will cause issue during install phase.

	#### Note: fixed BREW specific search by add regular expression syntax:
	brew search /^name/

# TODO:
-[ ] include option to "broaden" search which disables all specifics from 
each different search
	-[ ] add flags for other things like uninstalling
	-[ ] broaden search functionality by passing in flags such as "-b" and then it will activate a broader search
	by disabling the specific searches (need to extend the search stores)
-[ ] add ability to search directly if the user enters app name after search command