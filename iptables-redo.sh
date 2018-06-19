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

# Settings
CONF=/etc/openvpn/server.conf

# Intro
echo "Please confirm the following information of your OpenVPN server:"

	# IP
	IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
	read -p " Public IP-Address: " -e -i $IP IP

	# Port
	PORT=$(awk '/port/{print $NF}' $CONF)
	read -p " Port Number: " -e -i $PORT PORT

	# Protocol
	PROTOCOL=$(awk '/proto/{print $NF}' $CONF)
	read -p " Protocol: " -e -i $PROTOCOL PROTOCOL
	
# Confirm
echo
echo "About to set iptables rules for"
echo " Public IP-Address: $IP"
echo " Port $PORT ($PROTOCOL)"
echo
read -p "Are you sure? (y/n) " SURE
if [[ "$SURE" = 'y' || "$SURE" = 'Y' ]];
then
	# Set rules
	iptables -I INPUT -p udp --dport $PORT -j ACCEPT
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j SNAT --to $IP
	iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
	iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

	# Done
	echo
	echo "New rules loaded in iptables:"
	echo 
	iptables -L --line-numbers
fi
