#!/bin/bash

awk -v MEM=$MEM '
/^MemTotal:/ { mem_total=$2 }
/^MemFree:/ { mem_free=$2 }
/^Buffers:/ { mem_free+=$2 }
/^Cached:/ { mem_free+=$2 }
END {
    free=mem_free/1024/1024
    used=(mem_total-mem_free)/1024/1024
    total=mem_total/1024/1024
    
    printf("%.1f/%.1f\n", used, total)
    printf("%.1f\n", used)
}
' /proc/meminfo
   

