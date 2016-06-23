# wakeup-watcher
Unlocks your xscreensaver sessions on other systems when you unlock your main system, for use with synergy.
Supports only xscreensaver at this time.

#### What This Does
- there are 2 scripts, wakeup.sh and wakeup-watcher.sh
-   wakeup-watcher.sh watches the xscreensaver process, and when it sees you logged in, it will run wakeup.sh
-   wakeup.sh will unlock your other systems without having to type in the password 2-5 times
-   you should also bind wakeup.sh to Super+U or some other hotkey in case your other systems fall asleep on you
- logs are kept in wakeup.sh.log, in the same directory as wakeup.sh
- file lock is stored in wakeup.sh.lock, in the same directory as wakeup.sh

Say for example you have a system that is running synergy, and 2 laptops. You want to be able to keep them locked when you step away (e.g. to go to the bathroom), but you don't want to spend all day typing your password. With wakeup-watcher, you can type in your password on your synergy server (your "main" system) and it will enter in the passwords for you on each system. This script assumes all your systems share the same username and password. If they differ, you may need to customize the script a bit.

#### Installation steps:
- copy the files to your home directory (or some other directory of your choice)
- edit the wakeup.sh and add your user/pass and hostname information
- follow the installation instructions in the wakeup.sh (see below)
- Optionally add "/home/<username>/wakeup-watcher.sh &" to your /home/username/.profile to run the daemon on startup

#### Installation Instructions (from wakeup.sh file)
1. Install ssh keys between all your systems
  a. Create keys using "ssh-keygen" if you haven't done this already.
  b. Use "ssh-copy-id user@<hostname>" to copy it to your other systems.
  c. Use "ssh user@<hostname>" to make sure you can log in without password.
2. Install the "xdotool" package on all systems - this will allow you to use the keyboard to send a password remotely
3. Configure the variables in the configuration section
4. Refer to wakeup.sh.log for troubleshooting

#### Usage

- Recommendation: bind the wakeup.sh to Super+U in your window manager (i.e. google it)
- READ THE WARNINGS IN THE wakeup.sh FILE!! IF THIS SCRIPT MALFUNCTIONS, YOU MIGHT ACCIDENTALLY EMAIL YOUR PASSWORD TO YOUR DISGRUNTLED COWORKERS
- If you have wakeup-watcher.sh running in the background, it will automatically log in your other systems on unblank (which means you authenticated successfully with xscreensaver).
