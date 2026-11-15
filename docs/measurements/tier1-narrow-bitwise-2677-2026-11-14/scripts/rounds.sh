#!/bin/bash
# #2677's kernels on the 9700X, rounds FIRST to LAST in one hold of the lock (measure.sh's rounds, each its build order
# rotated by round and each run after an untimed warm-up, pinned to CPU 2): rounds.sh FIRST LAST. measure.sh built the
# objects and ran round 1 in holds of their own; at the lock's queue of 2026-11-14 23:30-23:55 UTC a hold per round
# took ~30 minutes each, so the other rounds share holds of ~20 s. Appends to results.tsv.
set -u
cd "$(dirname "$0")"
first=$1
last=$2
export EXCLUSIVE_OWNER=claude-2677 EXCLUSIVE_TITLE="#2677 Tier 1 i1/i8/i16 and/or/xor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2677
kernels="null clamp and andor andori"
builds="main head o2"
{
    echo "head -1 /var/lib/buster-9700x/owner >> holds.txt"
    for round in $(seq "$first" "$last"); do
        all=($builds)
        r=$(( (round - 1) % 3 ))
        order="${all[*]:r} ${all[*]:0:r}"
        cat <<ROUND
echo "== round $round: \$(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt
for k in $kernels; do
    for b in $order; do
        taskset -c 2 ./bench_\$b \$k > /dev/null
        start=\$(date +%s%N)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u -o stat.csv ./bench_\$b \$k > /dev/null
        status=\$?
        end=\$(date +%s%N)
        c=\$(awk -F, '\$3 ~ /^cycles/ { print \$1 }' stat.csv)
        i=\$(awk -F, '\$3 ~ /^instructions/ { print \$1 }' stat.csv)
        m=\$(awk -F, '\$3 ~ /^branch-misses/ { print \$1 }' stat.csv)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' $round \$k \$b \$c \$i \$m \$(( end - start )) \$status >> results.tsv
    done
done
echo "== after round $round: \$(cat /proc/loadavg)" >> busy.txt
ROUND
    done
} > rounds-$first-$last.sh
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash rounds-$first-$last.sh 2>> lock.log
echo "rounds $first-$last exit $?"
