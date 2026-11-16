#!/bin/bash
# job54.sh: (1) the tests in the machine's own form, seventh build (o7: the constants' tests exact in place, the walk
# only where a parent is read): the shadow on sqlite3.c and Lua seven times and on musl three times, T, C and X; with
# the census's tests; with the own form. (2) Does this session's stack move buster#2871's operators' kernel? p1 is main
# be6515fba with that pull request's head (ce247c7db); p2 is p1 merged with this session's working tree (two hunks of
# c_check_node_census.c resolved, both sides kept). The fact words' harness by both, rounds 1 to 6 in turn: the
# operators' kernel with whole and with lean records, and step 1's kernel.
set -u
cd "$(dirname "$0")"
log=results/job54.log
./build-label.sh o7 be6515fba o7.patch > results/o7-build.out 2>&1 || { echo "o7 build failed" >> $log; exit 1; }
echo "o7 built $(date -u +%T)" >> $log
specs=("o7 sweeps --front-sweeps --passes 1" "o7 tests --front-tests --passes 1" "o7 own --front-own-tests --passes 1")
./types-o2.sh -m 1 7 "${specs[@]}"
./types-musl-o.sh -m 3 "${specs[@]}" || { echo "musl failed" >> $log; }
./types-o2.sh -wall 1 1 "o7 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o7 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o7 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o7 verifyown --front-own-tests --verify --passes 1"
echo "types done $(date -u +%T)" >> $log
./build-label.sh p1 be6515fba p1.patch > results/p1-build.out 2>&1 || { echo "p1 build failed" >> $log; exit 1; }
./build-label.sh p2 be6515fba p2.patch > results/p2-build.out 2>&1 || { echo "p2 build failed" >> $log; exit 1; }
echo "p1 p2 built $(date -u +%T)" >> $log
for n in 1 2 3 4 5 6; do
    for label in p1 p2; do
        RUN=$n ./facts.sh $label "-ops" 1 --facts-operators --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-opslean" 1 --facts-lean --facts-operators --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
done
echo "job54 done $(date -u +%FT%TZ)" >> $log
