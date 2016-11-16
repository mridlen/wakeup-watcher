#!/bin/bash

#This script locks xscreensaver on other connected systems
#Assumes you have created ssh keys between all systems

### Configuration ###
# USER = your username - should be the same between all systems
USER=username

# Hosts - this is populated by the connected synergy systems
HOSTS="$(netstat -an | grep 24800 | grep -v 0.0.0.0 | awk '{ print $5 }' | awk -F':' '{ print $1 }' | uniq -u)"

### End Configuration ###

### Script Begin ###

#The "(" and ") &" sections of these scripts run subprocesses to run the commands independently.

### HOST SECTION ###
while read -r HOST
do
        (
                echo "getting display number..."
                DISPLAY_NUMBER=$(echo $(ssh -o "StrictHostKeyChecking no" $USER@$HOST "ls -al /tmp/.X11-unix | grep $USER") | awk '{print $9}' | awk '{ print substr($0,2,2) }' )
                echo "display: $DISPLAY_NUMBER"
                echo "locking $USER@$HOST..."
                ssh -o "StrictHostKeyChecking no" $USER@$HOST "export DISPLAY=:$DISPLAY_NUMBER; xscreensaver-command -lock"
        ) &
done <<< "$HOSTS"
### HOST SECTION END ###
