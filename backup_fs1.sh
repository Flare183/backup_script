#!/bin/bash

# ===========================================================
# Jesse N. Richardson (Flare183) flare183@nctv.com
# Bash Script using fsarchiver to backup the Entire Filesystem
# For Dean's Server
#
# RUN THIS SCRIPT ONLY WITH ROOT!
#
#



# First off we check if the user is running this via root
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   echo "Run this with sudo bash <filename>"
   exit 1
fi

# First off we need to install fsarchiver
echo "Installing fsarchiver..."
sleep 5
apt-get -y install fsarchiver

# Should be done with that now

# Kill XScreenSaver, no one likes it anyways
echo "Killing XScreenSaver and xfce4-power-manager"
killall xscreenssaver
killall xfce4-power-manager
sleep 5
sync
echo "Done"

# Now to run this massive fsarchiver command
echo "Going to run fsarchiver now..."
echo "Only Backing up the Root Filesystem"
fsarchiver -v -o  savefs /media/xubuntu/EXT-DRIVE/Server_Backup/root1.fsa /dev/sda1
echo "Done backing up the Root Filesystem..."
# Now to sync the filesystems, to make sure everything is ok...
sync
sleep 10

echo "Backing up /home now..."
fsarchiver -v -o savefs /media/xubuntu/EXT-DRIVE/Server_Backup/home1.fsa /dev/sda3
# Running Sync again, to again make sure everything is written to the disk..
sync
echo "Done."


# Now to see if Dean wants to shutdown or not.
read -p "Want to shut down? (y/n)"
[ "$REPLY" == "n" ] || poweroff
