#!/bin/bash
#
# openvpn-tools/redo-iptables
# Redo the iptables rules for the OpenVPN install
#
# https://github.com/christianberkman/openvpn-tools
#
# 2018-06-09 by Christian Berkman

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo "Script needs to be run with root privileges"
	exit
fi

# Intro
echo "Please provide the following information of your OpenVPN server:"

	# Port
	PORT=1194
	read -p " Port Number: " -e -i $PORT PORT

	# Protocol
	PROTOCOL=udp
	read -p " Protocol: " -e -i $PROTOCOL PROTOCOL

# Set rules
#iptables -D INPUT -p $PROTOCOL --dport $PORT -j ACCEPT
#iptables -D FORWARD -s 10.8.0.0/24 -j ACCEPT
#iptables -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# Done
echo
echo "New rules loaded in iptables:"
echo 
iptables -L --line-numbers

