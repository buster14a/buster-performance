#!/bin/bash
# chain594e.sh: the confirmation's three passes, benchmark-link's link-foreign rows by the head and by main, and the
# outputs' identities (the head's remaining tests ran on the laptop instead, the lock being crowded).
set -u
D=~/buster-fast-bench/perf-594-claude
cd "$D"
echo $$ > chain594e.pid
./confirm594.sh 3 > confirm594.out 2>&1
sleep 20
./linkbench594.sh v1 1
sleep 20
./linkbench594.sh v0 1
./outputs594.sh > outputs594.txt 2>&1
echo "outputs $? $(date -Is)" >> confirm594.log
