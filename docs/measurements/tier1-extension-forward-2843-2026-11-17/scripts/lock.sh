#!/bin/bash
# One run under the 9700X's lock (constant-arms-2678-2026-11-15's lock.sh): the holder's line into holds.txt and the load
# and the busiest processes before and after into busy.txt, then COMMAND, limited to LOCK_TIMEOUT seconds (600). Usage: lock.sh LABEL COMMAND...
dir=$(cd "$(dirname "$0")" && pwd)
label=$1
shift
export EXCLUSIVE_OWNER=claude-2843 EXCLUSIVE_TITLE="Issue 2843 (Tier 1: an extension its operand's register holds)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2843
exec ~/buster-fast-bench/exclusive.sh timeout -k 5 "${LOCK_TIMEOUT:-600}" bash -c '
    dir=$1; label=$2; shift 2
    printf "%s %s\n" "$label" "$(head -1 /var/lib/buster-9700x/owner)" >> "$dir/holds.txt"
    { echo "== $label before"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$dir/busy.txt"
    "$@"
    status=$?
    { echo "== $label after"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$dir/busy.txt"
    exit $status' _ "$dir" "$label" "$@"
