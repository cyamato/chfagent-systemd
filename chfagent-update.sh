#!/bin/bash
if [ -f /etc/sysconfig/chfagent ]; then
    echo "Config File Found"
    . /etc/sysconfig/chfagent
fi

proxy_Local="/usr/bin/chfagent"

log() {
  echo "$@"
  logger -p user.notice -t $SCRIPT_NAME "$@"
}

err() {
  echo "$@" >&2
  logger -p user.error -t $SCRIPT_NAME "$@"
}

if [ ! -e $proxy_Local ]; then
    log "Kentik Proxy Agent is not installed at ${proxy_Local}, skipping update."
    exit 1
fi

update=0
lastmod=$(date -r ${proxy_Local})

echo "Curent Kentik Proxy Agent: ${lastmod}"
echo "Checking: ${proxy_dl_url}"

cd /tmp

update=$(curl -L -z "${lastmod}" -O -s -w "%{http_code}\n" ${proxy_dl_url})

echo "Reposense Code: ${update}"

if [ ! $update = 200 ]; then
    log "Kentik Proxy Agent is curent"
    exit 1
fi

log "Updating Kentik Proxy Agent"
if [ $OS="debian" || $OS="ubuntu" ]; then
    dpkgPackage=$(dpkg -l | grep -ops -ef | grep chfagent 'chfagent-[a-zA-Z0-9\.-]*')
    killall chfagent
    dpkg -r $dpkgPackage
    dpkg -i chfagent*.deb
    rm chfagent*.deb
else
    # Command
    rpmPackage=$(rpm -qa | grep chfagent)
    killall chfagent
    rpm -e $rpmPackage
    rpm --install chfagent*.rpm
    rm chfagent*.rpm
fi

if [ $init="systemv"]; then
    service chfagent start
else 
    eval systemctl enable chfagent
    eval systemctl start chfagent
fi