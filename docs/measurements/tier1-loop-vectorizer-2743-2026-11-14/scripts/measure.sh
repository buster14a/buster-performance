#!/usr/bin/env bash
# measure.sh: buster#2743's loop vectorizer on the 9700X, started detached (systemd-run --user). Release builds of the
# branch's tree (`tree`) and of main's (`main`), then for x86-64 and znver5 the kernels' builds (one hold) and every
# timed build at its four placements (one hold each), then the compile-cost A/B on sqlite3.c (one hold per target).
# Writes progress.txt as it goes and measure.done at the end.
set -u
R=~/buster-fast-bench/2743-claude
cd $R || exit 1
export EXCLUSIVE_OWNER=claude-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 loop vectorizer"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
LOCK=~/buster-fast-bench/exclusive.sh
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export BUSTER=$R/tree/build/compiler
export MAIN=$R/main/build/compiler
step() { echo "$(date -u +%FT%TZ) $*" >> $R/progress.txt; }
rm -f measure.done
step start
[ -x $BUSTER ] || { $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd tree && ./build.sh --config Release" > build-tree.log 2>&1; echo "exit $?" >> build-tree.log; }
[ -x $MAIN ] || { $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; cd main && ./build.sh --config Release" > build-main.log 2>&1; echo "exit $?" >> build-main.log; }
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
for MARCH in x86-64 znver5; do
    O=out/$MARCH
    mkdir -p $O
    $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; ./build-9700x.sh $MARCH" > $O/build.log 2>&1
    step "built kernels $MARCH"
    : > $O/results.txt
    for NAME in buster-tier1-vec buster-tier1 clang-O2 clang-O2-novec clang-O2-novec-nounroll; do
        for PAD in 0 16 32 48; do
            $LOCK ./run-one.sh $MARCH $NAME $PAD >> $O/results.txt 2>> $O/run.log
        done
        step "ran $MARCH $NAME"
    done
    if [ "$MARCH" != x86-64 ]; then
        for NAME in buster-tier1-hand clang-O2-hand; do
            $LOCK ./run-one.sh $MARCH $NAME 0 >> $O/results.txt 2>> $O/run.log
        done
        step "ran $MARCH hand"
    fi
done
SQLITE=$R/corpus/sqlite/sqlite3.c
mkdir -p out/cost
if [ -f $SQLITE ]; then
    for MARCH in znver5 x86-64; do
        $LOCK ./compile-cost.sh $SQLITE sqlite3 11 $MARCH >> out/cost/results.txt 2>> out/cost/run.log
        step "cost $MARCH"
    done
fi
step done
echo done > $R/measure.done
