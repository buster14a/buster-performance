#!/bin/bash
# job39: build z2 (z1 with the walk's columns by record at reader time), then --front-sweeps against --front-tests on
# sqlite3.c and Lua, seven readings, a profile of each, and musl, three readings.
set -u
cd "$(dirname "$0")"
while systemctl --user is-active -q claude-2524-job37 || systemctl --user is-active -q claude-2524-job38; do sleep 20; done
./build-label.sh z2 be6515fba z2.patch || { echo "job39: build failed"; exit 1; }
./types-o2.sh "" 1 7 "z2 sweeps --front-sweeps" "z2 tests --front-tests"
./tests-profile.sh z2 tests --front-tests
./tests-profile.sh z2 sweeps --front-sweeps
./types-musl-o.sh "" 3 "z2 sweeps --front-sweeps" "z2 tests --front-tests"
echo "job39 done"
