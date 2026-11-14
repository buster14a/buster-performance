#!/usr/bin/env bash
# compile-cost.sh SOURCE NAME RUNS MARCH: `--tier1 -c SOURCE` by the branch's Release compiler without and with
# --tier1-passes=+vectorize, alternating, RUNS each, pinned to CPU 2: a line per run with user cycles, instructions and
# wall time. Run under the lock.
set -u
SOURCE=$1
NAME=$2
RUNS=$3
MARCH=$4
cd "$(dirname "$0")"
mkdir -p out/cost
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ echo "before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH.busy
for run in $(seq 1 $RUNS); do
    for variant in base vectorize; do
        extra=""
        [ $variant = vectorize ] && extra="--tier1-passes=+vectorize"
        start=$EPOCHREALTIME
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/cost/perf.txt -- $BUSTER --tier1 $extra -O2 -march=$MARCH -c "$SOURCE" -o out/cost/$NAME-$variant.o > /dev/null 2>&1
        status=$?
        end=$EPOCHREALTIME
        c=$(grep cycles out/cost/perf.txt | cut -d, -f1); i=$(grep instructions out/cost/perf.txt | cut -d, -f1)
        echo "cost $NAME $MARCH $variant $run $c $i $(awk -v a=$start -v b=$end 'BEGIN{printf "%.4f", b - a}') status $status"
    done
done
{ echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH.busy
