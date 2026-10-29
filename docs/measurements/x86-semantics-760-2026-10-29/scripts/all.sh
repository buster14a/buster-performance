#!/bin/bash
# The builds, the head's suites, then the measurements: each script takes the lock a few times, a run or a round at a time.
cd "$(dirname "$0")" || exit 1
echo $$ > all.pid
./receipt.sh && ./build.sh && ./receipt.sh && ./tests.sh && ./sem.sh && ./target.sh && ./compile.sh
echo "all done $(date -Is)"
