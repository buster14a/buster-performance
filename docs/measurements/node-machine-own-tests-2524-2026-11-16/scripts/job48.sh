#!/bin/bash
# job48.sh: the tests in the machine's own form, second build: one table-driven loop over the records and three lists.
# o2 (main be6515fba with o2.patch) built; the shadow on sqlite3.c and Lua seven times and on musl three times, the
# specs in turn: T, C and X at reader time, the same with the census's tests, and the same with the own form, by o2 and
# (the own form) by o1; the three runs' counts by perf stat; one run of each corpus with the own form beside the
# census's code, with the default warnings and with every warning.
set -u
cd "$(dirname "$0")"
log=results/job48.log
./build-label.sh o2 be6515fba o2.patch > results/o2-build.out 2>&1 || { echo "o2 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
./types-o2.sh -h 1 7 "o2 sweeps --front-sweeps --passes 1" "o2 tests --front-tests --passes 1" "o2 own --front-own-tests --passes 1" "o1 own --front-own-tests --passes 1"
./types-musl-o.sh -h 3 "o2 sweeps --front-sweeps --passes 1" "o2 tests --front-tests --passes 1" "o2 own --front-own-tests --passes 1" "o1 own --front-own-tests --passes 1" || { echo "musl failed" >> $log; }
echo "types done $(date -u +%T)" >> $log
./own-stat.sh o2 sweeps --front-sweeps --passes 1
./own-stat.sh o2 tests --front-tests --passes 1
./own-stat.sh o2 own --front-own-tests --passes 1
./types-o2.sh -wall 1 1 "o2 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o2 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o2 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o2 verifyown --front-own-tests --verify --passes 1"
./own-profile.sh o2 sweeps --front-sweeps --passes 1
./own-profile.sh o2 own --front-own-tests --passes 1
echo "job48 done $(date -u +%FT%TZ)" >> $log
