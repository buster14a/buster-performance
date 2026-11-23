#!/bin/bash
# round.sh OUT ROUND VARIANT...: one A/B round, run inside one lock grant (ab2.sh): each variant's sqlite3.c sq-c
# (-c --lanes 1, CPU 2) with --time-stages in the order given, then each one's single-run perf stat in the same order.
# Records the holder line, /proc/loadavg and the busiest processes before and after (procs.txt), each run's exit status
# (status.txt) and object SHA-256 (objects.txt).
set -u
out=$1; r=$2; shift 2
cd ~/buster-fast-bench/2694-claude/root || exit 2
SCRATCH=../scratch
source ./workloads.sh
snap() { { echo "== $(date +%FT%T.%N%z) $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> $out/procs.txt; }
head -1 /var/lib/buster-9700x/owner >> $out/holds.txt
snap "round $r before"
for v in "$@"; do
    workload $v sq-c
    taskset -c 2 "${WL[@]}" --time-stages > /dev/null 2> $out/raw/sq-$v.$r.log
    echo "sq $v $r status=$?" >> $out/status.txt
    printf 'sq %s %s\t%s\n' $v $r "$(sha256sum < $SCRATCH/$v-sq.o | cut -c1-64)" >> $out/objects.txt
done
if [ "${STAT:-1}" = 1 ]; then
    for v in "$@"; do
        workload $v sq-c
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,task-clock -o $out/raw/stat-$v.$r.csv -- "${WL[@]}" > /dev/null 2>&1
        echo "stat $v $r status=$?" >> $out/status.txt
        printf 'stat %s %s\t%s\n' $v $r "$(sha256sum < $SCRATCH/$v-sq.o | cut -c1-64)" >> $out/objects.txt
    done
fi
snap "round $r after"
