#!/bin/bash
# One run under the 9700X's lock: the holder's line into holds.txt and the busiest processes and the load before and
# after into busy.txt, then COMMAND. Usage: lock.sh LABEL COMMAND...
dir=$(cd "$(dirname "$0")" && pwd)
label=$1
shift
export EXCLUSIVE_OWNER=claude-2678 EXCLUSIVE_TITLE="Solve 2678 (integer arms only, out of line)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2678
exec ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c '
    dir=$1; label=$2; shift 2
    printf "%s %s\n" "$label" "$(head -1 /var/lib/buster-9700x/owner)" >> "$dir/holds.txt"
    { echo "== $label before"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$dir/busy.txt"
    "$@"
    status=$?
    { echo "== $label after"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$dir/busy.txt"
    exit $status' _ "$dir" "$label" "$@"
