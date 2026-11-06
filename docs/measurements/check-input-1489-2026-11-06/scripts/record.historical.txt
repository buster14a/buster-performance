#!/bin/bash
# record.sh: #1489's 9700X record. Builds main (rbase) and the PR's head (rhead), znver5 without debug information, then
# times pre-#1049 (aca9e53a, #1340's record's binary), rbase and rhead on the frozen sqlite3.c (-c --lanes 1, CPU 2),
# each lock hold one round of the three in a rotated order, plus perf stat and the compiler's own main.c.
set -u
W=~/buster-fast-bench/1489-opencode
R=$W/record
mkdir -p $R/raw
LOCK=(env EXCLUSIVE_OWNER=opencode-1489 EXCLUSIVE_TITLE="#1489 check-input regression" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 ~/buster-fast-bench/exclusive.sh)
{
    date -Is; uname -a; clang --version | head -1; perf --version; cmake --version | head -1
    grep -m1 "model name" /proc/cpuinfo
    echo "cpu2 governor: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    echo "thp enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled) defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    echo "rbase commit: $(cat $W/rbase.commit)"; echo "rhead commit: $(cat $W/rhead.commit)"
    echo "pre1049 commit: $(cat ~/buster-fast-bench/1340-droid/root/bin/compiler-pre1049-znver5.commit)"
} > $R/host.txt 2>&1
mkdir -p $W/pre1049/build && ln -sfn ~/buster-fast-bench/1340-droid/root/bin/compiler-pre1049-znver5 $W/pre1049/build/compiler
for b in rbase rhead; do
    (cd $W/$b && "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh" > $R/raw/build-$b.log 2>&1; echo "build $b status=$?" >> $R/status.txt)
done
cd ~/buster-fast-bench/1340-droid/root || exit 2
source ../repo/tools/microarch/workloads.sh
corpus=corpus
builds=(pre1049 rbase rhead)
sha256sum $W/pre1049/build/compiler $W/rbase/build/compiler $W/rhead/build/compiler corpus/sqlite/sqlite3.c self-main.i corpus/provenance/gnu17-pinned-predefines.txt predefines-znver5.h > $R/sha256.txt
for ((r = 0; r < 11; r++)); do
    cmds=""
    for ((i = 0; i < 3; i++)); do
        b=${builds[$(( (i + r) % 3 ))]}
        cmds+="taskset -c 2 $W/$b/build/compiler $(printf '%q ' "${COMMON[@]}" "${SQLITE[@]}") -c -o $W/scratch/$b-sq.o --lanes 1 --time-stages > /dev/null 2> $R/raw/sq-$b.$r.log; echo \"sq $b round $r status=\$?\" >> $R/status.txt; "
    done
    "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; $cmds"
done
for b in "${builds[@]}"; do
    cmd="taskset -c 2 perf stat -r 5 -x, -e cycles:u,instructions:u,branches:u,branch-misses:u,task-clock -o $R/raw/stat-$b.csv -- $W/$b/build/compiler $(printf '%q ' "${COMMON[@]}" "${SQLITE[@]}") -c -o $W/scratch/$b-sq.o --lanes 1"
    "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; $cmd > /dev/null 2>&1; echo \"stat $b status=\$?\" >> $R/status.txt"
done
for r in 0 1 2; do
    order=(rbase rhead); [ $((r % 2)) = 1 ] && order=(rhead rbase)
    cmds=""
    for b in "${order[@]}"; do
        cmds+="taskset -c 2 $W/$b/build/compiler $(printf '%q ' "${SELF_OPTIONS[@]}") -fsyntax-only self-main.i --time-stages > /dev/null 2> $R/raw/self-$b.$r.log; echo \"self $b round $r status=\$?\" >> $R/status.txt; "
    done
    "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; $cmds"
done
# The outputs: each build's object and diagnostics, by sha256 (the time-stages lines stripped).
for b in "${builds[@]}"; do
    sha256sum $W/scratch/$b-sq.o | sed "s|$W/scratch/||"
    grep -v -E '^(time-stage|time-check|time-process|lowering-nodes)' $R/raw/sq-$b.0.log | sha256sum | sed "s/-$/sq-$b diagnostics/"
    grep -v -E '^(time-stage|time-check|time-process|lowering-nodes)' $R/raw/self-rbase.0.log | sha256sum | sed "s/-$/self-rbase diagnostics/"
done > $R/outputs.txt 2>&1
grep -v -E '^(time-stage|time-check|time-process|lowering-nodes)' $R/raw/self-rhead.0.log | sha256sum | sed "s/-$/self-rhead diagnostics/" >> $R/outputs.txt
median() { sort -g | awk '{a[NR]=$1} END{printf "%s\t(%s .. %s, n=%d)\n", a[int((NR+1)/2)], a[1], a[NR], NR}'; }
for b in "${builds[@]}"; do
    for st in preprocess parse check-input check-expressions check-program lower total; do
        printf 'sq\t%s\t%s\t' "$b" "$st"; cat $R/raw/sq-$b.*.log | awk -v s=$st '$1=="time-stage" && $2==s {print $3}' | median
    done
done > $R/summary.tsv
for b in rbase rhead; do
    for st in check-input check-program total; do
        printf 'self\t%s\t%s\t' "$b" "$st"; cat $R/raw/self-$b.*.log | awk -v s=$st '$1=="time-stage" && $2==s {print $3}' | median
    done
done >> $R/summary.tsv
echo done > $R/done
