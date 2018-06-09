#!/bin/bash
#
# openvpn-tools/openvz-fix.sh
# Apply a fix for OpenVPN to run inside an OpenVZ container
#
# https://github.com/christianberkman/openvpn-tools
#
# 2018-06-09 by Christian Berkman

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo "Script needs to be run with root privileges"
	exit
fi

# Menu
clear
echo "This script will apply a fix for OpenVPN to run inside an OpenVZ container."
echo " /lib/systemd/system/openvpn@.service will be altered"
echo
	echo " [1] Apply Fix"
	echo " [2] Undo Fix"
	echo " [3] Exit"
	echo
	read -p "Choice: " OPTION
	echo

# Case
	case $OPTION in
		# Apply fix
		1)
			sed -i '/LimitNPROC=10/s/^/#/g' "/lib/systemd/system/openvpn@.service"
			systemctl daemon-reload
			echo "Fix should be applied"
			echo
			exit
		;;
		# Undo fix
		2)
			sed -i '/LimitNPROC=10/s/^#//g' "/lib/systemd/system/openvpn@.service"
			systemctrl deamon-reload
			echo "Fix should be undone"
			echo
			exit
	esac
exit
