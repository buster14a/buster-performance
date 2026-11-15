#!/bin/bash
# job11.sh: t2 (main 639e730ed with t2.patch: the pull request's sources; t1 with the types' word read as main reads it and
# a type T makes settled where it is made) built; -c sqlite3.c by m11 (main 639e730ed) and t2 as whole processes from
# fresh copies of each executable, twice; the shadow on sqlite3.c and Lua seven times and on musl three times: by t2 with T
# at reader time and the shadow's own sweeps timed in one pass and in seven (the whole front, the lean one, and the front
# before the walk), and by m11 and t2 with no front, for the shadow's own sweeps before and after this change.
set -u
cd "$(dirname "$0")"
./build-label.sh t2 639e730ed t2.patch > results/t2-build.out 2>&1 || { echo "t2 build failed" >> results/job11.log; exit 1; }
echo "built $(date -u +%T)" >> results/job11.log
./ab-copies-n.sh m11 t2 2
echo "ab done $(date -u +%T)" >> results/job11.log
./types-o.sh -l 7 "t2 types1 --front-types --passes 1" "t2 types7 --front-types --passes 7" "t2 leantypes1 --front-lean --front-types --passes 1" "t2 firsttypes1 --front-first --front-types --passes 1" "m11 plain7 --passes 7" "t2 plain7 --passes 7" || { echo "types-o failed" >> results/job11.log; exit 1; }
test -s results/t2/types-plain7-sqlite3-l-7.txt || { echo "types-o made no files" >> results/job11.log; exit 1; }
echo "types-o done $(date -u +%T)" >> results/job11.log
./types-musl-o.sh -l 3 "t2 types1 --front-types --passes 1" "t2 leantypes1 --front-lean --front-types --passes 1" "m11 plain1 --passes 1" "t2 plain1 --passes 1" || { echo "musl failed" >> results/job11.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job11.log
python3 symdiff.py results/m11/compiler results/t2/compiler > results/symbols-m11-t2.txt
echo "job11 done $(date -u +%FT%TZ)" >> results/job11.log
