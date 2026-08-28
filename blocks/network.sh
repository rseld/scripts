#!/bin/bash

INTERFACE="${IFACE:-$BLOCK_INSTANCE}"
INTERFACE="${INTERFACE:-$(ip route | awk '/^default/ { print $5 ; exit }')}"

[[ -z "$INTERFACE" ]] && exit

[[ ! -d /sys/class/net/${INTERFACE} ]] && exit

LABEL="${LABEL:-}"
COLOR=${COLOR:-"#C0CAF5"}

GOOD_COL="#9ECE6A"
MID_COL="#E0AF68"
BAD_COL="#F7768E"

E_SYMB="󰈁"

WGOD_SYMB="󰤨 "
WMID_SYMB="󰤢 "
WBAD_SYMB="󰤢 "

WGOOD_THRESH=-50
WMID_THRESH=-70

if [[ "$INTERFACE" =~ "wlan" ]]; then
    SSID=$(iw "$INTERFACE" info | awk '/ssid/ { print $2 ; exit}')
    DBM=$(iw dev "$INTERFACE" link | awk '/signal/ { print $2 ; exit}')

    LABEL="$WGOD_SYMB($SSID)"
    COLOR=$GOOD_COL

    [[ $DBM -le $WGOOD_THRESH ]] && LABEL="$WMID_SYMB($SSID)" && COLOR=$MID_COL
    [[ $DBM -le $WMID_THRESH ]] && LABEL="$WBAD_SYMB($SSID)" && COLOR=$BAD_COL
else
    LABEL=$E_SYMB
    COLOR=$GOOD_COL
fi

if  [[ "$INTERFACE" = "" ]] || [[ "$(cat /sys/class/net/$INTERFACE/operstate)" = 'down' ]]; then
    echo "${LABEL} down"
    echo "${LABEL} down"
    echo $BAD_COL
    exit
fi

IPADDR=$(ip addr show $INTERFACE | awk '/scope global/ { print $2 ; exit }')

text="$LABEL $IPADDR"

echo "$text"
echo "$text"
echo "$COLOR"
