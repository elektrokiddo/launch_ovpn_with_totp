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
