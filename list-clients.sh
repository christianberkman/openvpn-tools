#!/bin/bash
#
# openvpn-clients
# https://github.com/christianberkman/openvpn-clients
#
# by Christian Berkman
# 2018-06-04
#

# Settings
LOG="/etc/openvpn/openvpn-status.log"
TMPPATH="$HOME"
TMPFILE=".openvpn-clients-tmp"

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo -e "\e[1mError\e[0m\topenvpn-clients needs to be run as root"
	exit
fi

# Log file exists?
if [[ ! -e $LOG ]];
then
	echo -e "\e[1mError\e[0m\tCannot find logfile $LOG"
	exit
fi

# Extract information from log file
sed -n "/^ROUTING TABLE$/,/^GLOBAL STATS$/ p" $LOG > $TMPPATH/$TMPFILE.1
tail -n +2 $TMPPATH/$TMPFILE.1 > $TMPPATH/$TMPFILE.2
sed "\$ d" $TMPPATH/$TMPFILE.2 > $TMPPATH/$TMPFILE.3

# Simple view
if [ -z $1 ];
then
	# Nice Header
	echo -e "\e[1mOpenVPN Client List\e[0m"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =

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
