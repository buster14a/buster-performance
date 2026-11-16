#!/bin/bash
# job51.sh: the tests in the machine's own form, fourth build (o4: the expression's own tests leaner) and its parts'
# costs (o4x: the same with a temporary knob that switches parts off). The shadow on sqlite3.c and Lua seven times and on
# musl three times: T, C and X; with the census's tests; with the own form. Then o4x's own form with nothing off, the
# leaves' tests off (1), the tree's (2), the operators' (4), the expression's own (8), all four (15), and the pass
# itself too (31).
set -u
cd "$(dirname "$0")"
log=results/job51.log
./build-label.sh o4 be6515fba o4.patch > results/o4-build.out 2>&1 || { echo "o4 build failed" >> $log; exit 1; }
./build-label.sh o4x be6515fba o4x.patch > results/o4x-build.out 2>&1 || { echo "o4x build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
specs=("o4 sweeps --front-sweeps --passes 1" "o4 tests --front-tests --passes 1" "o4 own --front-own-tests --passes 1")
./types-o2.sh -j 1 7 "${specs[@]}"
./types-musl-o.sh -j 3 "${specs[@]}" || { echo "musl failed" >> $log; }
echo "types done $(date -u +%T)" >> $log
./skips.sh o4x 1 7 0 1 2 4 8 15 31
echo "skips done $(date -u +%T)" >> $log
./types-o2.sh -wall 1 1 "o4 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o4 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o4 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o4 verifyown --front-own-tests --verify --passes 1"
./own-stat.sh o4 sweeps --front-sweeps --passes 1
./own-stat.sh o4 own --front-own-tests --passes 1
echo "job51 done $(date -u +%FT%TZ)" >> $log
