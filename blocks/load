#!/bin/bash

load="$(cut -d ' ' -f1 /proc/loadavg)"
cpus="$(nproc)"

echo "$load"
echo "$load"

awk -v cpus=$cpus -v cpuload=$load '
    BEGIN {
        if (cpus <= cpuload) {
            print "#B11226";
            exit 33;
            }
        }
'
