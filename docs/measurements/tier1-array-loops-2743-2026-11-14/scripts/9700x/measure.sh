#!/usr/bin/env bash
# measure.sh MARCH...: build every configuration, then time each at its placements, one lock hold per
# (build, placement). Started detached; writes measure.done at the end.
set -u
cd ~/buster-fast-bench/2743-droid/loops || exit 1
export EXCLUSIVE_OWNER=droid-2743
export EXCLUSIVE_TITLE="Issue 2743: Tier 1 on array loops"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
LOCK=~/buster-fast-bench/exclusive.sh
export BUSTER=~/buster-fast-bench/2743-droid/tree-c471f32f/build/compiler
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
export GCC=gcc
rm -f measure.done
{
    date -u +%FT%TZ
    uname -a
    $CLANG --version | head -2
    $GCC --version | head -1
    perf --version
    python3 --version
    echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    grep -m1 'model name' /proc/cpuinfo
    echo "tree commit: $(cat ~/buster-fast-bench/2743-droid/tree-c471f32f/COMMIT)"
    sha256sum $BUSTER
} > env.txt 2>&1
for MARCH in "$@"; do
    O=out/$MARCH
    mkdir -p $O
    $LOCK bash -c "head -1 /var/lib/buster-9700x/owner >> holds.txt; ./build-9700x.sh $MARCH" > $O/build.log 2>&1
    : > $O/results.txt
    for NAME in buster-tier1 clang-O2 clang-O2-novec clang-O2-novec-nounroll buster-tier1-hand clang-O2-hand clang-O1 buster-tier0 gcc-O2; do
        [ -x $O/p0-$NAME ] || continue
        for PAD in 0 16 32 48; do
            $LOCK ./run-one.sh $MARCH $NAME $PAD >> $O/results.txt 2>> $O/run.log
        done
    done
    for NAME in clang-O0 clang-O3 gcc-O3 buster-tier1-licm buster-tier1-all; do
        [ -x $O/p0-$NAME ] || continue
        $LOCK ./run-one.sh $MARCH $NAME 0 >> $O/results.txt 2>> $O/run.log
    done
    echo "done $MARCH $(date -u +%FT%TZ)" >> progress.txt
done
echo done > measure.done
