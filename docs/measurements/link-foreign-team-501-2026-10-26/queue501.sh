#!/bin/bash
# queue501.sh [TREE...]: #501's whole run on the 9700X, detached: the builds of the trees named (build501.sh) and the
# 1-worker objects, the lists (lists501.py), then campaign501.sh's 8 passes. Each step's status in queue501.log.
set -u
D=~/buster-fast-bench/perf-501-claude
cd "$D"
./build501.sh "$@"
for t in "$@"; do
    tail -n 20 build501.log | grep -q "build $t status 0" || { echo "build $t failed $(date -Is)" >> queue501.log; exit 1; }
done
ls links1/buster-link-benchmark-*/objects/unit_0.o > /dev/null 2>&1 || { echo "no 1-worker objects $(date -Is)" >> queue501.log; exit 1; }
python3 lists501.py >> queue501.log 2>&1 || { echo "lists failed $(date -Is)" >> queue501.log; exit 1; }
echo "lists $(date -Is)" >> queue501.log
./campaign501.sh 8
echo "done $(date -Is)" >> queue501.log
