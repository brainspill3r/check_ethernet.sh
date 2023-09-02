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
ExecStartPre=/opt/check_ethernet.sh
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


