#!/bin/bash
# job2b.sh: job2's runs again after its runners' loop was fixed (they lost their specs after a first run: job2 left one
# reading of musl by each option and nothing else): the shadow's one reading of sqlite3.c and Lua seven times and of musl
# three times by f1 with no option (the walk as it is), --front and --front-first; perf's samples of the --front-first
# and the plain readings of sqlite3.c; and -c sqlite3.c by m9 and f1 as whole processes.
set -u
cd "$(dirname "$0")"
./front-o.sh -a 7 "f1 walk" "f1 after --front" "f1 first --front-first"
echo "front-o done $(date -u +%T)" >> results/job2.log
./front-musl-o.sh -a 3 "f1 walk" "f1 after --front" "f1 first --front-first"
echo "musl done $(date -u +%T)" >> results/job2.log
./perf-front.sh f1 3 first --front-first
./perf-front.sh f1 3 walk
echo "perf done $(date -u +%T)" >> results/job2.log
./ab.sh m9 f1
echo "job2b done $(date -u +%FT%TZ)" >> results/job2.log
