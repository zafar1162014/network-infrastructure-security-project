#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   sudo ./firewall_rules.sh s3123456
#
# Applies Q4.4, Q4.5, and Q4.6 firewall rules on the router.

STUDENT_ID="${1:-}"
if [[ -z "$STUDENT_ID" ]]; then
	echo "Usage: sudo $0 sXXXXXXX"
	exit 1
fi

digits="${STUDENT_ID#s}"
if ! [[ "$digits" =~ ^[0-9]{7}$ ]]; then
	echo "Input must be in format s + 7 digits (example: s3123456)."
	exit 1
fi

# IP_1 is derived from last four digits as A.B.C.D
d1="${digits:3:1}"
d2="${digits:4:1}"
d3="${digits:5:1}"
d4="${digits:6:1}"
IP_1="${d1}.${d2}.${d3}.${d4}"

echo "Applying rules with IP_1=${IP_1}"

# Clear old rules so repeated runs stay consistent.
iptables -F
iptables -P FORWARD DROP
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT

# Q4.4: Block router ping to IP_1
iptables -A OUTPUT -p icmp --icmp-type echo-request -d "$IP_1" -j DROP

# Q4.5: Block echo-reply from 8.8.8.8 to router
iptables -A INPUT -p icmp --icmp-type echo-reply -s 8.8.8.8 -j DROP

# Q4.6.1: Block internal hosts from starting telnet to outside
iptables -A FORWARD -s 192.168.60.0/24 -p tcp --dport 23 -m conntrack --ctstate NEW -j DROP

# Q4.6.2: Allow outside access only to telnet server 192.168.60.5
iptables -A FORWARD -d 192.168.60.5 -p tcp --dport 23 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.60.5 -p tcp --sport 23 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A FORWARD -d 192.168.60.0/24 -p tcp --dport 23 -j DROP

# Q4.6.3: Block all other forwarded packets (already covered by FORWARD default policy DROP)

echo "Rules applied. Current rules:"
iptables -S
