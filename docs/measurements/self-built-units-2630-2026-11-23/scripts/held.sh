#!/bin/bash
# usage: held.sh LOG COMMAND... ; inside a hold: the busiest processes and the load before and after COMMAND, its wall
# time and status, appended to LOG; COMMAND's own output to LOG.out.
log=$1; shift
{ echo "== $(date -Is) $*"; head -1 /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$log"
start=$(date +%s.%N)
"$@" >> "$log.out" 2>&1
status=$?
end=$(date +%s.%N)
{ printf "wall %s status %d\n" "$(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.3f", b - a }')" "$status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -4; } >> "$log"
exit "$status"
