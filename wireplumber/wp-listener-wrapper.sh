#!/bin/bash

trap 'pkill -P $$' EXIT

while read -r _; do
  pkill -RTMIN+10 i3blocks
done < <(stdbuf -oL wpexec "$(dirname "$0")/wp-listener.lua")
