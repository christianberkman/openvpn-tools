#!/bin/bash
#
# openvpn-tools/list-clients.sh
# List clients connected to an OpenVPN server installed with nyr/openvpn-install
#
# https://github.com/christianberkman/openvpn-tools
#
# 2018-06-09 by Christian Berkman

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo -e "Script needs to be run with root privilegs"
	exit
fi

# Settings
LOG="/etc/openvpn/openvpn-status.log"
TMPPATH="$HOME"
TMPFILE=".openvpn-clients-tmp"

# Log file exists?
if [[ ! -e $LOG ]];
then
	echo -"Error: Cannot find logfile $LOG"
	exit
fi

# Extract information from log file
sed -n "/^ROUTING TABLE$/,/^GLOBAL STATS$/ p" $LOG > $TMPPATH/$TMPFILE.1
tail -n +2 $TMPPATH/$TMPFILE.1 > $TMPPATH/$TMPFILE.2
sed "\$ d" $TMPPATH/$TMPFILE.2 > $TMPPATH/$TMPFILE.3

# Simple view
if [ -z $1 ];
then
	# Display with columns
	cat $TMPPATH/$TMPFILE.3 | column -t -s ,
fi

# Display with less
if [ "$1" = "less" ];
then
	cat $TMPPATH/$TMPFILE.3 | column -t -s , | less -S
fi

# Remove temporary files
rm $TMPPATH/$TMPFILE*

# Exit
exit
