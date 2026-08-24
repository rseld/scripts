#!/bin/bash

BAT=$(acpi -b | awk -F'[,:%]' '
{
    status=$2
    percent=$3
    printf "%s %s%%\n", status, percent

    if (percent < 20)
        print("#FF0000")
}
')

echo "Battery: $BAT"
echo "BAT: $BAT"

