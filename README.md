# wakeup-watcher
Unlocks your xscreensaver sessions on other systems when you unlock your main system, for use with synergy.
Supports only xscreensaver at this time.

#### News
Lots of big updates coming to the script thanks to some recent feedback from http://reddit.com/u/crankysysop): https://www.reddit.com/r/bash/comments/5eakrk/wakeupwatcher_bash_script_that_unlocks/dabjqt4/

Planned critical updates:

1. Wayland is going to make xdotool irrelevant soon (Fedora 25 is already running it), so I have to use something else than xdotool, fortunately "pkill -HUP xscreensaver" is going to work just fine. It basically unlocks it just fine and leaves the daemon running. I've put this into place, but neither synergy nor xdotool nor xscreensaver support Wayland currently, so I have a little time before I can really make this script Wayland compatible. For now, continue using Xorg/synergy/xscreensaver.
2. Flock. Not the browser, but this is a tool that manages script instances. I had written custom code to do that, but flock handles it easier. 

#### What This Does
- there are 3 scripts
  - wakeup-watcher.sh watches the xscreensaver process, and when it sees you logged in, it will run wakeup.sh
  - wakeup.sh will unlock your other systems without having to type in the password
  - lock-xscreensaver.sh willl lock all your synergy connected systems
- you should also bind wakeup.sh to Super+U or some other hotkey in case your other systems fall asleep on you
- logs are kept in wakeup.sh.log, in the same directory as wakeup.sh
- file lock is stored in wakeup.sh.lock, in the same directory as wakeup.sh

Say for example you have a system that is running synergy, and 2 laptops. You want to be able to keep them locked when you step away (e.g. to go to the bathroom), but you don't want to spend all day typing your password. With wakeup-watcher, you can type in your password on your synergy server (your "main" system) and it will unlock your other systems with "pkill -HUP xscreensaver".

Xscreensaver has a "-lock" option but no "-unlock" option, but "pkill -HUP xscreensaver" seems to work like unlock.

#### Installation steps:
1. copy the files to your home directory (or some other directory of your choice)
2. Give yourself read/write/execute, and everyone else no access. (chmod 700 wakeup.sh;chmod 700 wakeup-watcher.sh;chmod 700 lock-screensaver.sh) This ensures that only you you can look at them.
3. edit the wakeup.sh and add your username information (optionally specifying your hostnames)
4. Install ssh keys between all your systems
  a. Create keys using "ssh-keygen" if you haven't done this already.
  b. Use "ssh-copy-id user@hostname" to copy it to your other systems.
  c. Use "ssh user@hostname" to make sure you can log in without password.
5. Optionally add "/home/username/wakeup-watcher.sh &" to your /home/username/.profile to run the daemon on startup
6. Optionally bind Super+U to wakeup.sh
7. Refer to wakeup.sh.log for troubleshooting

#### Usage

- If you have wakeup-watcher.sh running in the background, it will automatically log in your other systems on unblank (which means you authenticated successfully with xscreensaver).
