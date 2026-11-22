#!/bin/bash
# A body's entries from its controls and its tapes (eec7ca784): the ordinary compile against the branch it stands on
# (0dd1dfafa) on the four workloads: nothing else moves.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh 0dd1dfafa
./setup.sh eec7ca784
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh 0dd1dfafa eec7ca784 $w 7 && python3 reduce2.py results/pair2-$w-0dd1dfafa-eec7ca784 > results/pair2-$w-0dd1dfafa-eec7ca784/summary.txt
done
echo job-complete
