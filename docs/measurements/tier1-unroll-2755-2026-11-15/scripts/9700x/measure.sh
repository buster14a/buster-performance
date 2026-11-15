#!/usr/bin/env bash
# measure.sh MARCH...: build every configuration for each target, then time them, one lock hold per pair of builds at one
# placement (run-pair.sh). x86-64: Tier 1 at the base and with +unroll, and clang -O2 without its vectorizer, at the four
# placements; clang -O2 without its vectorizer or unroller, and whole, at placement 0. znver5: the same at placement 0.
# Started by pipeline.sh (x86-64) and pipeline2.sh (znver5); writes measure.done at the end.
set -u
cd ~/buster-fast-bench/2755-claude/loops || exit 1
export EXCLUSIVE_OWNER=claude-2755
export EXCLUSIVE_TITLE="Issue 2755: Tier 1 loop unrolling"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2755
LOCK=~/buster-fast-bench/exclusive.sh
export BASE=~/buster-fast-bench/2755-claude/tree-base/build/compiler
export HEAD=~/buster-fast-bench/2755-claude/tree-head/build/compiler
export CLANG=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)
rm -f measure.done
{
    date -u +%FT%TZ
    uname -a
    $CLANG --version | head -2
    perf --version
    python3 --version
    echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp: $(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"
    grep -m1 'model name' /proc/cpuinfo
    echo "base commit: $(cat ~/buster-fast-bench/2755-claude/tree-base/COMMIT)"
    echo "head commit: $(cat ~/buster-fast-bench/2755-claude/tree-head/COMMIT)"
    sha256sum $BASE $HEAD
} > env.txt 2>&1
for MARCH in "$@"; do
    O=out/$MARCH
    mkdir -p $O
    $LOCK ./build-unroll.sh $MARCH > $O/build.log 2>&1
    : > $O/results.txt
    pads="0 16 32 48"
    [ "$MARCH" = znver5 ] && pads=0
    for PAD in $pads; do
        $LOCK ./run-pair.sh $MARCH tier1-base tier1-unroll $PAD >> $O/results.txt 2>> $O/run.log
        if [ "$PAD" = 0 ]; then
            $LOCK ./run-pair.sh $MARCH clang-O2-novec clang-O2-novec-nounroll $PAD >> $O/results.txt 2>> $O/run.log
            $LOCK ./run-one.sh $MARCH clang-O2 $PAD >> $O/results.txt 2>> $O/run.log
        else
            $LOCK ./run-one.sh $MARCH clang-O2-novec $PAD >> $O/results.txt 2>> $O/run.log
        fi
    done
    echo "done $MARCH $(date -u +%FT%TZ)" >> progress.txt
done
echo done > measure.done
