#!/bin/bash
# One timed build of the balanced parallel native generation A/B, inside the 9700X lock: SIDE CASE FILE REP.
set -u
export LC_ALL=C
side=$1; case=$2; file=$3; rep=$4
d=$HOME/buster-fast-bench/2056-claude
cd "$d/$side" || exit 2
# A rebuild case edits the file: it appends an emitted function, the same on both sides, so that the unit changes.
if [ "$case" = fresh ] || [ "$case" = warm ]; then rm -rf build; else printf "\n__attribute__((used)) static int buster_ab_probe5_%s_%s(void)\n{\n    return %s;\n}\n" "$case" "$rep" "$rep" >> "src/buster/compiler/$file"; fi
log=$d/logs/5-$case-$side-$rep.log
TIMEFORMAT='%R %U %S'
{ time ./build.sh > "$log" 2>&1; } 2> "$d/logs/5-$case-$side-$rep.time"
rc=$?
cp build/cmake/native/.ninja_log "$d/logs/5-$case-$side-$rep.ninja_log" 2>/dev/null
summary=$(grep 'units compiled' "$log" | tail -1)
echo "$case $side $rep $(tail -1 "$d/logs/5-$case-$side-$rep.time") rc=$rc | $summary" >> "$d/results5.txt"
