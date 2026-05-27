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

[[ -z $1 ]] && exit 99

# --- Konfiguration ---
CONFIG_DIR="$HOME/.config/otp-manager"
ACCOUNT_FILE="$CONFIG_DIR/account_IAFN.conf"

CONF_STRING=$(sed -n '/^IAFN/p' ${ACCOUNT_FILE})

# get config
IFS='|' read -r VPN_PROFILE SECRET PW_FIXED_PART USER_NAME <<< "$CONF_STRING"

check_profile_exists() {
  if ! nmcli connection show "${VPN_PROFILE}" &>/dev/null; then
    echo "VPN-Profil '${VPN_PROFILE}' nicht gefunden. Abbruch."
    exit 1
  fi
}

vpn_connect() {

  check_profile_exists

  # Check if VPN profile is active
  if nmcli connection show --active | grep -q "^${VPN_PROFILE}"; then
    echo "VPN-Verbindung '${VPN_PROFILE}' ist bereits aktiv. Keine Aktion..."
  else
    # Calculate PIN from SECRET
    local PIN=$(oathtool --base32 --totp "$SECRET" 2>/dev/null)

    # Launch VPN connection
    # nmcli connection up ${VPN_PROFILE} passwd-file <(echo -e "vpn.secrets.username:${USER_NAME}\nvpn.secrets.password:${PW_FIXED_PART}${PIN}")
    echo "CONNECT VPN"
  fi
}

vpn_disconnect() {

  check_profile_exists

  # Check if VPN profile is active
  if nmcli connection show --active | grep -q "^${VPN_PROFILE}"; then
    echo "Trenne VPN-Verbindung '${VPN_PROFILE}'..."
    nmcli connection down "${VPN_PROFILE}"
  else
    echo "VPN-Profil '${VPN_PROFILE}' ist nicht aktiv."
  fi
}

[[ "$1" == "connect" ]] && vpn_connect
[[ "$1" == "disconnect" ]] && vpn_disconnect
