#!/bin/bash
# job-dp3.sh: after job-dp2-inventory (its sanitizer rows): the default path's head built whole again (the attested
# list's fix, build/predefines.h present), the whole inventory against main's baseline, the driver's eight parts, main.c
# compiled by itself, and the no-recursion rule on a Release build.
set -uo pipefail
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
D=/tmp/claude-1000/lazy/dp; B=/tmp/claude-1000/lazy/b3; S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad
L=https://github.com/buster14a/buster/issues/2850
T=$HOME/.cache/claude-2850/wt-regress
until grep -q '^job-complete' $D/job-dp2-inventory.out 2>/dev/null; do sleep 30; done
cd $T && echo "branch at $(git rev-parse --short=9 HEAD)" && rm -f build/oracle-accounting.tsv build/oracle-accounting-x.tsv
[ -f build/predefines.h ] || { echo "no predefines"; exit 1; }
CORES_TITLE="#2850: the default path's head built whole" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "branch build exit $?"
BUSTER_COMPILER="$T/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory on the default path's head" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $D/inventory3-branch.log 2>&1
echo "branch: $(grep -E '^parallel: .* passed' $D/inventory3-branch.log)"
grep -E "^== .*: failed" $D/inventory3-branch.log | sed 's/: failed.*//' | sort > $D/failed3-branch.txt
echo "blocks that fail on the branch and pass on main: $(comm -13 $D/failed-main.txt $D/failed3-branch.txt | wc -l)"
comm -13 $D/failed-main.txt $D/failed3-branch.txt | head -12
echo "blocks that fail on main and pass on the branch: $(comm -23 $D/failed-main.txt $D/failed3-branch.txt | wc -l)"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: the driver's eight parts (the default path's head)" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$S'/blocks-driver8.tests' > $D/driver8.log 2>&1
echo "driver parts: $(grep -E '^parallel: .* passed' $D/driver8.log)"
BUSTER_COMPILER=$T/build/cmake/native/Develop/compiler CORES_TITLE="#2850: main.c compiled by itself (the default path's head)" CORES_LINK=$L cores -n 2 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < '$B'/h2/selfcompile.tests' > $D/selfcompile.log 2>&1
echo "main.c by itself: $(grep -E '^parallel: .* passed' $D/selfcompile.log)"
CORES_TITLE="#2850: Release build of the default path's head for the no-recursion rule" CORES_LINK=$L cores -n 6 -- ./build.sh --config Release --target compiler > build-release.log 2>&1; echo "release build exit $?"
CORES_TITLE="#2850: the no-recursion rule (the default path's head)" CORES_LINK=$L cores -n 6 -- ./build.sh check-call-graph --config Release > build-callgraph.log 2>&1; echo "no-recursion rule exit $?: $(tail -1 build-callgraph.log | cut -c1-160)"
echo job-complete
