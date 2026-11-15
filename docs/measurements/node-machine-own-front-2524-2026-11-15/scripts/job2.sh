#!/bin/bash
# job2.sh: m9 (main 6c59018e) and f1 (it with f1.patch: the machine's own front in the shadow) built; then the shadow's
# one reading of sqlite3.c and Lua seven times and of musl three times by f1 with no option (the walk as it is), --front
# (the front after the walk acted at a chunk) and --front-first (before it); perf's samples of the --front-first and the
# plain readings of sqlite3.c; and -c sqlite3.c by m9 and f1 as whole processes.
set -u
cd "$(dirname "$0")"
./build-label.sh m9 6c59018e4 > results/m9-build.out 2>&1 || { echo "m9 build failed" >> results/job2.log; exit 1; }
./build-label.sh f1 6c59018e4 f1.patch > results/f1-build.out 2>&1 || { echo "f1 build failed" >> results/job2.log; exit 1; }
echo "built $(date -u +%T)" >> results/job2.log
./front-o.sh -a 7 "f1 walk" "f1 after --front" "f1 first --front-first"
echo "front-o done $(date -u +%T)" >> results/job2.log
./front-musl-o.sh -a 3 "f1 walk" "f1 after --front" "f1 first --front-first"
echo "musl done $(date -u +%T)" >> results/job2.log
./perf-front.sh f1 3 first --front-first
./perf-front.sh f1 3 walk
echo "perf done $(date -u +%T)" >> results/job2.log
./ab.sh m9 f1
echo "job2 done $(date -u +%FT%TZ)" >> results/job2.log
