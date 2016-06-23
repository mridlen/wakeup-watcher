#!/bin/bash

#Run this script in the background by adding "/home/<username>/wakeup.sh &" to your /home/<username>/.profile

process() {
while read input; do 
  case "$input" in
    UNBLANK*)   ./wakeup.sh ;;
  esac
done
}

/usr/bin/xscreensaver-command -watch | process
