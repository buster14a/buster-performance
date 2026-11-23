#!/bin/bash
# The same layout with the benchmark in its training (a ceiling, labelled so): paired on sqlite.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
while pgrep -f "[j]ob-bolt1.sh" > /dev/null; do sleep 5; done
./pair2.sh relocs1 bolt2 sqlite 7
python3 reduce2.py results/pair2-sqlite-relocs1-bolt2 > results/pair2-sqlite-relocs1-bolt2/summary.txt 2>&1
echo job-complete
