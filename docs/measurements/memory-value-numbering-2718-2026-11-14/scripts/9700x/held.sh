#!/bin/bash
# held.sh LOG COMMAND...: the command inside the lock's hold, with the busiest processes and the load before and after.
log=$1; shift
{ echo "== before $(date -Is)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"
"$@" >> "$log" 2>&1
status=$?
{ echo "== after $(date -Is) status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"
exit $status
