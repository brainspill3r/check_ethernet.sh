#!/bin/bash

# Log file path
LOG_FILE="/opt/log/check.connections.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Check if any of the specified interfaces (eth0, eth1, wlan0, wlan1) are connected
interfaces=("eth0" "eth1" "wlan0" "wlan1")
connected=false

for interface in "${interfaces[@]}"; do
    if [[ "$(nmcli -t -f DEVICE,STATE dev | grep "$interface" | cut -d':' -f2)" == "connected" ]]; then
        log_message "Connection is present on $interface."
        connected=true
    fi
done

if ! $connected; then
    log_message "No connection on any of the specified interfaces. Starting Sakis3g mobile connection..."

    # Start Sakis3g
    /usr/bin/sakis3g connect APN="ppbundle.internet" APN_USER="web" APN_PASS="web"

    # Check if Sakis3g succeeded in establishing the connection
    if [[ "$(nmcli -t -f DEVICE,STATE dev | grep ppp0 | cut -d':' -f2)" == "connected" ]]; then
        log_message "Sakis3g connection established successfully."
    else
        log_message "Sakis3g failed to establish the connection."
    fi
fi
