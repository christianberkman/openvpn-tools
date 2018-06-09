#!/bin/bash
#
# openvpn-tools/openvz-fix.sh
# Add a user to an OpenVPN install with optional password
#
# https://github.com/christianberkman/openvpn-tools
#
# 2018-06-09 by Christian Berkman

# Are we root?
if [[ "$EUID" -ne 0 ]]; then
	echo -e "Script needs to be run with root privileges"
	exit
fi

# Functions
	# Read user from prompt
	readuser (){
		# Read from CLI
		read -p "User to add (letters only, no spaces or special characters: " -e READUSER

		# Check
		checkuser $READUSER
		if [[ $? == 0 ]]; then
			error "Username contains illegal characters"
			readuser
		fi
	}

	# Check if user format is correct
	checkuser (){
		if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
			NEWUSER=$1
			return 1
		else
			return 0
		fi
	}

	# generate .ovpn file
	# Copied from https://github.com/Nyr/openvpn-install -- My Thanks
	newclient () {
		# Generates the custom client.ovpn
		cp /etc/openvpn/client-common.txt ~/$1.ovpn
		echo "<ca>" >> ~/$1.ovpn
		cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
		echo "</ca>" >> ~/$1.ovpn
		echo "<cert>" >> ~/$1.ovpn
		cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
		echo "</cert>" >> ~/$1.ovpn
		echo "<key>" >> ~/$1.ovpn
		cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
		echo "</key>" >> ~/$1.ovpn
		echo "<tls-auth>" >> ~/$1.ovpn
		cat /etc/openvpn/ta.key >> ~/$1.ovpn
		echo "</tls-auth>" >> ~/$1.ovpn
}

# Username given as argument?
checkuser $1
if [[ $? == 0 ]]; then
	readuser
fi

# Echo username
echo "New Username: $NEWUSER"
echo

# Build client
read -p "Do you want to set a passphrase for the configuration file? [y/N]: " -e -i N SETPASS
	# With password
	if [[ "$SETPASS" = 'y' || "$SETPASS" = 'Y' ]]; then
		cd /etc/openvpn/easy-rsa/
		./easyrsa build-client-full $NEWUSER set-rsa-pass
		newclient $NEWUSER
	# Without password
	else
		cd /etc/openvpn/easy-rsa/
		./easyrsa build-client-full $NEWUSER nopass
		newclient $NEWUSER
	fi

# All clear
echo
echo "New user '$NEWUSER' has been added."
echo "Config file has been created and can be found in ~/$NEWUSER.ovpn"

# Exit
exit
