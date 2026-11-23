#!/bin/bash
# The history fix on main 55008c81e: build, then paired readings against main on four workloads, then its stage table.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./exp.sh fix1 55008c81e "$PWD/fix-history.patch" Release || exit 1
[[ -x trees/fix1/build/compiler ]] || { echo "no compiler"; exit 1; }
sleep 30
./pair2.sh 55008c81e fix1 sqlite 7
python3 reduce2.py results/pair2-sqlite-55008c81e-fix1 > results/pair2-sqlite-55008c81e-fix1/summary.txt 2>&1
./prof2.sh fix1 fix1
for w in main lua musl; do
    ./pair2.sh 55008c81e fix1 $w 5
    python3 reduce2.py results/pair2-$w-55008c81e-fix1 > results/pair2-$w-55008c81e-fix1/summary.txt 2>&1
done
echo job-complete
