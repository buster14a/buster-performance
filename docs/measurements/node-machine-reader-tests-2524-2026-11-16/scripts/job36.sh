#!/bin/bash
# job36: build z1 (main be6515fba + the tests where they sit, with the caches), then --front-sweeps against --front-tests
# on sqlite3.c and Lua, seven readings in turn.
set -u
cd "$(dirname "$0")"
./build-label.sh z1 be6515fba z1.patch || { echo "job36: build failed"; exit 1; }
./types-o2.sh "" 1 7 "z1 sweeps --front-sweeps" "z1 tests --front-tests"
echo "job36 done"
