#!/bin/bash

GOOD_COL=${GOOD_COL:-"#9ECE6A"}
WARN_COL=${WARN_COL:-"#E0AF68"}
CRIT_COL=${CRIT_COL:-"#F7768E"}
COLOR=${COLOR:-"#C0CAF5"}

LABEL=${LABEL:-"󱉞 ?"}

read STATUS PERCENTAGE < <(acpi -b | awk -F '[;, ]+' '{ print $3, $4 ; exit }')

case "$STATUS" in
Charging)
    LABEL="󱟦 $PERCENTAGE"
    COLOR="$GOOD_COL"
    ;;
Full)
    LABEL="󱟢 $PERCENTAGE"
    COLOR="$GOOD_COL"
    ;;
Idle|AC)
    LABEL="󱞜 $PERCENTAGE"
    ;;
Discharging)
    LABEL="󱟤 $PERCENTAGE"
    if (( PERCENTAGE >= 80)); then
        COLOR="$GOOD_COL"
    elif (( PERCENTAGE < 80 && PERCENTAGE >= 40 )); then
        COLOR="$WARN_COL"
    elif (( PERCENTAGE < 40 )); then
        COLOR="$BAD_COL"
    fi
    ;;
esac

echo $LABEL
echo $LABEL
echo $COLOR

