#!/bin/bash
# job-baseline.sh: the whole inventory on main's own build and on half 2's head, on this machine: the blocks that fail
# on the branch and pass on main are the branch's to fix; the rest are this machine's.
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
B=/tmp/claude-1000/lazy/b3
L=https://github.com/buster14a/buster/issues/2850
M=$HOME/.cache/claude-2850/wt-alone-faults
T=$HOME/.cache/claude-2850/wt-h2
cd $M && git fetch -q origin && git checkout -q --detach origin/main && echo "main at $(git rev-parse --short=9 HEAD)"
CORES_TITLE="#2850: main's own build, for the inventory's baseline on this machine" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "main build exit $?"
[ -f build/predefines.h ] || clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
BUSTER_COMPILER="$M/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory on main's build (baseline)" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $B/h2/inventory-main.log 2>&1
echo "main: $(grep -E '^parallel: .* passed' $B/h2/inventory-main.log)"
cd $T
CORES_TITLE="#2850: build half 2 whole" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "branch build exit $?"
BUSTER_COMPILER="$T/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory on half 2's head" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $B/h2/inventory-branch.log 2>&1
echo "branch: $(grep -E '^parallel: .* passed' $B/h2/inventory-branch.log)"
grep -E "^== .*: failed" $B/h2/inventory-main.log | sed 's/: failed.*//' | sort > $B/h2/failed-main.txt
grep -E "^== .*: failed" $B/h2/inventory-branch.log | sed 's/: failed.*//' | sort > $B/h2/failed-branch.txt
echo "blocks that fail on the branch and pass on main: $(comm -13 $B/h2/failed-main.txt $B/h2/failed-branch.txt | wc -l)"
comm -13 $B/h2/failed-main.txt $B/h2/failed-branch.txt | head -12
echo "blocks that fail on main and pass on the branch: $(comm -23 $B/h2/failed-main.txt $B/h2/failed-branch.txt | wc -l)"
echo job-complete
