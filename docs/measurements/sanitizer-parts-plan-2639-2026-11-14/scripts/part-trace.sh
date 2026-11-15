#!/bin/bash
# part-trace.sh TAG VARIANT UNIT: under one hold of the 9700X's lock, generates each code part of UNIT in the
# VARIANT tree of $TREE (default src) at once, part N pinned to CPU N (one thread of each core), with -ftime-trace at
# granularity 0, and the build's own command for the part (ninja -t commands). Writes results/TAG/: partN.json,
# partN.time (wall seconds), commands.txt.
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
variant=$2
unit=$3
out=$base/results/$tag
mkdir -p "$out"
cd "$base/${TREE:-src}/build/cmake/$variant"
parts=$(ls Release/codegen/$unit/part*.bc | wc -l)
last=$((parts - 2))
: > "$out/commands.txt"
for p in $(seq 0 $last); do
    ninja -f build-Release.ninja -t commands Release/codegen/$unit/part$p.o | tail -1 | sed "s/^cd [^&]* && //" >> "$out/commands.txt"
done
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out" LAST="$last"
~/buster-fast-bench/exclusive.sh timeout -k 10 900 bash -c '
    { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > "$OUT/before.txt"
    p=0
    while IFS= read -r command; do
        ( start=$EPOCHREALTIME
          eval "taskset -c $p $command -ftime-trace=$OUT/part$p.json -ftime-trace-granularity=0"
          echo "$? $(echo "$EPOCHREALTIME - $start" | bc)" > "$OUT/part$p.time" ) &
        p=$((p + 1))
    done < "$OUT/commands.txt"
    wait
    { date -Is; cat /proc/loadavg; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
