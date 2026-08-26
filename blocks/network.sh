#!/bin/bash

INTERFACE="${INTERFACE:-$(ip route | awk '/^default/ { print $5 ; exit }')}"

[[ -z "$INTERFACE" ]] && exit

[[ ! -d /sys/class/net/${INTERFACE} ]] && exit

LABEL="${LABEL:-}"
COLOR=${COLOR:-"#C0CAF5"}

if [[ "$INTERFACE" =~ "wlan" ]]; then
    LABEL=" "
    COLOR="#9ECE6A"
else
    LABEL="󱘖 "
    COLOR="#9ECE6A"
fi

if  [[ "$INTERFACE" = "" ]] || [[ "$(cat /sys/class/net/$INTERFACE/operstate)" = 'down' ]]; then
    echo "${LABEL} down"
    echo "${LABEL} down"
    echo "#F7768E"
    exit
fi

IPADDR=$(ip addr show $INTERFACE | awk '/scope global/ { print $2 ; exit }')

text="$LABEL $IPADDR"

echo "$text"
echo "$text"
echo "$COLOR"
