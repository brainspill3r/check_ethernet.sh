# check_ethernet.sh
Ethernet &amp; Wifi checker for sakis3g service. 

This is for use with any red team dropbox. The cronjob creates a 15 task, that runs a script called check_ethernet.sh. 

If an ethernet connection is present, we just get a log entry in /opt/log/check_connections.log.


Sakis3g.service file

![image](https://github.com/brainspill3r/check_ethernet.sh/assets/68113403/ac6712da-d6d6-4289-8ef6-3f0be051f026)

[Unit]
Description=Sakis3g

[Service]
Type=oneshot
ExecStartPre=/opt/check_ethernet3.sh
ExecStart=/bin/sleep 900
ExecStart=/usr/bin/sakis3g --sudo connect APN="ppbundle.internet" APN_USER="web" APN_PASS="web"
RemainAfterExit=true
ExecStop=/usr/bin/sakis3g disconnect
StandardOutput=journal

[Install]
WantedBy=multi-user.target



crontab -e 

*/15 * * * * /opt/check_ethernet.sh

![image](https://github.com/brainspill3r/check_ethernet.sh/assets/68113403/f3efaf19-de6a-4bd6-bf25-feaeadac6203)


check_ethernet.sh 

![image](https://github.com/brainspill3r/check_ethernet.sh/assets/68113403/951ae0b2-4b2f-4cc7-a418-05a9e19b2e3d)


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
