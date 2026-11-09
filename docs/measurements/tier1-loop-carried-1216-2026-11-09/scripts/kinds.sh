#!/usr/bin/env bash
# kinds.sh REV NAME: a clean worktree of REV with kinds-instrumentation.patch (BUSTER_TIER1_MEASURE_KINDS), its
# compiler built and kept as b/compiler-clean-NAME, its patch against REV saved, then m.sh's tagged counts into
# b/m-clean-NAME.
set -u
S=~/.cache/droid-1216/S; R=/home/david/dev/ai/droid/buster; REV=$1; N=$2; W=~/.cache/droid-1216/wt-clean-$N
export CORES_TITLE="droid #1216 clean tagged build $N" CORES_LINK="https://github.com/buster14a/buster/issues/1216"
[ -d $W ] || git -C $R worktree add -q --detach $W $REV || exit 1
cd $W && git reset -q --hard $REV && git apply --3way $S/bench/kinds-instrumentation.patch || { echo "patch failed"; exit 1; }
git -C $W diff HEAD > $S/bench/kinds-instrumentation-$N.patch
(cd $W && BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES='-DBUSTER_TIER1_MEASURE_KINDS=1' cores -n 6 -- ./build.sh > $S/b/build-clean-$N.log 2>&1) || { echo "build failed"; tail -30 $S/b/build-clean-$N.log; exit 1; }
cp $W/build/compiler $S/b/compiler-clean-$N
cores -n 6 -- $S/m.sh $S/b/compiler-clean-$N $S/b/m-clean-$N
