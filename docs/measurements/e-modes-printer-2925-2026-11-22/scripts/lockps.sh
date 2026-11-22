#!/bin/bash
# ab's --lock for #2925's A/B: the 9700X's lock for one run, with the load and the busiest processes before and after
# the run, inside the hold.
exec ~/buster-fast-bench/exclusive.sh bash -c '
{ echo "-- before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >&2
"$@"; s=$?
{ echo "-- after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >&2
exit $s' lockps "$@"
