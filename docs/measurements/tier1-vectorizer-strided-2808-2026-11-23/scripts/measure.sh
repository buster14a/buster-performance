#!/usr/bin/env bash
# measure.sh: buster#3321 (#2808) on the 9700X, detached. Release builds of the PR's merged head (`tree`) and of the
# main it merged (`main`), each under its own hold; the znver5 kernels' builds (one hold); main's and the branch's
# `--tier1 --tier1-passes=+vectorize` at four placements (one hold each); sqlite3.c's compile cost (one hold).
# clang -O2's timings are reused from ../2808-claude when its kernels' object is byte-identical (checked by sha256).
set -u
R=~/buster-fast-bench/3321-claude
cd $R || exit 1
export EXCLUSIVE_OWNER=claude-3321
export EXCLUSIVE_TITLE="buster #3321: Tier 1 vectorizer counts, strided loads, 32-bit indices"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3321
LOCK=~/buster-fast-bench/exclusive.sh
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export BUSTER=$R/tree/build/compiler
export MAIN=$R/main/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
BUSY='{ echo "$(date -u +%FT%TZ) $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> '$R/busy.txt
rm -f measure.done
step start
[ -x $BUSTER ] || { $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd tree && timeout -k 5 1800 ./build.sh --config Release" > build-tree.log 2>&1; echo "exit $?" >> build-tree.log; }
[ -x $MAIN ] || { $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd main && timeout -k 5 1800 ./build.sh --config Release" > build-main.log 2>&1; echo "exit $?" >> build-main.log; }
step built
{
    date -u +%FT%TZ
    uname -a
    $CLANG --version | head -2
    perf --version
    echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    grep -m1 'model name' /proc/cpuinfo
    echo "tree: $(git -C tree rev-parse HEAD)"
    echo "main: $(git -C main rev-parse HEAD)"
    sha256sum $BUSTER $MAIN
} > env.txt 2>&1
cd $R/loops
O=out/znver5
mkdir -p $O
for attempt in 1 2; do
    [ -x $O/p48-buster-tier1-vec ] || $LOCK bash -c "$BUSY; timeout -k 5 1200 ./build-kernels.sh znver5" > $O/build.log 2>&1
done
step "built kernels znver5"
: > $O/results.txt
for NAME in buster-tier1-vec main-tier1-vec; do
    for PAD in 0 16 32 48; do
        $LOCK bash -c "$BUSY; timeout -k 5 1800 ./run-one.sh znver5 $NAME $PAD; $BUSY" >> $O/results.txt 2>> $O/run.log
    done
    step "ran znver5 $NAME"
done
mkdir -p out/cost
$LOCK bash -c "$BUSY; timeout -k 5 1800 ./compile-cost.sh $R/corpus/sqlite3.c sqlite3 11 znver5; $BUSY" >> out/cost/results.txt 2>> out/cost/run.log
step "cost znver5"
step done
echo done > $R/measure.done
