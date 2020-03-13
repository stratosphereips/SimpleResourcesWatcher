#!/bin/bash

VERSION="0.1"

# Verifying that parameters were given
if [ -z "$1" -o -z "$2" ]; 
then
    echo "Simple Resource Watcher. Version: "$VERSION
    echo "Author: Veronica Valeros (vero.valeros@gmail.com)"
    echo
    echo usage: $0 [interface] [slack.auth]
    echo e.g. $0 eth0 slack.auth
    echo
    exit
fi

# Reading parameters
INTERFACE=$1
AUTH=$2

# Reading the configuration file with the webhook URL
WEBHOOK=$(cat $AUTH|awk -F= '{print $2}')

# slack_alert: function to post a given text message to slack.
slack_alert (){
    PAYLOAD="payload={\"channel\": \"#alerts\", \"username\": \"SRWATCHER\", \"text\": \"$1\", \"icon_emoji\": \":warning:\"}"
    curl -s -X POST --data-urlencode "$PAYLOAD" $WEBHOOK
}

# Measuring Memory Usage: FREEMEM contains the available RAM Memory given by free based on /proc/meminfo.
FREEMEM=$(free -g | grep Mem | awk '{print $7}')
MEM_MESSAGE="Available RAM: *$FREEMEM GB*"

# Measuring Network Bandwith
R1=`cat /sys/class/net/$1/statistics/rx_bytes`
T1=`cat /sys/class/net/$1/statistics/tx_bytes`
sleep 1
R2=`cat /sys/class/net/$1/statistics/rx_bytes`
T2=`cat /sys/class/net/$1/statistics/tx_bytes`

TBPS=`expr $T2 - $T1`
RBPS=`expr $R2 - $R1`

TKBPS=`expr $TBPS / 1024`
RKBPS=`expr $RBPS / 1024`

NET_MESSAGE="Network Download *$RKBPS kB/s*, Network Upload *$TKBPS kB/s*"

# Listing the top memory consuming processes
IFS=$'\n'
PROC_MESSAGE=""
for i in $(ps aux --sort=-%mem  | head -n 6);
do
    PROC_MESSAGE=$PROC_MESSAGE$i"\n"
done

# ALERT IF: the bandwidth is more than 30,000 KBPS or the available memory is less than 4 GB
if [ "$FREEMEM" -le 4 ] || [ "$TKBPS" -gt 30000 ]
then
    slack_alert "$(hostname) ALERT: $NET_MESSAGE, $MEM_MESSAGE."
fi

# LIST MEMORY CONSUMING PROCESSES IF: the available memory is less than 4 GB
if [ "$FREEMEM" -le 4 ] 
then
    PROC_MESSAGE_SLACK="\`\`\`"$PROC_MESSAGE"\`\`\`"
    slack_alert "$PROC_MESSAGE"
fi

#COMMAND LINE OUTPUT
echo "$(date +"%Y/%m/%d %T"), $NET_MESSAGE, $MEM_MESSAGE." 
echo "$(date +"%Y/%m/%d %T"), $NET_MESSAGE, $MEM_MESSAGE." >> srwatcher.log
