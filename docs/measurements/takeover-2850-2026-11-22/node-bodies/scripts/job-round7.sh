#!/bin/bash
# job-round7.sh: half 2 at 4fcadeb45 (main's head merged in, #3365 and #3366 among it): its build, its tests, its nets,
# and the memory and address rows with the option forced.
set -uo pipefail
B=/tmp/claude-1000/lazy/b3
S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
L=https://github.com/buster14a/buster/issues/2850
T=$HOME/.cache/claude-2850/wt-h2
cd $T
CORES_TITLE="buster #2850: build the compile that takes bodies on main's head" CORES_LINK=$L cores -n 6 -- ./build.sh --config Develop --target compiler > build-develop.log 2>&1
echo "build exit $?: $(git rev-parse --short=9 HEAD)"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="buster #2850: the driver's eight parts" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$S'/blocks-driver8.tests' > $B/h2/forced9/driver8.log 2>&1
echo "driver parts: $(grep -E '^parallel: .* passed' $B/h2/forced9/driver8.log)"
CORES_TITLE="buster #2850: the producer's fixtures" CORES_LINK=$L cores -n 1 -- ./build/cmake/native/Develop/compiler test-checker --part 45/64 > $B/h2/forced9/part45.txt 2>&1
echo "part 45/64: $(tail -1 $B/h2/forced9/part45.txt)"
cp $T/build/cmake/native/Develop/compiler $B/snap-y2/build/cmake/native/Develop/compiler; cp $T/build/predefines.h $B/snap-y2/build/predefines.h; cp -r $T/src $B/snap-y2/src
cc2=$B/snap-y2/build/cmake/native/Develop/compiler
( CORES_TITLE="#2850: the corpora's objects with and without --node-bodies" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc2" $B/h2/objects-y2 > $B/h2/objects-y2.log 2>&1; echo "corpus-objects exit $?" ) &
( CORES_TITLE="#2850: the corpora's objects with and without --node-bodies, -fPIC" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc2" $B/h2/objects-y2-pic -fPIC > $B/h2/objects-y2-pic.log 2>&1; echo "corpus-objects -fPIC exit $?" ) &
( CORES_TITLE="#2850: the producer on the corpora against the oracle" CORES_LINK=$L cores -n 1 -- bash /tmp/claude-1000/lazy/b2/produce.sh "$cc2" $B/produce-y2/full-default --produce > $B/produce-y2.out 2>&1; echo "oracle: $(grep -c ' exit 0' $B/produce-y2.out) of 4 status 0" ) &
( for u in units3 units4; do taskset -c 1 python3 $B/loud/run.py "$cc2" $B/loud/$u $B/loud/final-$u 2>&1 | grep "units; flagged" | cut -c1-40; done ) &
BUSTER_TEST_NODE_BODIES_KEEP=$B/h2/kept-y2 bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced9/all-1.log 1 $B/h2/forced9/gate-1.txt
bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced9/all-2-0.log 2:0
bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced9/all-2-1.log 2:1
echo "journal: $(ls $B/h2/kept-y2 | grep -c '\.command$') commands"
CORES_TITLE="#2850: a replay of the tests' commands with the bodies taken and without, objects compared" CORES_LINK=$L cores -n 6 -- python3 $B/h2/replay.py "$cc2" $B/h2/kept-y2 $B/h2/replay-y2 > $B/h2/replay-y2.out 2>&1
grep -v "^cores:" $B/h2/replay-y2.out | head -3
CORES_TITLE="#2850: units under each option set with and without --node-bodies" CORES_LINK=$L cores -n 6 -- bash $B/h2/sweep.sh "$cc2" $B/h2/sweep-7 > $B/h2/sweep-7.out 2>&1
grep -v "^cores:" $B/h2/sweep-7.out | head -2
wait
echo nets-complete
BUSTER_TEST_NODE_BODIES=1 bash $S/sanitize.sh $T $S/blocks-boundary.tests memory address > $B/h2/san-forced.out 2>&1
grep -v "^cores:" $B/h2/san-forced.out | tail -8
export CORES_TITLE="#2850: the sanitizer rows on the corpora with --node-bodies forced" CORES_LINK=$L
for san in memory address; do cores -n 1 -- bash $S/corpus-san-bodies.sh $T $san 2>&1 | tail -3; done
echo job-complete
