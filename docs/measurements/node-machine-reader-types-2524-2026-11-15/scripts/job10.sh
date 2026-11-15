#!/bin/bash
# job10.sh: m11 (main 639e730ed, #2861 merged) and t1 (it with t1.patch: T at reader time on the front's expressions,
# measure-node-machine --shadow --front-types) built; -c sqlite3.c by m11 and t1 as whole processes from fresh copies of
# each executable, twice; the shadow on sqlite3.c and Lua seven times and on musl three times: by t1 with T at reader
# time and the shadow's own sweeps timed in one pass and in seven (the whole front, the lean one, and the front before
# the walk), and by m11 and t1 with no front and seven passes, for the shadow's own T before and after this change.
set -u
cd "$(dirname "$0")"
./build-label.sh m11 639e730ed > results/m11-build.out 2>&1 || { echo "m11 build failed" >> results/job10.log; exit 1; }
./build-label.sh t1 639e730ed t1.patch > results/t1-build.out 2>&1 || { echo "t1 build failed" >> results/job10.log; exit 1; }
echo "built $(date -u +%T)" >> results/job10.log
./ab-copies-n.sh m11 t1 2
echo "ab done $(date -u +%T)" >> results/job10.log
./types-o.sh -k 7 "t1 types1 --front-types --passes 1" "t1 types7 --front-types --passes 7" "t1 leantypes1 --front-lean --front-types --passes 1" "t1 firsttypes1 --front-first --front-types --passes 1" "m11 plain7 --passes 7" "t1 plain7 --passes 7" || { echo "types-o failed" >> results/job10.log; exit 1; }
test -s results/t1/types-plain7-sqlite3-k-7.txt || { echo "types-o made no files" >> results/job10.log; exit 1; }
echo "types-o done $(date -u +%T)" >> results/job10.log
./types-musl-o.sh -k 3 "t1 types1 --front-types --passes 1" "t1 leantypes1 --front-lean --front-types --passes 1" "m11 plain1 --passes 1" "t1 plain1 --passes 1" || { echo "musl failed" >> results/job10.log; exit 1; }
echo "musl done $(date -u +%T)" >> results/job10.log
echo "job10 done $(date -u +%FT%TZ)" >> results/job10.log
