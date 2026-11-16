#!/bin/bash
# job52.sh: the tests in the machine's own form, fifth build (o5: a constant operand is a number or a null address, the constants. tests straight, a callee by its type.s word, a leaf by its object.s last answer) and its parts'
# costs (o5x: the same with a temporary knob that switches parts off). The shadow on sqlite3.c and Lua seven times and on
# musl three times: T, C and X; with the census's tests; with the own form. Then o5x's own form with nothing off, the
# leaves' tests off (1), the tree's (2), the operators' (4), the expression's own (8), all four (15), and the pass
# itself too (31).
set -u
cd "$(dirname "$0")"
log=results/job52.log
./build-label.sh o5 be6515fba o5.patch > results/o5-build.out 2>&1 || { echo "o5 build failed" >> $log; exit 1; }
./build-label.sh o5x be6515fba o5x.patch > results/o5x-build.out 2>&1 || { echo "o5x build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
specs=("o5 sweeps --front-sweeps --passes 1" "o5 tests --front-tests --passes 1" "o5 own --front-own-tests --passes 1")
./types-o2.sh -k 1 7 "${specs[@]}"
./types-musl-o.sh -k 3 "${specs[@]}" || { echo "musl failed" >> $log; }
echo "types done $(date -u +%T)" >> $log
./skips.sh o5x 1 7 0 1 2 4 8 15 31
echo "skips done $(date -u +%T)" >> $log
./types-o2.sh -wall 1 1 "o5 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o5 verifyown --front-own-tests --verify --passes 1"
./types-musl-o.sh -wall 1 "o5 wallown --front-own-tests --verify --passes 1 -Wall -Wextra" "o5 verifyown --front-own-tests --verify --passes 1"
./own-stat.sh o5 sweeps --front-sweeps --passes 1
./own-stat.sh o5 own --front-own-tests --passes 1
echo "job52 done $(date -u +%FT%TZ)" >> $log
