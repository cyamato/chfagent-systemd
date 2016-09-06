# chfagent-systemd
Kentik Proxy Agent startup script for systemd on **RHEL/CentOS v7, Debian v8, & Ubuntu v14.04**

This script will install wget & chfagent if needed using the local standard package manager (yum/apt | rpm/dpkg)  
It will create the needed systemd files and local proxy configuration.  It will also make needed calls to systemctl to start chfagent at boot up.  chfagent will restart it self in case of failure every 60s.  Please note that if you do not currently have nay devices configured the Proxy Agent will fail and restart every 60s until there is at least one device configured in the Kentik Portal.  

You will need the email address, api key for the Kentik Portal account you wish the Proxy to use as well the IP address it should be attached.  Note that 0.0.0.0 will cause the proxy to attach to all address.  The default port of 9995 is used by this script.

This script is offed as is with out warranty or guaranty of any kind under a GPLv3 license is open for modification and reuse as needed.  We ask that any changes which may be beneficial to others be posted to the github for inclusion.  

The local config file is located at: **/etc/systemd/system/chfagent.service.d/local.conf**  
chfagent is in: **/usr/bin/chfagent**  

Many thanks!

to download and execute this script please use the command 
~~~~
wget https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/setup.sh && sudo chmod +x ./setup.sh && sudo ./setup.sh
~~~~

To manually control the proxy:  
* To start the Proxy Agent use the command 
~~~~
systemctl start chfagent
~~~~  
* To stop the Proxy Agent use the command 
~~~~
systemctl stop chfagent
~~~~  
* To restart the Proxy Agent use the command 
~~~~
systemctl restart chfagent
~~~~