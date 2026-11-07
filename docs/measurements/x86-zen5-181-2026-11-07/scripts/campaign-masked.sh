#!/bin/bash
# Build the work tree, then measure the rows still unmeasured (#181); each run takes the lock itself.
cd ~/buster-fast-bench/181-claude || exit 1
./build.sh
grep -q "^build exit 0" build.log || exit 1
./measure.sh missing --missing --table
