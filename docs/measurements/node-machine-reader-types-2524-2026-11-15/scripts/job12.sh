#!/bin/bash
# job12.sh: t3 (main 639e730ed with t3.patch: the pull request's sources; t2 with the three program-or-reader helpers inline; t2 is t1 with the types' word read as main reads it and
# a type T makes settled where it is made) built; -c sqlite3.c by m11 (main 639e730ed) and t3 as whole processes from
# fresh copies of each executable, twice; the shadow on sqlite3.c and Lua seven times and on musl three times: by t3 with T
# at reader time and the shadow's own sweeps timed in one pass and in seven (the whole front, the lean one, and the front
# before the walk), and by m11 and t3 with no front, for the shadow's own sweeps before and after this change.
set -u
cd "$(dirname "$0")"
./build-label.sh t3 639e730ed t3.patch > results/t3-build.out 2>&1 || { echo "t3 build failed" >> results/job12.log; exit 1; }
echo "built $(date -u +%T)" >> results/job12.log
./ab-copies-n.sh m11 t3 2
echo "ab done $(date -u +%T)" >> results/job12.log
./types-o.sh -m 7 "t3 types1 --front-types --passes 1" "t3 types7 --front-types --passes 7" "t3 leantypes1 --front-lean --front-types --passes 1" "t3 firsttypes1 --front-first --front-types --passes 1" "m11 plain7 --passes 7" "t3 plain7 --passes 7" || { echo "types-o failed" >> results/job12.log; exit 1; }
test -s results/t3/types-plain7-sqlite3-m-7.txt || { echo "types-o made no files" >> results/job12.log; exit 1; }
echo "types-o done $(date -u +%T)" >> results/job12.log
./types-musl-o.sh -m 3 "t3 types1 --front-types --passes 1" "t3 leantypes1 --front-lean --front-types --passes 1" "m11 plain1 --passes 1" "t3 plain1 --passes 1" || { echo "musl failed" >> results/job12.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job12.log
python3 symdiff.py results/m11/compiler results/t3/compiler > results/symbols-m11-t3.txt
echo "job12 done $(date -u +%FT%TZ)" >> results/job12.log
