#!/bin/bash

CPU="$(cut -c1-2 /sys/class/hwmon/hwmon2/temp1_input)"
GPU="$(nvidia-settings -q GPUCoreTemp -t)"
NVME="$(cut -c1-2 /sys/class/hwmon/hwmon1/temp1_input)"

CPU_SYMBOL=${CPU_SYMBOL:-'C:'}
GPU_SYMBOL=${GPU_SYMBOL:-'G:'}
NVME_SYMBOL=${NVME_SYMBOL:-'N:'}

echo "${CPU_SYMBOL}${CPU} ${GPU_SYMBOL}${GPU} ${NVME_SYMBOL}${NVME}"
echo "${CPU}${GPU}${NVME}"

[ ${NVME} -ge 65 ] && echo "#B11226"
[ ${CPU} -ge 80 ] && echo "#FFF44F"
