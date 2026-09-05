#!/bin/bash

truncate_field() {
    local text="$1"
    local max="$2"
    if (( ${#text} > max )); then
        echo "${text:0:max}..."
    else
        echo "$text"
    fi
}

SPOTIFY_NAME="org.mpris.MediaPlayer2.spotify"

if ! busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus GetNameOwner s "$SPOTIFY_NAME" &>/dev/null; then
    if [[ "$BLOCK_BUTTON" == "1" ]]; then
        spotify-launcher &
    fi
    echo " x"
    echo " x"
    echo "#F7768E"
    exit 0
fi

case "$BLOCK_BUTTON" in
    1) playerctl -p spotify play-pause ;;
    8) playerctl -p spotify previous ;;
    9) playerctl -p spotify next ;;
esac

state=$(busctl --user --json=short call "$SPOTIFY_NAME" /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties GetAll s "org.mpris.MediaPlayer2.Player")

[[ $state =~ \"PlaybackStatus\":\{\"type\":\"s\",\"data\":\"([^\"]*)\"\} ]]
status="${BASH_REMATCH[1]}"

[[ $state =~ \"xesam:title\":\{\"type\":\"s\",\"data\":\"([^\"]*)\"\} ]]
title=$(truncate_field "${BASH_REMATCH[1]}" 10)

[[ $state =~ \"xesam:artist\":\{\"type\":\"as\",\"data\":\[\"([^\"]*)\"\] ]]
artist=$(truncate_field "${BASH_REMATCH[1]}" 10)

case "$status" in
    Playing) icon="" ; color="#9ECE6A" ;;
    Paused) icon="" ; color="#C0CAF5" ;;
    *) icon="?" ; color="#F7768E" ;;
esac

full_text="${icon} ${artist} - ${title}"
short_text="${icon} ${title}"

echo "$full_text"
echo "$short_text"
echo "$color"
