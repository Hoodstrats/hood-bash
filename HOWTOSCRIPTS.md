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
