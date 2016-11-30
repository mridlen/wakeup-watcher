#!/bin/bash

#This script wakes up xscreensaver locked screens on other monitors. (i.e. using Synergy)

#Only xscreensaver is supported at this time.
#I reccomend you bind it to Super+U hotkey in your window manager.

### Installation Instructions ###
# 1) Install ssh keys between all your systems
#    a) Create keys using "ssh-keygen" if you haven't done this already.
#    b) Use "ssh-copy-id user@<hostname>" to copy it to your other systems.
#    c) Use "ssh user@<hostname>" to make sure you can log in without password.
# 2) Configure the variables in the configuration section
# 3) Refer to wakeup.sh.log for troubleshooting

### Configuration ###
# USER = your username - should be the same between all systems
USER=username

# Hosts. These are the hostnames or IPs of the systems you are entering the password on.
# Separated by spaces. Should be straightforward.
# e.g.
# HOSTS="laptop1 laptop2 computer1 computer2 10.22.22.22"
# You can use this line to unlock all connected synergy systems (assumes the default port of 24800)
HOSTS="$(netstat -an | grep 24800 | grep -v 0.0.0.0 | awk '{ print $5 }' | awk -F':' '{ print $1 }' | uniq -u )"

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
while read -r HOST
do
        (
        DISPLAY_NUMBER=$(echo $(ssh -o "StrictHostKeyChecking no" $USER@$HOST "ls -al /tmp/.X11-unix | grep $USER") | awk '{print $9}' | awk '{ print substr($0,2,2) }' )
        while [[ $(ssh $USER@$HOST "export DISPLAY=:$DISPLAY_NUMBER; xscreensaver-command -time 2> /dev/null | grep locked | wc -l") -gt 0 ]];
        do
             ssh $USER@$HOST "export DISPLAY=:$DISPLAY_NUMBER; pkill -HUP xscreensaver"
             sleep 5
        done
        echo "$HOST logged in successfully!"
        ) &
done <<< "$HOSTS"
### HOST SECTION END ###

#wait 5 seconds for safety and then remove the lock file
sleep 5
rm ./wakeup.sh.lock
