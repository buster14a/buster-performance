#!/bin/bash
# The machine with no node of the walk's (8f8fe98cd): its shadow's readings again at the branch's head, and the
# ordinary compile against main's (0a408b6a3) on the four workloads: nothing else moves.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 0a408b6a3
./setup.sh 8f8fe98cd
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh 0a408b6a3 8f8fe98cd $w 7 && python3 reduce2.py results/pair2-$w-0a408b6a3-8f8fe98cd > results/pair2-$w-0a408b6a3-8f8fe98cd/summary.txt
done
./alone.sh 8f8fe98cd 7
echo job-complete
