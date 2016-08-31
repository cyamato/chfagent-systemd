# chfagent-intd
Kentik Proxy Agent startup script for systemd

To maker the Proxy Agent start on boot use the command =  systemctl enable chfagent
To start the Proxy Agent use the command systemctl start chfagent
To stop the Proxy Agent use the command systemctl stop chfagent
To restart the Proxy Agent use the command systemctl restart chfagent

Local Config File = /etc/systemd/system/chfagent.service.d/local.conf