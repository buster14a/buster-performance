#!/bin/bash
# The producer's setup as mask scans (setup1.patch on main da652ae8), --node-bodies in both arms.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./exp.sh setup1 da652ae8 "$PWD/setup1.patch" Release
for w in sqlite lua musl main; do
    rounds=5
    [[ $w == sqlite ]] && rounds=7
    PARENT_EXTRA=--node-bodies ./pair2.sh da652ae8d setup1 $w $rounds --node-bodies && python3 reduce2.py results/pair2-$w-da652ae8d-setup1-__node_bodies > results/pair2-$w-da652ae8d-setup1-__node_bodies/summary.txt
    cat results/pair2-$w-da652ae8d-setup1-__node_bodies/summary.txt
done
echo job-complete
