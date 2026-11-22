#!/usr/bin/env bash
# held.sh COMMAND...: inside a hold of the lock, the busiest processes and the load before and after COMMAND.
log="$HOME/buster-fast-bench/3022-claude/logs/held.txt"
{ echo "== before $(date -u -Iseconds): ${*:1:3}"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"
"$@"
status=$?
{ echo "== after $(date -u -Iseconds) status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$log"
exit $status
