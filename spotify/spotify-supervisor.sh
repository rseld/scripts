#!/bin/bash

SPOTIFY_NAME="org.mpris.MediaPlayer2.spotify"
LISTENER_UNIT="spotify-listener.service"

monitor_fifo=$(mktemp -u)
mkfifo "$monitor_fifo"

cleanup() {
    kill "$monitor_pid" 2>/dev/null
    rm -f "$monitor_fifo"
}
trap cleanup EXIT

busctl --user monitor --json=short \
    --match "type=signal,interface=org.freedesktop.DBus,member=NameOwnerChanged,arg0=${SPOTIFY_NAME}" \
    > "$monitor_fifo" &
monitor_pid=$!

if busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus GetNameOwner s "${SPOTIFY_NAME}" &>/dev/null; then
    systemctl --user start "$LISTENER_UNIT"
    pkill -RTMIN+8 i3blocks
fi

while read -r line; do
#!
    if [[ $line =~ \"data\":\[\"([^\"]*)\",\"([^\"]*)\",\"([^\"]*)\"\] ]]; then
        new_owner="${BASH_REMATCH[3]}"
        if [[ -n "$new_owner" ]]; then
            systemctl --user start "$LISTENER_UNIT"
            pkill -RTMIN+8 i3blocks
        else
            systemctl --user stop "$LISTENER_UNIT"
            pkill -RTMIN+8 i3blocks
        fi
    fi
done < "$monitor_fifo"

