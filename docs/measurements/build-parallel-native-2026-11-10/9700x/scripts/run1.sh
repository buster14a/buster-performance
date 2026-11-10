#!/bin/bash
# One timed build of PR #2056's A/B, run inside the 9700X lock: SIDE CASE FILE REP.
set -u
export LC_ALL=C
side=$1; case=$2; file=$3; rep=$4
d=$HOME/buster-fast-bench/2056-claude
cd "$d/$side" || exit 2
if [ "$case" = fresh ] || [ "$case" = warm ]; then rm -rf build; else touch "src/buster/compiler/$file"; fi
log=$d/logs/$case-$side-$rep.log
TIMEFORMAT='%R %U %S'
{ time ./build.sh > "$log" 2>&1; } 2> "$d/logs/$case-$side-$rep.time"
rc=$?
summary=$(grep 'units compiled' "$log" | tail -1)
echo "$case $side $rep $(tail -1 "$d/logs/$case-$side-$rep.time") rc=$rc | $summary" >> "$d/results.txt"
