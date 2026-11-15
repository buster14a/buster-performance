#!/bin/bash
# job5.sh: the record's runs of f4 (the front with its columns staggered, the pull request's sources): the shadow's one
# reading of sqlite3.c and Lua seven times and of musl three times with no option (the walk as it is), --front and
# --front-first; and -c sqlite3.c by m9 (main 6c59018e) and f4 as whole processes, from fresh copies of each executable.
set -u
cd "$(dirname "$0")"
./front-o.sh -r 7 "f4 walk" "f4 after --front" "f4 first --front-first"
echo "front-o done $(date -u +%T)" >> results/job5.log
./front-musl-o.sh -r 3 "f4 walk" "f4 after --front" "f4 first --front-first"
echo "musl done $(date -u +%T)" >> results/job5.log
./ab-copies.sh m9 f4
echo "job5 done $(date -u +%FT%TZ)" >> results/job5.log
