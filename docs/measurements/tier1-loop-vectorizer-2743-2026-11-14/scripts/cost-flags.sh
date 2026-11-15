#!/usr/bin/env bash
# cost-flags.sh SOURCE NAME RUNS MARCH BASE VECTORIZE: compile-cost.sh with the two variants' --tier1-passes= lists
# given (e.g. -inline and -inline,+vectorize), alternating, RUNS each, pinned to CPU 2. Run under the lock.
set -u
SOURCE=$1
NAME=$2
RUNS=$3
MARCH=$4
BASE=$5
VECTORIZE=$6
cd "$(dirname "$0")"
mkdir -p out/cost
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ echo "before: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH-flags.busy
for run in $(seq 1 $RUNS); do
    for variant in base vectorize; do
        passes=$BASE
        [ $variant = vectorize ] && passes=$VECTORIZE
        start=$EPOCHREALTIME
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u -o out/cost/perf.txt -- $BUSTER --tier1 --tier1-passes=$passes -O2 -march=$MARCH -c "$SOURCE" -o /dev/shm/claude-2743-$variant.o > /dev/null 2>&1
        status=$?
        end=$EPOCHREALTIME
        c=$(grep cycles out/cost/perf.txt | cut -d, -f1); i=$(grep instructions out/cost/perf.txt | cut -d, -f1)
        echo "cost $NAME $MARCH $variant $run $c $i $(awk -v a=$start -v b=$end 'BEGIN{printf "%.4f", b - a}') passes $passes status $status"
    done
done
rm -f /dev/shm/claude-2743-base.o /dev/shm/claude-2743-vectorize.o
{ echo "after: $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> out/cost/$NAME-$MARCH-flags.busy
