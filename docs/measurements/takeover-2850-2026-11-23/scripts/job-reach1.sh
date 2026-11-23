#!/bin/bash
# The statements' reach (#3181's walk), two throwaway cuts against main a5e76084: reach1 scans a loop's body for a break
# only where its condition is constantly true; reach2 also asks whether a block's statement completes only when a later
# kept statement needs the answer.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./setup.sh a5e76084
./exp.sh reach1 a5e76084 "$PWD/reach1.patch" Release
./exp.sh reach2 a5e76084 "$PWD/reach2.patch" Release
for c in reach1 reach2; do
    ./pair2.sh a5e760845 $c sqlite 7 && python3 reduce2.py results/pair2-sqlite-a5e760845-$c > results/pair2-sqlite-a5e760845-$c/summary.txt
    cat results/pair2-sqlite-a5e760845-$c/summary.txt
done
for w in main lua musl; do
    ./pair2.sh a5e760845 reach2 $w 5 && python3 reduce2.py results/pair2-$w-a5e760845-reach2 > results/pair2-$w-a5e760845-reach2/summary.txt
    cat results/pair2-$w-a5e760845-reach2/summary.txt
done
echo job-complete
