# openvpn-tools
A set of simple cli tools to manage OpenVPN.
This script is compatible with an OpenVPN install via [Nyr/openvpn-install](https://github.com/Nyr/openvpn-install)

## Scripts
The following scripts are available

### openvpn-clients
Print a list of connected clients. List is read from `/etc/openvpn/openvpn-status.log`
Options:
* `./openvpn-clients.sh` print a simple list
* `./openvpn-clients.sh less` print a scrollable list using less
