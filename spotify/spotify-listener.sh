#!/bin/bash

SPOTIFY_NAME="org.mpris.MediaPlayer2.spotify"

monitor_fifo=$(mktemp -u)
mkfifo "$monitor_fifo"

cleanup() {
    kill "$monitor_pid" 2>/dev/null
    rm -f "$monitor_fifo"
}
trap cleanup EXIT

busctl --user monitor --json=short \
    --match "type=signal,interface=org.freedesktop.DBus.Properties,member=PropertiesChanged,path=/org/mpris/MediaPlayer2,sender=${SPOTIFY_NAME}" \
    > "$monitor_fifo" &
monitor_pid=$!

while read -r line; do
    if busctl --user call "$SPOTIFY_NAME" /org/mpris/MediaPlayer2 \
        org.freedesktop.DBus.Properties GetAll s "org.mpris.MediaPlayer2.Player" &>/dev/null; then
    pkill -RTMIN+8 i3blocks
    echo "Signaling i3blocks (RTMIN+8)"
    fi
done < "$monitor_fifo"
