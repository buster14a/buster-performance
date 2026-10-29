#!/bin/bash
# The head's and nosub's builds (main's is built), the head's suites, then the measurements: each script takes the
# lock a few times, a run or a round at a time.
cd "$(dirname "$0")" || exit 1
echo $$ > all.pid
./build2.sh && ./tests.sh && ./variants.sh && ./sem.sh && ./backend.sh && ./compile.sh && ./speedtest.sh
echo "all done $(date -Is)"
