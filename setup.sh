#!/bin/bash
# Setup chfagent - The Kentik Proxy Agent on CentOS/RHEL
# Auther: Craig Yamato 2
# date: 08/31/2016
# url: 
# GNU

if [[ -e "/etc/redhat-release" ]]; then

if [[ $(grep -Eom1 '[0-9]' /etc/redhat-release | grep -Eom1 [0-9]) == "7" ]]; then
chfagent_dir="/etc/systemd/system/"
proxy_Local="/usr/bin/chfagent"
proxy_dl_url="https://kentik.com/packages/builds/rhel/7/chfagent_rhel_7-latest-1.x86_64.rpm"

else
echo "Sorry only verson 7 of RHEL/CentOS is supported by this script"
fi

else

if [[ -e "/etc/os-release" ]]; then
if [[ $(grep -Eom1 '[0-9]' /etc/os-release | grep -Eom1 [0-9]) == "8" ]]; then
echo "Debain 8"
chfagent_dir="/lib/systemd/system/"
proxy_Local="/usr/bin/chfagent"
proxy_dl_url="https://kentik.com/packages/builds/debian/8/chfagent-jessie_latest_amd64.deb"
fi
fi
fi

url_chfagentServic="https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/chfagent.service"

if [ ! "$(whoami)" == 'root' ]; then
echo "This script must be executed as root or with sudo"
exit 0
fi

echo ""
echo "Now setting up the Kentik Proxy Agent - chfagent"

if [[ $(hash wget) ]]; then 
echo "Your system does not have wget.  We will call your package manager to install it for you"
yum install wget
fi

read -r -p "Have you created any devices in the Kentik Portal from which you will be sending flow? [y/N] " response
response=${response,,}
if [[ ! $response =~ ^(yes|y)$ ]]; then
echo "In the Kentik Portal Admin>Devices menu please add your network devices which you will be sending flow data from and then run this script again (chfagent-setup.sh)"
exit 0
fi

read -r -p "Have you created a user for the Proxy Agent in the Kentik Portal? [y/N] " response
response=${response,,}
if [[ ! $response =~ ^(yes|y)$ ]]; then
echo "In the Kentik Portal Admin>Users menu please add a user account which the Proxy Agent should use and then run this script again (chfagent-setup.sh)"
exit 0
fi

while [[ -z "${emailAddress// }" ]]
do
read -r -p "Please enter the email address for the account the Kentik Proxy Agent will use: " emailAddress
done

while [[ -z "${apiKey// }" ]]
do
read -r -p "Please enter the accounts API Key: " apiKey
done

echo "Your server is curently configured with the following IP(s):"
ifconfig | awk -F "[: ]+" '/inet / { print $3 }'

read -r -p "Please enter the ip address Kentik Proxy Agent will use, with the IP address 0.0.0.0 the proxy will be accessabule on all IPs used by this server [0.0.0.0]" ip

if [[ -z "${ip// }" ]]; then
ip="0.0.0.0"
fi

if [[ ! -e $proxy_Local ]]; then
echo "Kentik Proxy Agent not found on system.  Installing it now"
wget $proxy_dl_url
yum install chfagent_rhel_7-latest-1.x86_64.rpm
fi

localFile="${chfagent_dir}chfagent.service"

if [[ -e $localFile ]]; then
rm $localFile
fi

wget -O $localFile $url_chfagentServic

if [ ! -d "${chfagent_dir}chfagent.service.d/" ]; then
mkdir ${chfagent_dir}chfagent.service.d/
fi

if [ -e "${chfagent_dir}chfagent.service.d/local.conf" ]; then
 rm ${chfagent_dir}chfagent.service.d/local.conf
fi

echo "[Service]" >> ${chfagent_dir}chfagent.service.d/local.conf
echo "Environment='chfagent_email=$emailAddress'" >> ${chfagent_dir}chfagent.service.d/local.conf
echo "Environment='chfagent_token=$apiKey'" >> ${chfagent_dir}chfagent.service.d/local.conf
echo "Environment='chfagent_ip=$ip'" >> ${chfagent_dir}chfagent.service.d/local.conf

rm ./chfagent.service

if [[ -e "chfagent_rhel_7-latest-1.x86_64.rpm" ]]; then
rm ./chfagent_rhel_7-latest-1.x86_64.rpm
fi

eval systemctl enable chfagent

eval systemctl start chfagent

echo ""
echo "The Kentik Proxy Agent, chfagent, systemd startup script completed.  Starting Proxy Agent..."
echo ""