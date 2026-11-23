#!/usr/bin/env bash
# compile-cost.sh NAME RUNS MARCH -- ARGUMENTS...: `--tier1 -O2 -march=MARCH ARGUMENTS -o out/cost/NAME-V.o` by main's
# (BASE) and the branch's (HEAD) Release compilers, alternating, RUNS each, pinned to CPU 2 (so one lane): a line per run
# with user cycles, instructions and wall time; then each one's --tier1-report lines. Run under the lock.
set -u
NAME=$1
RUNS=$2
MARCH=$3
shift 4
cd "$(dirname "$0")"
mkdir -p out/cost
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ echo "before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH.busy
for run in $(seq 1 $RUNS); do
    for variant in base head; do
        compiler=$BASE
        [ $variant = head ] && compiler=$HEAD
        start=$EPOCHREALTIME
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/cost/perf.txt -- $compiler --tier1 -O2 -march=$MARCH "$@" -o out/cost/$NAME-$MARCH-$variant.o > /dev/null 2>&1
        status=$?
        end=$EPOCHREALTIME
        c=$(grep cycles out/cost/perf.txt | cut -d, -f1); i=$(grep instructions out/cost/perf.txt | cut -d, -f1)
        echo "cost $NAME $MARCH $variant $run $c $i $(awk -v a=$start -v b=$end 'BEGIN{printf "%.4f", b - a}') status $status"
    done
done
for variant in base head; do
    compiler=$BASE
    [ $variant = head ] && compiler=$HEAD
    $compiler --tier1 --tier1-report -O2 -march=$MARCH "$@" -o /dev/null 2>&1 | grep '^tier1' | sed "s/^/report $NAME $MARCH $variant: /"
    echo "size $NAME $MARCH $variant: $(size -A out/cost/$NAME-$MARCH-$variant.o | awk '$1 == ".text" { print $2 }')"
done
{ echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH.busy
