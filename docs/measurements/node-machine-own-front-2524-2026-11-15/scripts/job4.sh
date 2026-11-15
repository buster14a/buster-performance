#!/bin/bash
# job4.sh: f3 (f2 with the front's columns staggered) and f4 (f1 with them staggered: no cursor, no parents read up
# front) built; the shadow's one reading of sqlite3.c and Lua five times by f1, f3 and f4 in turn with --front-first and
# with --front; and f3's and f4's --front-first readings' events by symbol.
set -u
cd "$(dirname "$0")"
./build-label.sh f3 6c59018e4 f3.patch > results/f3-build.out 2>&1 || { echo "f3 build failed" >> results/job4.log; exit 1; }
./build-label.sh f4 6c59018e4 f4.patch > results/f4-build.out 2>&1 || { echo "f4 build failed" >> results/job4.log; exit 1; }
echo "built $(date -u +%T)" >> results/job4.log
./front-o.sh -f34 5 "f1 first --front-first" "f3 first --front-first" "f4 first --front-first" "f1 after --front" "f3 after --front" "f4 after --front"
./perf-events.sh f3 first --front-first
./perf-events.sh f4 first --front-first
echo "job4 done $(date -u +%FT%TZ)" >> results/job4.log
