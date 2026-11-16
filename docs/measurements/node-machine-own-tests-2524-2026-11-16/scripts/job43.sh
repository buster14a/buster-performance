#!/bin/bash
# job43.sh: the tests in the machine's own form, first build. o1 (main be6515fba with o1.patch) built; the shadow on
# sqlite3.c and Lua seven times and on musl three times, the specs in turn: T, C and X at reader time, the same with the
# census's tests between T and C, and the same with the tests in the machine's own form; then one run of each corpus
# with the own form beside the census's code (--verify), with the default warnings and with every warning.
set -u
cd "$(dirname "$0")"
log=results/job43.log
./build-label.sh o1 be6515fba o1.patch > results/o1-build.out 2>&1 || { echo "o1 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./types-o2.sh -g 1 7 "o1 sweeps --front-sweeps --passes 1" "o1 tests --front-tests --passes 1" "o1 own --front-own-tests --passes 1"
test -s results/o1/types-own-sqlite3-g-7.txt || { echo "types-o2 made no files" >> $log; exit 1; }
echo "types done $(date -u +%T)" >> $log
./types-musl-o.sh -g 3 "o1 sweeps --front-sweeps --passes 1" "o1 tests --front-tests --passes 1" "o1 own --front-own-tests --passes 1" || { echo "musl failed" >> $log; }
./types-o2.sh -wall 1 1 "o1 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o1 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o1 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o1 verifyown --front-own-tests --verify --passes 1"
echo "job43 done $(date -u +%FT%TZ)" >> $log
