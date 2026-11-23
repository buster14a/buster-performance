#!/bin/bash
# prof.sh NAME RUNS VARIANT... (after check-input-1489-regrowth-2026-11-13's prof2.sh): perf record -e EVENT
# (instructions:u) -c PERIOD (200003) of sqlite3.c's sq-c (--lanes 1, CPU 2); one lock grant a round, every variant
# once in a rotated order. After its records each grant writes the samples' addresses (perf script -F ip,dso): "IP C"
# in the compiler, "IP O" elsewhere.
set -u
name=$1; runs=$2; shift 2
variants=("$@")
W=~/buster-fast-bench/2694-claude
out=$W/prof/$name; mkdir -p $out/raw
LOCK=(env EXCLUSIVE_OWNER=claude-2694 "EXCLUSIVE_TITLE=#2694: check-input regrowth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2694 ~/buster-fast-bench/exclusive.sh)
cd $W/root || exit 2
SCRATCH=../scratch
source ./workloads.sh
EVENT=${EVENT:-instructions:u}
n=${#variants[@]}
for ((r = 0; r < runs; r++)); do
    cmd="head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; cat /proc/loadavg >> $out/loadavg.txt;"
    post=""
    for ((i = 0; i < n; i++)); do
        v=${variants[$(( (i + r) % n ))]}
        workload $v sq-c
        d=$out/raw/$v.$r.data
        cmd+=" taskset -c 2 perf record -q -e $EVENT -c ${PERIOD:-200003} -o $d -- $(printf '%q ' "${WL[@]}") > /dev/null 2>&1; echo \"prof $v $r status=\$?\" >> $out/status.txt;"
        post+=" perf script -F ip,dso -i $d 2>/dev/null | awk '{print \$1, (index(\$2, \"compiler\") ? \"C\" : \"O\")}' > $out/$v.$r.ips;"
    done
    "${LOCK[@]}" bash -c "$cmd $post" 2>> $out/lock.log
done
echo done > $out/done
