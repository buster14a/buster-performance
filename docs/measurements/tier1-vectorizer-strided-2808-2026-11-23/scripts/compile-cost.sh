#!/usr/bin/env bash
# compile-cost.sh SOURCE NAME RUNS MARCH: `--tier1 --tier1-passes=+vectorize -c SOURCE` by main's and the branch's
# Release compilers, alternating, RUNS each, pinned to CPU 2: a line per run with user cycles, instructions and wall
# time; then each one's --tier1-report vectorize line. Run under the lock.
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
    for variant in main branch; do
        compiler=$MAIN
        [ $variant = branch ] && compiler=$BUSTER
        start=$EPOCHREALTIME
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/cost/perf.txt -- $compiler --tier1 --tier1-passes=+vectorize -O2 -march=$MARCH -c "$SOURCE" -o out/cost/$NAME-$variant.o > /dev/null 2>&1
        status=$?
        end=$EPOCHREALTIME
        c=$(grep cycles out/cost/perf.txt | cut -d, -f1); i=$(grep instructions out/cost/perf.txt | cut -d, -f1)
        echo "cost $NAME $MARCH $variant $run $c $i $(awk -v a=$start -v b=$end 'BEGIN{printf "%.4f", b - a}') status $status"
    done
done
for variant in main branch; do
    compiler=$MAIN
    [ $variant = branch ] && compiler=$BUSTER
    echo "report $variant: $($compiler --tier1 --tier1-passes=+vectorize --tier1-report -O2 -march=$MARCH -c "$SOURCE" -o /dev/null 2>&1 | grep '^tier1-vectorize')"
done
{ echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH.busy
