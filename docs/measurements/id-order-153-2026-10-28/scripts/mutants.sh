#!/bin/bash
# Build each mutant tree at -O1, then run the checks that must catch it.
for m in 1 2; do
    cd ~/.cache/claude-153/tree-mut$m || exit 1
    BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1; echo "mutant $m build $?"
    ./build/compiler test-check-lanes > lanes.log 2>&1; echo "mutant $m test-check-lanes exit $?: $(tail -1 lanes.log)"
    grep -m3 "FAIL\|failed\|differ" lanes.log | head -3
    env -u CPATH -u C_INCLUDE_PATH ./build/compiler test-c-testsuite --jobs 4 --subset tests/c-testsuite/subset.txt ~/.cache/claude-aligned-136/c-testsuite > ct.log 2>&1; echo "mutant $m test-c-testsuite exit $?: $(grep 'test-c-testsuite:' ct.log | tail -1)"
    ./build/compiler test-checker-deferred > deferred.log 2>&1; echo "mutant $m test-checker-deferred exit $?: $(tail -1 deferred.log)"
done
