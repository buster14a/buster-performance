#!/bin/bash
# job-z2.sh: the size cut at its head in wt-h1: the driver's eight parts, the producer's fixtures, main.c by itself; the
# nets on a snapshot (oracle, the corpora's objects four ways and by halves, the units, the sweep); the 34 blocks forced
# (every body, each half) with the gate's log and the journal, and its replay; the no-recursion rule on a Release build;
# the inventory against main's baseline; the memory and address rows forced and the sanitized corpora.
set -uo pipefail
B=/tmp/claude-1000/lazy/b3
S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
L=https://github.com/buster14a/buster/issues/2850
T=$HOME/.cache/claude-2850/wt-h1
N=z2
cd $T
mkdir -p $B/h2/forced-$N
echo "head $(git rev-parse --short=9 HEAD)"
CORES_TITLE="#2850: build the size cut" CORES_LINK=$L cores -n 6 -- ./build.sh --config Develop --target compiler > build-develop.log 2>&1
echo "build exit $?"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: the driver's eight parts (the size cut)" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$S'/blocks-driver8.tests' > $B/h2/forced-$N/driver8.log 2>&1
echo "driver parts: $(grep -E '^parallel: .* passed' $B/h2/forced-$N/driver8.log)"
CORES_TITLE="#2850: the producer's fixtures (the size cut)" CORES_LINK=$L cores -n 1 -- ./build/cmake/native/Develop/compiler test-checker --part 45/64 > $B/h2/forced-$N/part45.txt 2>&1
echo "part 45/64: $(tail -1 $B/h2/forced-$N/part45.txt)"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: main.c compiled by itself (the size cut)" CORES_LINK=$L cores -n 2 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$B'/h2/selfcompile.tests' > $B/h2/forced-$N/selfcompile.log 2>&1
echo "main.c by itself: $(grep -E '^parallel: .* passed' $B/h2/forced-$N/selfcompile.log)"
rm -rf $B/snap-$N; mkdir -p $B/snap-$N/build/cmake/native/Develop; cp $T/build/cmake/native/Develop/compiler $B/snap-$N/build/cmake/native/Develop/compiler; cp $T/build/predefines.h $B/snap-$N/build/predefines.h; cp -r $T/src $B/snap-$N/src
cc2=$B/snap-$N/build/cmake/native/Develop/compiler
( bash $B/job-z1-nets.sh $N > $B/job-$N-nets.out 2>&1; grep -v '^cores:' $B/job-$N-nets.out ) &
( SELECT=2:0 CORES_TITLE="#2850: the corpora's objects with half of the producer's bodies taken (2:0)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects-select.sh "$cc2" $B/h2/objects-$N-20 > $B/h2/objects-$N-20.log 2>&1; grep "units=" $B/h2/objects-$N-20.log | awk '{print "half 2:0", $1, $4, $5, $6, $7, $9}' ) &
( SELECT=2:1 CORES_TITLE="#2850: the corpora's objects with half of the producer's bodies taken (2:1)" CORES_LINK=$L cores -n 1 -- bash $B/h2/corpus-objects-select.sh "$cc2" $B/h2/objects-$N-21 > $B/h2/objects-$N-21.log 2>&1; grep "units=" $B/h2/objects-$N-21.log | awk '{print "half 2:1", $1, $4, $5, $6, $7, $9}' ) &
wait
rm -rf $B/h2/kept-$N
BUSTER_TEST_NODE_BODIES_KEEP=$B/h2/kept-$N bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced-$N/all-1.log 1 $B/h2/forced-$N/gate-1.txt
bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced-$N/all-2-0.log 2:0
bash $S/forced.sh $T $S/blocks-boundary.tests $B/h2/forced-$N/all-2-1.log 2:1
echo "journal: $(ls $B/h2/kept-$N | grep -c '\.command$') commands"
CORES_TITLE="#2850: a replay of the tests' commands with the bodies taken and without (the size cut)" CORES_LINK=$L cores -n 6 -- python3 $B/h2/replay.py "$cc2" $B/h2/kept-$N $B/h2/replay-$N > $B/h2/replay-$N.out 2>&1
grep -v "^cores:" $B/h2/replay-$N.out | head -3
echo nets-complete
rm -f build/oracle-accounting.tsv build/oracle-accounting-x.tsv
CORES_TITLE="#2850: build the size cut whole" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "whole build exit $?"
BUSTER_COMPILER="$T/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory on the size cut's head" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $B/h2/inventory-$N.log 2>&1
echo "inventory: $(grep -E '^parallel: .* passed' $B/h2/inventory-$N.log)"
grep -E "^== .*: failed" $B/h2/inventory-$N.log | sed 's/: failed.*//' | sort > $B/h2/failed-$N.txt
echo "blocks that fail on the branch and pass on main's build: $(comm -13 $B/h2/failed-main.txt $B/h2/failed-$N.txt | wc -l)"
comm -13 $B/h2/failed-main.txt $B/h2/failed-$N.txt | head -12
CORES_TITLE="#2850: Release build of the size cut for the no-recursion rule" CORES_LINK=$L cores -n 6 -- ./build.sh --config Release --target compiler > build-release.log 2>&1; echo "release build exit $?"
CORES_TITLE="#2850: the no-recursion rule (the size cut)" CORES_LINK=$L cores -n 6 -- ./build.sh check-call-graph --config Release > build-callgraph.log 2>&1; echo "no-recursion rule exit $?: $(tail -1 build-callgraph.log | cut -c1-160)"
echo gates-complete
BUSTER_TEST_NODE_BODIES=1 bash $S/sanitize.sh $T $S/blocks-boundary.tests memory address > $B/h2/san-forced-$N.out 2>&1
grep -v "^cores:" $B/h2/san-forced-$N.out | tail -8
export CORES_TITLE="#2850: the sanitizer rows on the corpora with --node-bodies forced (the size cut)" CORES_LINK=$L
for san in memory address; do cores -n 1 -- bash $S/corpus-san-bodies.sh $T $san 2>&1 | tail -3; done
echo job-complete
