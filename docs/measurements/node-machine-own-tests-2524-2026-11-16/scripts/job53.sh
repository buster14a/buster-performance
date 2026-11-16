#!/bin/bash
# job53.sh: the tests in the machine's own form, fifth build (o6: a constant operand is a number or a null address, the constants. tests straight, a callee by its type.s word, a leaf by its object.s last answer) and its parts'
# costs (o6x: the same with a temporary knob that switches parts off). The shadow on sqlite3.c and Lua seven times and on
# musl three times: T, C and X; with the census's tests; with the own form. Then o6x's own form with nothing off, the
# leaves' tests off (1), the tree's (2), the operators' (4), the expression's own (8), all four (15), and the pass
# itself too (31).
set -u
cd "$(dirname "$0")"
log=results/job53.log
./build-label.sh o6 be6515fba o6.patch > results/o6-build.out 2>&1 || { echo "o6 build failed" >> $log; exit 1; }
./build-label.sh o6x be6515fba o6x.patch > results/o6x-build.out 2>&1 || { echo "o6x build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
specs=("o6 sweeps --front-sweeps --passes 1" "o6 tests --front-tests --passes 1" "o6 own --front-own-tests --passes 1")
./types-o2.sh -l 1 7 "${specs[@]}"
./types-musl-o.sh -l 3 "${specs[@]}" || { echo "musl failed" >> $log; }
echo "types done $(date -u +%T)" >> $log
./skips.sh o6x 1 7 0 1 2 4 8 15 31 32 64 128 256
echo "skips done $(date -u +%T)" >> $log
./types-o2.sh -wall 1 1 "o6 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o6 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o6 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o6 verifyown --front-own-tests --verify --passes 1"
./own-stat.sh o6 sweeps --front-sweeps --passes 1
./own-stat.sh o6 own --front-own-tests --passes 1
echo "job53 done $(date -u +%FT%TZ)" >> $log
