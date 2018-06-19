#!/bin/bash
#
# openvpn-tools/restart
# Restart OpenVPN services
#
# https://github.com/christianberkman/openvpn-tools
#
# 2018-06-19 by Christian Berkman

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo "Script needs to be run with root privileges"
	exit
fi

echo "Restarting services [openvpn] and [openvpn@server]..."

service openvpn@server stop
service openvpn stop
service openvpn start
service openvpn@server start

clear

service openvpn@server status
