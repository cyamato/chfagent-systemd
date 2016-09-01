#!/bin/bash
# Setup chfagent - The Kentik Proxy Agent on CentOS/RHEL
# Auther: Craig Yamato 2
# date: 08/31/2016
# url: 
# GNU

$sudo = whoami

if [$sudo != 'root']; then
echo "This script must be executed as root or with sudo"
exit 0
fi

echo "Now setting up the Kentik Proxy Agent - chfagent"
echo ""
echo "Have you created any devices in the Kentik Portal from which you will be sending flow? [y|n]"

read addedDevices

if [$addDevices != 'y' || $addDevices != 'Y' || $addDevices != 'yes' || $addDevices != 'Yes' || $addDevices != '']; then
echo "In the Kentik Portal Admin>Devices menu please add your network devices which you will be sending flow data from and then run this script again (chfagent-setup.sh)"
exit 0
fi


echo ""
echo "Have you created a user for the Proxy Agent in the Kentik Portal? [y|n]"

read addedUser

if [$addedUser != 'y' || $addedUser != 'Y' || $addedUser != 'yes' || $addedUser != 'Yes' || $addedUser != '']; then
echo "In the Kentik Portal Admin>Users menu please add a user account which the Proxy Agent should use and then run this script again (chfagent-setup.sh)"
exit 0
fi

echo ""
echo "Please enter the email address for the account the Kentik Proxy Agent will use: [Enter]"

read emailAddress

echo ""
echo "Please enter the accounts API Key: [Enter]"

read apiKey

echo "Your server is curently configured with the following IP(s):"

ifconfig | awk -F "[: ]+" '/inet / { print $3 }'

echo "Please enter the ip address Kentik Proxy Agent will use, with the IP address 0.0.0.0 the proxy will be accessabule on all IPs used by this server [0.0.0.0]"

read ip

if [$ip == '']; then
ip = '0.0.0.0'
fi

wget -o /etc/systemd/system/chfagent.service https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.service

mkdir /etc/systemd/system/chfagent.service.d/
echo "[Service]" >> /etc/systemd/system/chfagent.service.d/local.conf
echo "Environment='chfagent-email=$emailAddress'" >> /etc/systemd/system/chfagent.service.d/local.conf
echo "Environment='chfagent-token=$apiKey'" >> /etc/systemd/system/chfagent.service.d/local.conf
echo "Environment='chfagent-ip=$ip'" >> /etc/systemd/system/chfagent.service.d/local.conf

systemctl enable chfagent

echo ""
echo "The Kentik Proxy Agent, chfagent, systemd startup script completed.  Starting Proxy Agent..."

systemctl start chfagent