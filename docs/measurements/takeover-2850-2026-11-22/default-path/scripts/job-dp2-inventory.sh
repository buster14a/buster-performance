#!/bin/bash
# job-dp2-inventory.sh: the whole inventory on the default path's branch at its head (main's own, 96fac43e0, was run by job-dp-inventory.sh); the blocks
# that fail on the branch and pass on main; the inventory again on the branch with BUSTER_TEST_DEFAULT_PATH_LOG set, and
# its counts summed; then the memory and address rows on the 34 blocks.
set -uo pipefail
export PATH="$HOME/dev/scripts:$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
D=/tmp/claude-1000/lazy/dp
S=/tmp/claude-1000/-home-david--config-Claude-scratch-workspaces-ad19dfdf-4593-4773-b5bf-773949ac7131-0e0946eb-e4e5-4f4b-9641-3ee67b4b9cf5-scratch-2026-11-22-3573fe/5a14f8bc-dcd4-4c24-a5d4-eca716965585/scratchpad
L=https://github.com/buster14a/buster/issues/2850
M=$HOME/.cache/claude-2850/wt-alone-faults
T=$HOME/.cache/claude-2850/wt-regress
until grep -q "^nets-complete" $D/job-dp2-nets.out 2>/dev/null; do sleep 30; done
cd $T && echo "branch at $(git rev-parse --short=9 HEAD)" && rm -f build/oracle-accounting.tsv build/oracle-accounting-x.tsv
CORES_TITLE="#2850: the default path's branch built whole" CORES_LINK=$L cores -n 6 -- ./build.sh > build-develop.log 2>&1; echo "branch build exit $?"
BUSTER_COMPILER="$T/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory on the default path's branch" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $D/inventory2-branch.log 2>&1
echo "branch: $(grep -E '^parallel: .* passed' $D/inventory2-branch.log)"
grep -E "^== .*: failed" $D/inventory-main.log | sed 's/: failed.*//' | sort > $D/failed-main.txt
grep -E "^== .*: failed" $D/inventory2-branch.log | sed 's/: failed.*//' | sort > $D/failed2-branch.txt
echo "blocks that fail on the branch and pass on main: $(comm -13 $D/failed-main.txt $D/failed2-branch.txt | wc -l)"
comm -13 $D/failed-main.txt $D/failed2-branch.txt | head -12
echo "blocks that fail on main and pass on the branch: $(comm -23 $D/failed-main.txt $D/failed2-branch.txt | wc -l)"
rm -f build/oracle-accounting.tsv build/oracle-accounting-x.tsv $D/inventory2-check.log
BUSTER_TEST_DEFAULT_PATH_LOG=$D/inventory2-check.log BUSTER_COMPILER="$T/build/cmake/native/Develop/compiler" CORES_TITLE="#2850: the whole inventory with the default path's rules checked against the long way" CORES_LINK=$L cores -n 6 -- bash -c '"$BUSTER_COMPILER" parallel --jobs "$CORES" < tools/ci/correctness.tests' > $D/inventory2-checked.log 2>&1
echo "checked: $(grep -E '^parallel: .* passed' $D/inventory2-checked.log)"
grep -E "^== .*: failed" $D/inventory2-checked.log | sed 's/: failed.*//' | sort > $D/failed2-checked.txt
echo "blocks that fail checked and pass on main: $(comm -13 $D/failed-main.txt $D/failed2-checked.txt | wc -l)"
comm -13 $D/failed-main.txt $D/failed2-checked.txt | head -12
python3 - $D/inventory2-check.log <<'PY'
import re, sys
names = None; sums = None; lines = 0
for line in open(sys.argv[1], errors='replace'):
    m = re.findall(r"([a-z'-]+)=(\d+)", line)
    if not line.startswith('default-path:') or not m: continue
    lines += 1
    if sums is None: names = [k for k, _ in m]; sums = [0] * len(m)
    for i, (_, v) in enumerate(m[:len(sums)]): sums[i] += int(v)
print(f"check: commands={lines} " + (' '.join(f"{n}={v}" for n, v in zip(names, sums)) if sums else "no line"))
PY
echo inventory-complete
bash $S/sanitize.sh $T $S/blocks-boundary.tests memory address > $D/san2.out 2>&1
grep -v "^cores:" $D/san2.out | tail -8
echo job-complete
