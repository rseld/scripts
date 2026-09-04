#!/bin/bash

get_state() {
    STATE="$(xset q | awk '/DPMS is/ { print $3 }')"
    if [ "$STATE" = "Disabled" ]; then
        LABEL="$AFK"
        COLOR="$AFK_COL"
    elif [ "$STATE" = "Enabled" ]; then
        LABEL="$NOFK"
        COLOR="$DEFAULT_COLOR"
    fi
}

AFK=${AFK:-"󰡬 "}
NOFK=${NOFK:-"󱀧 "}
STATE=${STATE:-"Unknown"}
DEFAULT_COLOR=${DEFAULT_COLOR:-"#C0CAF5"}
AFK_COL=${AFK_COL:-"#E0AF68"}
LABEL=${LABEL:-"󰡮 ?"}

get_state

case "$BLOCK_BUTTON" in
    1)
        if [ "$STATE" = "Enabled" ]; then
            xset s off >/dev/null
            xset -dpms >/dev/null
        else
            xset s on >/dev/null
            xset +dpms >/dev/null
        fi
        get_state
        ;;
esac

echo $LABEL
echo $LABEL
echo $COLOR
