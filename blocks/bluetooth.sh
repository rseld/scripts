#!/bin/bash
get_state() {
    local result
    result="$(bluetoothctl show | awk '/Powered:/ { print $2 }')"
    STATE="$result"
}

get_device() {
    local device
    device="$(bluetoothctl info | awk -F ':' '/Name:/ { print $2}' | sed 's/^[[:space:]]*//')"
    LABEL+=" ($device)"
}

set_label() {
    local connected
    connected="$(bluetoothctl info | awk '/Connected:/ { print $2 }')"
    case "$STATE" in
        yes)
            if [ "$connected" = "yes" ]; then
                LABEL="󰂱"
                get_device
                COLOR="$CON_COL"
            else
                LABEL="󰂳"
                COLOR="$DISCON_COL"
            fi
        ;;
    no)
        LABEL="󰂲"
        COLOR="$OFF_COL"
        ;;
    esac
}

LABEL=${LABEL:-" ?"}
COLOR=${COLOR:-"#C0CAF5"}
OFF_COL=${OFF_COL:-"#F7768E"}
CON_COL=${CON_COL:-"#9ECE6A"}
DISCON_COL=${DISCON_COL:-"#E0AF68"}

get_state
set_label

case "$BLOCK_BUTTON" in
    1)
        if [ "$STATE" = "yes" ]; then
            bluetoothctl power off >/dev/null
        else
            bluetoothctl power on >/dev/null
        fi
        get_state
        set_label
        ;;
esac

echo $LABEL
echo $LABEL
echo $COLOR
