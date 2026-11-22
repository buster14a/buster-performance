#!/bin/bash
# The packed comma contexts branch as merged with main 610b32c3e (5647be701), built Release and paired with that main
# on the four workloads.
set -uo pipefail
cd ~/buster-fast-bench/2850-claude-5a14
./setup.sh 610b32c3e
./setup.sh 5647be701
sleep 20
for w in sqlite main musl lua; do
    ./pair2.sh 610b32c3e 5647be701 $w 7 && python3 reduce2.py results/pair2-$w-610b32c3e-5647be701 > results/pair2-$w-610b32c3e-5647be701/summary.txt
done
echo finished
