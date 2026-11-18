#!/bin/bash
# #2924 C7's gate, the schedule (bit 9), which a plain -c doesn't run: benchmark-tier1-schedule (its scalar and vector
# schedule, each with its copy and encoding), three processes; and the ticks of --tier1 --tier1-schedule=post -c of
# sqlite3.c, Lua and musl with the schedule on vector (0) and on scalar (0x200), three rounds in turn, after their
# objects are compared. Under the lock on CPU 2, with run.sh's executable.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: Tier 1's gate, the schedule" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs/sched ticks/sched
for run in 1 2 3; do
    $L timeout -k 5 600 taskset -c 2 ./compiler-gate benchmark-tier1-schedule > logs/sched/bench-$run.log 2>&1
    echo "bench $run: $?" >> logs/sched/status.txt
done
objects=/dev/shm/claude-2924-c7sched
rm -rf "$objects"
for mask in 0 0x200; do
    EXTRA=--tier1-schedule=post BUSTER_TIER1_SCALAR_AREAS=$mask $L timeout -k 5 1500 "$D/objects.sh" "$D/compiler-gate" "$objects/$mask" > logs/sched/objects-$mask.log 2>&1
    echo "objects $mask: $(tr '\n' ' ' < logs/sched/objects-$mask.log)" >> logs/sched/status.txt
done
n=0; d=0
while read -r f; do n=$((n+1)); cmp -s "$objects/0/$f" "$objects/0x200/$f" || { d=$((d+1)); echo "differs: $f" >> logs/sched/objects-compare.txt; }; done < <(cd "$objects/0" && find . -name '*.o' | sort)
echo "objects 0x200: $n compared, $d differ" >> logs/sched/status.txt
rm -rf "$objects"
for round in 1 2 3; do
    for mask in 0 0x200; do
        rm -f "ticks/sched/$mask-$round.txt"
        EXTRA=--tier1-schedule=post BUSTER_TIER1_SCALAR_AREAS=$mask BUSTER_TIER1_AREA_TICKS="$D/ticks/sched/$mask-$round.txt" $L timeout -k 5 1500 taskset -c 2 "$D/objects.sh" "$D/compiler-gate" "$objects/t" > logs/sched/ticks-$mask-$round.log 2>&1
        echo "ticks $mask $round: $(tr '\n' ' ' < logs/sched/ticks-$mask-$round.log) $(wc -l < ticks/sched/$mask-$round.txt) lines" >> logs/sched/status.txt
        rm -rf "$objects"
    done
done
date -u +%FT%TZ > logs/sched/.done
