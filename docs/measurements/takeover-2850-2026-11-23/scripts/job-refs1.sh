#!/bin/bash
# The references' pass as one descending sweep (a prototype on the fix): build, then paired against the fix.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./exp.sh refs1 55008c81e "$PWD/refs1.patch" Release || exit 1
[[ -x trees/refs1/build/compiler ]] || { echo "no compiler"; exit 1; }
sleep 30
./pair2.sh fix1 refs1 sqlite 7
python3 reduce2.py results/pair2-sqlite-fix1-refs1 > results/pair2-sqlite-fix1-refs1/summary.txt 2>&1
./pair2.sh fix1 refs1 main 5
python3 reduce2.py results/pair2-main-fix1-refs1 > results/pair2-main-fix1-refs1/summary.txt 2>&1
echo job-complete
