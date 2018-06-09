# openvpn-tools
A set of simple cli tools to manage an OpenVPN perfomed with [Nyr/openvpn-install](https://github.com/Nyr/openvpn-install)
I have not tested these scripts in the wild so it is proabably only compatible with installations done with the above script, probably only on Debian/Ubuntu envoirments.

## Scripts
The following scripts are available

### add-user
Add a user to an OpenVPN install with optional password

### list-clients
List clients connected to an OpenVPN server

Options:
* `./list-clients.sh` print a simple list
* `./list-clients.sh less` print a scrollable list using less

### openvz-fix
Apply a fix for OpenVPN to run inside an OpenVZ container

**Caution** this script makes a change to `/var/lib/systemd/system/openvpn@.service`

### redo-iptables
Redo the iptables rules for the OpenVPN install


