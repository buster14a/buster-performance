#!/bin/bash
# prof2.sh NAME RUNS VARIANT...: perf record -e EVENT (cycles:u) -c PERIOD (200003) of sqlite3.c's sq-c (--lanes 1,
# CPU 2), one lock grant per compile, rotated. The reports are made off the host (attr.py).
set -u
name=$1; runs=$2; shift 2
variants=("$@")
W=~/buster-fast-bench/1489-claude
out=$W/prof/$name; mkdir -p $out/raw
LOCK=(env EXCLUSIVE_OWNER=claude-1489 "EXCLUSIVE_TITLE=Solve 1489 (check-input growth)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 ~/buster-fast-bench/exclusive.sh)
cd $W/root || exit 2
SCRATCH=../scratch
source ./workloads.sh
EVENT=${EVENT:-cycles:u}
n=${#variants[@]}
for ((r = 0; r < runs; r++)); do
    for ((i = 0; i < n; i++)); do
        v=${variants[$(( (i + r) % n ))]}
        workload $v sq-c
        "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; cat /proc/loadavg >> $out/loadavg.txt; taskset -c 2 perf record -q -e $EVENT -c ${PERIOD:-200003} -o $out/raw/$v.$r.data -- $(printf '%q ' "${WL[@]}") > /dev/null 2>&1; echo \"prof $v $r status=\$?\" >> $out/status.txt" 2>> $out/lock.log
    done
done
echo done > $out/done
