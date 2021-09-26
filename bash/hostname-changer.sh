#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable

HOST=$HOSTNAME

# Tell the user what the current hostname is in a human friendly way

echo "Your current host name is $HOST."

# Ask for the user's student number using the read command

echo "Please input your student number:"
read STNUM

# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user

NEWHOST="pc$STNUM"

# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts

if [ ! $(grep -wq "$NEWHOST" /etc/hosts) ]; then
	sudo sed -i "s/$HOST/$NEWHOST/g" /etc/hosts && 
		echo "Your hosts file was edited to reflect $NEWHOST as your hostname" ||
		echo "Insufficient permissions to edit the host file to reflect $NEWHOST as your hostname"
fi  

# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname

if [ ! $HOST == $NEWHOST ]; then
	hostnamectl set-hostname $HOST && 
		echo "Your current hostname has been edited to $NEWHOST. Please reboot for the changes to take effect" ||
		echo "Failed to set current hostname to $NEWHOST"
fi
