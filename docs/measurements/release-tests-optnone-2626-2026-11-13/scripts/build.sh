#!/bin/bash
# One timed build of a tree, inside the lock (lock.sh): build.sh TREE NAME DEBUG [shifts]
# DEBUG is BUSTER_DEBUG_INFO (0: the 9700X job's executable; 1: -g). With `shifts`, the executable and its placements,
# main.c's code moved by 0, 1088, 2112 and 3136 bytes, into placements/NAME.
set -u
d=$HOME/buster-fast-bench/2626-claude
. "$d/scripts/env.sh"
tree=$1; name=$2; export BUSTER_DEBUG_INFO=$3; mode=${4:-}
cd "$d/$tree" || exit 2
log=$d/logs/build-$name
head -1 /var/lib/buster-9700x/owner > "$log.holder.txt"
TIMEFORMAT='%R %U %S'
if [ "$mode" = shifts ]; then
    mkdir -p "$d/placements/$name"
    { time ./build.sh shifts --config Release --jobs 8 "$d/placements/$name" main.c 0 1088 2112 3136 > "$log.log" 2>&1; } 2> "$log.time"
else
    { time ./build.sh --config Release --jobs 8 > "$log.log" 2>&1; } 2> "$log.time"
fi
status=$?
echo "status $status" >> "$log.time"
printf '%s\t%s\t%s\n' "$name" "$(head -1 "$log.time")" "status $status" >> "$d/results/builds.txt"
exit $status
