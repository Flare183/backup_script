#!/bin/bash

# ===========================================================
# Jesse N. Richardson (Flare183) flare183@nctv.com
# Bash Script using partimage to restore the Entire Filesystem
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

# First off we need to install partimage
echo "Installing gparted and fsarchiver..."
sleep 5
apt-get -y install gparted fsarchiver
# Should be done with that now

# Run GParted for Dean

gparted

# Recreating Partitions
# I'm going to be using parted for this

#echo "Recreating Paritions..."
#parted -s -a optimal /dev/sda mkpart primary ext4 1049kB 15.4GB
#parted -s -a optimal /dev/sda mkpart primary linux-swap 15.4GB 17.4GB
#parted -s -a optimal /dev/sda mkpart primary ext4 17.4GB 250GB
#echo "Done recreating paritions..."
#sync
#sleep 10

# Going to set the flags for the partitions now
#echo "Settings flags for partitions..."
#parted -s -a optimal set 1 boot on
#parted -s -a optimal set 2 swap on
#echo "Done doing that..."

# Kill XScreenSaver, no one likes it anyways
echo "Killing XScreenSaver and xfce4-power-manager"
killall xscreenssaver
killall xfce4-power-manager
sleep 5
sync
echo "Done"

# Now to run this massive fsarchiver command
echo "Going to run fsarchiver now.."
echo "Only Restoring Root Parition Now"
fsarchiver -v restfs /media/xubuntu/EXT-DRIVE/Server_Backup/root1.fsa id=0,dest=/dev/sda1
echo "Done restoring up the Root Filesystem..."
# Now to sync the filesystems, to make sure everything is ok...
sync
sleep 10

echo "Restoring /home now..."
fsarchiver -v restfs /media/xubuntu/EXT-DRIVE/Server_Backup/home1.fsa id=0,dest=/dev/sda3
# Running Sync again, to again make sure everything is written to the disk..
sync
echo "Done."


# Now to see if Dean wants to shutdown or not.
read -p "Want to shut down? (y/n)"
[ "$REPLY" == "n" ] || poweroff
