#!/bin/bash
# job-z3.sh: the size cut's last head in wt-h1 (0f7795acd and a line of the setup's failure path, with the docs): its build,
# the driver's eight parts, the producer's fixtures, main.c by itself, the 34 blocks forced with the gate's log and the
# journal, the journal's replay, and the corpora's objects and the units on a snapshot.
set -uo pipefail
B=/tmp/claude-1000/lazy/b3
S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
L=https://github.com/buster14a/buster/issues/2850
T=$HOME/.cache/claude-2850/wt-h1
N=z3
cd $T
mkdir -p $B/h2/forced-$N
echo "head $(git rev-parse --short=9 HEAD)"
CORES_TITLE="#2850: build the size cut's head" CORES_LINK=$L cores -n 6 -- ./build.sh --config Develop --target compiler > build-develop.log 2>&1
echo "build exit $?"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: the driver's eight parts (the size cut's head)" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$S'/blocks-driver8.tests' > $B/h2/forced-$N/driver8.log 2>&1
echo "driver parts: $(grep -E '^parallel: .* passed' $B/h2/forced-$N/driver8.log)"
CORES_TITLE="#2850: the producer's fixtures (the size cut's head)" CORES_LINK=$L cores -n 1 -- ./build/cmake/native/Develop/compiler test-checker --part 45/64 > $B/h2/forced-$N/part45.txt 2>&1
echo "part 45/64: $(tail -1 $B/h2/forced-$N/part45.txt)"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: main.c compiled by itself (the size cut's head)" CORES_LINK=$L cores -n 2 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$B'/h2/selfcompile.tests' > $B/h2/forced-$N/selfcompile.log 2>&1
echo "main.c by itself: $(grep -E '^parallel: .* passed' $B/h2/forced-$N/selfcompile.log)"
rm -rf $B/snap-$N; mkdir -p $B/snap-$N/build/cmake/native/Develop; cp $T/build/cmake/native/Develop/compiler $B/snap-$N/build/cmake/native/Develop/compiler; cp $T/build/predefines.h $B/snap-$N/build/predefines.h; cp -r $T/src $B/snap-$N/src
cc2=$B/snap-$N/build/cmake/native/Develop/compiler
( CORES_TITLE="#2850: the corpora's objects with and without --node-bodies (the size cut's head)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects.sh "$cc2" $B/h2/objects-$N > $B/h2/objects-$N.log 2>&1; grep "units=" $B/h2/objects-$N.log | awk '{print "plain", $1, $4, $5, $6, $7, $9}' ) &
( for u in units3 units4; do taskset -c 1 python3 $B/loud/run.py "$cc2" $B/loud/$u $B/loud/$N-$u 2>&1 | grep "units; flagged" | cut -c1-40; done ) &
rm -rf $B/h2/kept-$N; mkdir -p $B/h2/kept-$N
BUSTER_TEST_NODE_BODIES_KEEP=$B/h2/kept-$N bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced-$N/all-1.log 1 $B/h2/forced-$N/gate-1.txt
echo "journal: $(ls $B/h2/kept-$N | grep -c '\.command$') commands"
CORES_TITLE="#2850: a replay of the tests' commands with the bodies taken and without (the size cut's head)" CORES_LINK=$L cores -n 6 -- python3 $B/h2/replay.py "$cc2" $B/h2/kept-$N $B/h2/replay-$N > $B/h2/replay-$N.out 2>&1
grep -v "^cores:" $B/h2/replay-$N.out | head -4
wait
echo job-complete
