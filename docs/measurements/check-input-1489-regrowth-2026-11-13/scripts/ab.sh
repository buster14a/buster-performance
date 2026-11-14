#!/bin/bash
# ab.sh NAME ROUNDS VARIANT...: sqlite3.c's -c --lanes 1 --time-stages on CPU 2, from the run root
# (tools/microarch/workloads.sh's sq-c), variants root/bin/compiler-VARIANT. Every compile and every perf stat run takes
# its own lock grant; rounds run the variants in an order rotated by the round. Each grant records the holder line,
# /proc/loadavg and the busiest processes before and after its run (procs.txt), and its exit status (status.txt).
# STAT_ROUNDS (default 5) single-run perf stat rounds follow, rotated the same way.
set -u
name=$1; rounds=$2; shift 2
variants=("$@")
W=~/buster-fast-bench/1489-claude
out=$W/ab/$name; mkdir -p $out/raw
LOCK=(env EXCLUSIVE_OWNER=claude-1489 "EXCLUSIVE_TITLE=Solve 1489 (check-input growth)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 ~/buster-fast-bench/exclusive.sh)
cd $W/root || exit 2
SCRATCH=../scratch
source ./workloads.sh
{
    date -Is; uname -a; clang --version | head -1; perf --version
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    for v in "${variants[@]}"; do
        t=$(readlink -f bin/compiler-$v)
        c=$(cat "$(dirname "$(dirname "$t")")/COMMIT" 2>/dev/null || cat "$t.commit" 2>/dev/null)
        echo "$v: $t $c"
    done
    sha256sum bin/compiler-* corpus/sqlite/sqlite3.c corpus/provenance/gnu17-pinned-predefines.txt
} > $out/host.txt 2>&1
snap='{ echo "== $(date +%FT%T.%N%z) $1"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> '$out/procs.txt
n=${#variants[@]}
run() # run LABEL COMMAND: one lock grant
{
    local label=$1; shift
    "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; set -- '$label before'; $snap; $*; echo \"$label status=\$?\" >> $out/status.txt; set -- '$label after'; $snap" 2>> $out/lock.log
}
for ((r = 0; r < rounds; r++)); do
    for ((i = 0; i < n; i++)); do
        v=${variants[$(( (i + r) % n ))]}
        workload $v sq-c
        run "sq $v $r" "taskset -c 2 $(printf '%q ' "${WL[@]}") --time-stages > /dev/null 2> $out/raw/sq-$v.$r.log"
        printf 'sq %s %s\t%s\n' $v $r "$(sha256sum < $SCRATCH/$v-sq.o | cut -c1-64)" >> $out/objects.txt
    done
done
for ((r = 0; r < ${STAT_ROUNDS:-5}; r++)); do
    for ((i = 0; i < n; i++)); do
        v=${variants[$(( (i + r) % n ))]}
        workload $v sq-c
        run "stat $v $r" "taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,task-clock -o $out/raw/stat-$v.$r.csv -- $(printf '%q ' "${WL[@]}") > /dev/null 2>&1"
        printf 'stat %s %s\t%s\n' $v $r "$(sha256sum < $SCRATCH/$v-sq.o | cut -c1-64)" >> $out/objects.txt
    done
done
for v in "${variants[@]}"; do
    for ((r = 0; r < rounds; r++)); do
        printf 'diagnostics %s %s\t%s\n' $v $r "$(grep -v -E '^(time-|lowering-nodes)' $out/raw/sq-$v.$r.log | sha256sum | cut -c1-64)"
    done
done > $out/diagnostics.txt
median() { sort -g | awk '{a[NR]=$1} END{printf "%s\t(%s .. %s, n=%d)\n", a[int((NR+1)/2)], a[1], a[NR], NR}'; }
for v in "${variants[@]}"; do
    for st in preprocess parse check-input check-expressions check-program lower write total; do
        printf '%s\t%s\t' "$v" "$st"; cat $out/raw/sq-$v.*.log | awk -v s=$st '$1=="time-stage" && $2==s {print $3}' | median
    done
    for ev in cycles:u instructions:u branch-misses:u task-clock; do
        printf '%s\t%s\t' "$v" "$ev"; cat $out/raw/stat-$v.*.csv 2>/dev/null | awk -F, -v e=$ev '$3==e {print $1}' | median
    done
done > $out/summary.tsv
echo done > $out/done
