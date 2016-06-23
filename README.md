# wakeup-watcher
Unlocks your xscreensaver sessions on other systems when you unlock your main system, for use with synergy.

Installation steps:

1) copy the files to your home directory
2) edit the wakeup.sh and add your user/pass and hostname information
3) follow the installation instructions in the wakeup.sh

### Installation Instructions ###
# 1) Install ssh keys between all your systems
#    a) Create keys using "ssh-keygen" if you haven't done this already.
#    b) Use "ssh-copy-id user@<hostname>" to copy it to your other systems.
#    c) Use "ssh user@<hostname>" to make sure you can log in without password.
# 2) Install the "xdotool" on all systems - this will allow you to use the keyboard to send a password remotely
# 3) Configure the variables in the configuration section
# 4) Refer to wakeup.sh.log for troubleshooting

