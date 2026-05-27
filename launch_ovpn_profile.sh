#!/bin/bash

# Description
# Need to import the ovpn-file in to NetworkManager
# Needed tools: 
# - oathtool
# - nmcli

# Howto
# After importing the ovpn file give the connection a nice name
# Insert one line in accounts_file with structure (separated by a pipe)
# VPN_PROFILE_NAME|SECRET|Fixed part of password|VPN login name
#
# by launching the script an OTP will be calculated from the secret
# and the current timestamp. OTP will be combined with the fixed part
# of the password. nmcli command will open the stored connection and
# thus establish the connection.


# --- Konfiguration ---
CONFIG_DIR="$HOME/.config/otp-manager"
ACCOUNTS_FILE="$CONFIG_DIR/accounts.conf"

VPN_PROFILE=$(cat ${ACCOUNTS_FILE} | cut -d "|" -f1)
SECRET=$(cat ${ACCOUNTS_FILE} | cut -d "|" -f2)
PW_FIXED_PART=$(cat ${ACCOUNTS_FILE} | cut -d "|" -f3)
USER_NAME=$(cat ${ACCOUNTS_FILE} | cut -d "|" -f4)

# Calculate PIN from SECRET
PIN=$(oathtool --base32 --totp "$SECRET" 2>/dev/null)

# Launch VPN connection
nmcli connection up ${VPN_PROFILE} passwd-file <(echo -e "vpn.secrets.username:${USER_NAME}\nvpn.secrets.password:${PW_FIXED_PART}${PIN}")
