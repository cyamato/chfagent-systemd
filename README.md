# chfagent-systemd
Kentik Proxy Agent startup script for systemd on **RHEL/CentOS v7, Debian v8, & Ubuntu v14.04**

This script will install wget & chfagent if needed using the local standard package manager (yum/apt | rpm/dpkg)  
It will create the needed SystemD files and local proxy configuration and make calls to systemctl to install the SystemD chfagent scripts at boot up.  This configuration will also set chfagent to restart it self in case of failure every 60s.  Please note that if you do not curently have nay devices configured the Proxy Agent will fail and restart every 60s until there is atleast one device configured in the Kentik Portal.  

This script is offed as is with out warenty or guranty of any kind under a GPLv3 licnese is open for modifacation and reuse as needed.  We ask that any changes which may be benfical to others be posted to the Github for inclustion.  

The local config file is located at: **/etc/systemd/system/chfagent.service.d/local.conf**  
chfagent is in: **/usr/bin/chfagent**  

Many thanks!

to download and excute this script please use the command 
~~~~
wget https://raw.githubusercontent.com/cyamato/chfagent-systemd/master/setup.sh && sudo chmod +x ./setup.sh && sudo ./setup.sh
~~~~

To manualy control the proxy:  
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