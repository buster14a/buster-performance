#!/bin/bash
# job13.sh: t4 (main 639e730ed with t4.patch: the pull request's sources; t3 with the pointer type's making out of line, so
# that node_machine_pointer is inlined as on main; t3 is t2 with three helpers inline, t2 is t1 with the types' word read
# as main reads it and a type T makes settled where it is made) built; -c sqlite3.c by m11 (main 639e730ed) and t4 as whole processes from
# fresh copies of each executable, twice; the shadow on sqlite3.c and Lua seven times and on musl three times: by t4 with T
# at reader time and the shadow's own sweeps timed in one pass and in seven (the whole front, the lean one, and the front
# before the walk), and by m11 and t4 with no front, for the shadow's own sweeps before and after this change.
set -u
cd "$(dirname "$0")"
./build-label.sh t4 639e730ed t4.patch > results/t4-build.out 2>&1 || { echo "t4 build failed" >> results/job13.log; exit 1; }
echo "built $(date -u +%T)" >> results/job13.log
./ab-copies-n.sh m11 t4 2
echo "ab done $(date -u +%T)" >> results/job13.log
./types-o.sh -n 7 "t4 types1 --front-types --passes 1" "t4 types7 --front-types --passes 7" "t4 leantypes1 --front-lean --front-types --passes 1" "t4 firsttypes1 --front-first --front-types --passes 1" "m11 plain7 --passes 7" "t4 plain7 --passes 7" || { echo "types-o failed" >> results/job13.log; exit 1; }
test -s results/t4/types-plain7-sqlite3-n-7.txt || { echo "types-o made no files" >> results/job13.log; exit 1; }
echo "types-o done $(date -u +%T)" >> results/job13.log
./types-musl-o.sh -n 3 "t4 types1 --front-types --passes 1" "t4 leantypes1 --front-lean --front-types --passes 1" "m11 plain1 --passes 1" "t4 plain1 --passes 1" || { echo "musl failed" >> results/job13.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job13.log
python3 symdiff.py results/m11/compiler results/t4/compiler > results/symbols-m11-t4.txt
echo "job13 done $(date -u +%FT%TZ)" >> results/job13.log
