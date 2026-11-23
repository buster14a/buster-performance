#!/bin/bash
# One hold of the lock: sets the host's 64 KB page switch as asked, runs one part of the gauge, and puts the switch back.
# hold2.sh SWITCH PART GAUGE -- COMMAND...   (run under exclusive.sh, from the tree)
set -euo pipefail
switch=${1:?never or madvise}
part=${2:?counted or sampled}
gauge=${3:?gauge directory}
shift 4
knob=/sys/kernel/mm/transparent_hugepage/hugepages-64kB/enabled
restore() { echo never | sudo -n tee "$knob" > /dev/null; echo "$(date -u +%FT%TZ) restored: $(cat $knob)" >> "$gauge/switch.txt"; }
trap restore EXIT
echo "$switch" | sudo -n tee "$knob" > /dev/null
echo "$(date -u +%FT%TZ) $part set: $(cat $knob)" >> "$gauge/switch.txt"
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } >> "$gauge/busy-$part.txt"
build/allcore "$part" --out "$gauge" -- "$@"
