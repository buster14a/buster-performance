#!/bin/bash
# #1939 A/B: Tier 1 -c of sqlite3.c by base (cb608c1) and head (dd4ec47), one lock hold.
cd ~/buster-fast-bench/1879-claude
IN=~/buster-fast-bench/refine-claude/inputs/sqlite3.c
./head -c --tier1 -o head.o $IN > check-head.log 2>&1; echo "head exit $?" > ab.log
./base -c --tier1 -o base.o $IN > check-base.log 2>&1; echo "base exit $?" >> ab.log
taskset -c 2 ./base time-runs --runs 7 --warmups 1 --directory . --build base ./base --build head ./head --list -c --tier1 -o out.o $IN >> ab.log 2>&1
echo DONE >> ab.log
