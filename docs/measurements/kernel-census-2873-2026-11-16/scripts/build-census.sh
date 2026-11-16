#!/bin/bash
# build-census.sh: the census tree, main and scripts/stage-laps.patch (the stage clock's laps as CLOCK_MONOTONIC times),
# one Release build in one hold of the lock.
cd "$(dirname "$0")"
./lock.sh bash -c 'cd census && ./build.sh --config Release' > build-census.log 2>&1
echo "build exit $?" >> build-census.log
sha256sum census/build/compiler >> build-census.log 2>&1
