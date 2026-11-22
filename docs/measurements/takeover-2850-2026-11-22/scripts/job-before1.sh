#!/bin/bash
# The same comparison before the walk (f9f39dbd9): the ordinary compile against the branch it stands on (cbdcbc070) on
# the four workloads, and the machine with no node of the walk's again with what it now keeps beside each tape.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./setup.sh cbdcbc070
./setup.sh f9f39dbd9
sleep 20
for w in sqlite main lua musl; do
    ./pair2.sh cbdcbc070 f9f39dbd9 $w 7 && python3 reduce2.py results/pair2-$w-cbdcbc070-f9f39dbd9 > results/pair2-$w-cbdcbc070-f9f39dbd9/summary.txt
done
./alone-split.sh f9f39dbd9 7
echo job-complete
