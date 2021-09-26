#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

###############
# Variables   #
###############

read USER
hostname=$HOSTNAME
day=$(date +"%A")
if [ $(date +"%u") == 1 ]; then
	title="First"
elif [ $(date +"%u") == 2 ]; then
	title="Second"
elif [ $(date +"%u") == 3 ]; then
	title="Third"
elif [ $(date +"%u") == 4 ]; then
	title="Fourth"
elif [ $(date +"%u") == 5 ]; then
	title="Fifth"
elif [ $(date +"%u") == 6 ]; then
	title="Sixth"
elif [ $(date +"%u") == 7 ]; then
	title="Seventh"
fi
time=$(date +"%H:%M")

###############
# Main        #
###############
cat <<EOF

Welcome to planet $hostname, "$title $USER!"
It is $day at $time.

EOF
