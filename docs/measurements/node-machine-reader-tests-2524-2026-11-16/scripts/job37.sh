#!/bin/bash
# job37: build z0 (z1 with its caches and gates off: the tests as first written), then --front-sweeps against
# --front-tests on sqlite3.c and Lua, z0 and z1 in turn, seven readings; and musl, three.
set -u
cd "$(dirname "$0")"
./build-label.sh z0 be6515fba z0.patch || { echo "job37: build failed"; exit 1; }
./types-o2.sh "-b" 1 7 "z0 sweeps --front-sweeps" "z0 tests --front-tests" "z1 sweeps --front-sweeps" "z1 tests --front-tests"
./types-musl-o.sh "" 3 "z0 sweeps --front-sweeps" "z0 tests --front-tests" "z1 sweeps --front-sweeps" "z1 tests --front-tests"
echo "job37 done"
