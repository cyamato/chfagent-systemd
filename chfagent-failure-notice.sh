#!/bin/bash
UNIT=$1

EXTRA=""
for e in "${@:2}"; do
  EXTRA+="$e"$'\n'
done

UNITSTATUS=$(systemctl status $UNIT)

echo -e "Kentik Proxy Agent, chfagent, failed to start"
echo -e $EXTRA

echo -e "Kentik Proxy Agent, chfagent, failed to start"  >> /tmp/chfagent-systemd.log
echo -e $EXTRA  >> /tmp/chfagent-systemd.log