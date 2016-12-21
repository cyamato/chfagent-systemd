#!/bin/bash
#
# /etc/rc.d/init.d/
#
# Source function library.
/etc/init.d/functions

[ -f /etc/sysconfig/chfagent ] && /etc/sysconfig/chfagent

start() {
        echo "Starting : chfagent"
        touch /var/lock/subsys/chfagent
        chfagent -api_email=$email -api_token=$token -type='proxy' -host=$host -syslog &
        return
}
stop() {
        echo "Shutting down : chfagent"
        killall chfagent
        rm -f /var/lock/subsys/chfagent
        return
}
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        nc localhost 9996
        ;;
    logs)
        grep -i "chfagent" /var/log/syslog
        ;;
    support_health)
        /usr/bin/chfagent.remote.status
        ;;
    support_capture)
        /usr/bin/chfagent.remote.capture
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: {start|stop|status|logs|support_health|support_capture|restart}"
        exit 1
        ;; esac
exit $?