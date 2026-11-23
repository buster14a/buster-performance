#!/bin/bash
# ab2.sh NAME ROUNDS VARIANT...: sqlite3.c's -c --lanes 1 --time-stages on CPU 2 (tools/microarch/workloads.sh's sq-c),
# variants root/bin/compiler-VARIANT; one lock grant a round (round.sh: every variant's compile, then every one's perf
# stat, STAT=0 for none), the variants' order rotated by the round. Summaries as check-input-1489-regrowth-2026-11-13's
# ab.sh writes them.
set -u
name=$1; rounds=$2; shift 2
variants=("$@")
W=~/buster-fast-bench/2694-claude
out=$W/ab/$name; mkdir -p $out/raw
LOCK=(env EXCLUSIVE_OWNER=claude-2694 "EXCLUSIVE_TITLE=#2694: check-input regrowth" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2694 ~/buster-fast-bench/exclusive.sh)
cd $W/root || exit 2
{
    date -Is; uname -a; perf --version
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    for v in "${variants[@]}"; do
        t=$(readlink -f bin/compiler-$v)
        echo "$v: $t $(cat "$(dirname "$(dirname "$t")")/COMMIT" 2>/dev/null) $(sha256sum < $t | cut -c1-64)"
    done
    sha256sum corpus/sqlite/sqlite3.c corpus/provenance/gnu17-pinned-predefines.txt
} > $out/host.txt 2>&1
n=${#variants[@]}
for ((r = 0; r < rounds; r++)); do
    order=()
    for ((i = 0; i < n; i++)); do order+=("${variants[$(( (i + r) % n ))]}"); done
    "${LOCK[@]}" $W/round.sh $out $r "${order[@]}" 2>> $out/lock.log
done
for v in "${variants[@]}"; do
    for ((r = 0; r < rounds; r++)); do
        printf 'diagnostics %s %s\t%s\n' $v $r "$(grep -v -E '^(time-|lowering-nodes|worker-budget)' $out/raw/sq-$v.$r.log | sha256sum | cut -c1-64)"
    done
done > $out/diagnostics.txt
median() { sort -g | awk '{a[NR]=$1} END{printf "%s\t(%s .. %s, n=%d)\n", a[int((NR+1)/2)], a[1], a[NR], NR}'; }
for v in "${variants[@]}"; do
    for st in preprocess parse check-input check-expressions check-declarations check-program lower tier0 total; do
        printf '%s\t%s\t' "$v" "$st"; cat $out/raw/sq-$v.*.log | awk -v s=$st '$1=="time-stage" && $2==s {print $3}' | median
    done
    printf '%s\t%s\t' "$v" "check-input-faults"; cat $out/raw/sq-$v.*.log | awk '$1=="time-stage" && $2=="check-input" {print $6}' | median
    printf '%s\t%s\t' "$v" "check-input-system"; cat $out/raw/sq-$v.*.log | awk '$1=="time-stage" && $2=="check-input" {print $5}' | median
    for ev in cycles:u instructions:u branch-misses:u task-clock; do
        printf '%s\t%s\t' "$v" "$ev"; cat $out/raw/stat-$v.*.csv 2>/dev/null | awk -F, -v e=$ev '$3==e {print $1}' | median
    done
done > $out/summary.tsv
echo done > $out/done
