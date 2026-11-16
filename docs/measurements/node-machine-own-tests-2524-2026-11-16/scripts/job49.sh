#!/bin/bash
# job49.sh: the tests in the machine's own form, third build: the operators' and the leaves' tests leaner, and an order
# with the tests after C and X. o3 (main be6515fba with o3.patch) built; the shadow on sqlite3.c and Lua seven times and
# on musl three times, the specs in turn: T, C and X at reader time; with the census's tests between T and C, and
# after X; with the own form between, and after; then counts and profiles of the own form's two orders.
set -u
cd "$(dirname "$0")"
log=results/job49.log
./build-label.sh o3 be6515fba o3.patch > results/o3-build.out 2>&1 || { echo "o3 build failed" >> $log; exit 1; }
echo "built $(date -u +%T)" >> $log
specs=("o3 sweeps --front-sweeps --passes 1" "o3 tests --front-tests --passes 1" "o3 testslast --front-tests --front-tests-last --passes 1" "o3 own --front-own-tests --passes 1" "o3 ownlast --front-own-tests --front-tests-last --passes 1")
./types-o2.sh -i 1 7 "${specs[@]}"
./types-musl-o.sh -i 3 "${specs[@]}" || { echo "musl failed" >> $log; }
echo "types done $(date -u +%T)" >> $log
./own-stat.sh o3 sweeps --front-sweeps --passes 1
./own-stat.sh o3 own --front-own-tests --passes 1
./own-stat.sh o3 ownlast --front-own-tests --front-tests-last --passes 1
./own-profile.sh o3 sweeps --front-sweeps --passes 1
./own-profile.sh o3 own --front-own-tests --passes 1
./own-profile.sh o3 ownlast --front-own-tests --front-tests-last --passes 1
echo "job49 done $(date -u +%FT%TZ)" >> $log
