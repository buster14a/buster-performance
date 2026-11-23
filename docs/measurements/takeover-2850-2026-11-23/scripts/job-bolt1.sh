#!/bin/bash
# The relinked fix against its BOLT layout (trained on main, lua and musl): paired readings on four workloads.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
for w in sqlite main lua musl; do
    r=5; [[ $w = sqlite ]] && r=7
    ./pair2.sh relocs1 bolt1 $w $r
    python3 reduce2.py results/pair2-$w-relocs1-bolt1 > results/pair2-$w-relocs1-bolt1/summary.txt 2>&1
done
echo job-complete
