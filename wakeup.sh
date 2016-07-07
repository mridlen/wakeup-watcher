#!/bin/bash

#This script wakes up xscreensaver locked screens on other monitors. (i.e. using Synergy)

#Only xscreensaver is supported at this time.
#It doesn't always seem to work, so you might have to run it a couple times.
#THAT BEING SAID, still faster than entering your password on each system!!!
#I reccomend you bind it to Super+U hotkey in your window manager.

### Usage Warning ###
# THIS MAY ACCIDENTALLY PASTE YOUR PASSWORD INTO A CHAT WINDOW AND COMPROMISE YOUR PASSWORD
# TO AVOID THIS: ONLY RUN THE COMMAND ONCE, WAIT APPROXIMATELY 30 SECONDS BEFORE TRYING AGAIN
# SOME SAFEGUARDS ARE BUILT IN TO PREVENT THIS, BUT XDOTOOL CAN BE UNPREDICTABLE AT TIMES 
# USE AT YOUR OWN RISK

### Installation Instructions ###
# 1) Install ssh keys between all your systems
#    a) Create keys using "ssh-keygen" if you haven't done this already.
#    b) Use "ssh-copy-id user@<hostname>" to copy it to your other systems.
#    c) Use "ssh user@<hostname>" to make sure you can log in without password.
# 2) Install the "xdotool" on all systems - this will allow you to use the keyboard to send a password remotely
# 3) Configure the variables in the configuration section
# 4) Refer to wakeup.sh.log for troubleshooting

### Configuration ###
# USER = your username - should be the same between all systems
USER=username

# Password = your password. If you need to do key combos, use the "+" sign. Add spaces between each key press.
# For example, if you password is "P@ssw0rd$$" it would become:
#    "P shift+2 s s w 0 r d shift+4 shift+4"
PASSWORD="P shift+2 s s w 0 r d shift+4 shift+4"

# Hosts. These are the hostnames or IPs of the systems you are entering the password on.
# Separated by spaces. Should be straightforward.
# e.g.
# HOSTS="laptop1 laptop2 computer1 computer2 10.22.22.22"
# You can use this line to unlock all connected synergy systems (assumes the default port of 24800)
# HOSTS="$(netstat -an | grep 24800 | grep -v 0.0.0.0 | awk '{ print $5 }' | awk -F':' '{ print $1 }' | tr '\n' ' ')"
HOSTS="netbook presario"

### End Configuration ###

### Script Begin ###

#send all output to a log
exec >> ./wakeup.sh.log
echo "$(date)"

#if the script is already running, exit immediately
if [ -f ./wakeup.sh.lock ]; then
    echo "Error: command is already running. Lock file wakeup.sh.lock exists."
    echo "Note: If this continues, the lock file may need to be deleted manually."
    exit 1
else
    echo "Creating Lock File"
    touch ./wakeup.sh.lock
fi

#set -m has to do with keymaps, not sure what the purpose is exactly.
set -m

#The "(" and ") &" sections of these scripts run subprocesses to run the commands independently.
#This is because "xscreensaver-command -time" can take a while to respond.

### HOST SECTION ###
for HOST in $HOSTS
do
        (
        if [[ $(ssh $USER@$HOST "xscreensaver-command -time | grep locked | wc -l") -gt 0 ]]; then
                ssh -X $USER@$HOST "export DISPLAY=:0; xdotool key Escape $PASSWORD Return" &
                echo "Password sent to $HOST"
        else
                echo "System $HOST is already unlocked"
        fi
        ) &
done
### HOST SECTION END ###

#wait 5 seconds for safety and then remove the lock file
sleep 5
rm ./wakeup.sh.lock
