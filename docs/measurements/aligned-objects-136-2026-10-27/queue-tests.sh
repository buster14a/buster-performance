#!/usr/bin/env bash
# The affected tests' times, main2 against merged: two rounds of each test, each test's pair of runs (the trees' order
# alternating by round) under one hold of the lock (time-test.sh). Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): the tests' times" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
for round in 1 2; do
    if [ $((round % 2)) -eq 1 ]; then order="main2 merged"; else order="merged main2"; fi
    "$lock" ./time-test.sh "$round" tier0 "$order" test-tier0
    "$lock" ./time-test.sh "$round" tier0-cross "$order" test-tier0 --cross-check
    "$lock" ./time-test.sh "$round" unwind-cross "$order" test-unwind --cross-check
    "$lock" ./time-test.sh "$round" check-debug-cross "$order" test-check-debug --cross-check
    "$lock" ./time-test.sh "$round" calling-convention-cross "$order" test-calling-convention --cross-check
    "$lock" ./time-test.sh "$round" checker "$order" test-checker --seed 133
    echo "round $round ($order) $(date -Is)" >> queue-tests.log
done
echo "done $(date -Is)" >> queue-tests.log
