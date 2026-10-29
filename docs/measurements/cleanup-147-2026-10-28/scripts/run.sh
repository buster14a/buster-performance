#!/bin/bash
# Each mutant: copy, build at -O1, run the cleanup sections (and the deferred fixtures), record the outcome.
cd /home/david/.cache/claude-147/mutants
for m in "$@"; do
    d=$(python3 mutate.py "$m") || { echo "$m: mutation did not apply" >> results.txt; continue; }
    (cd "$d" && BUSTER_DEBUG_INFO=0 CORES_TITLE="solve 147 mutant $m" cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$m: build failed" >> results.txt; continue; }
    (cd "$d" && ONLY_CLEANUP=1 env -u CPATH ./build/compiler test-checker > test.log 2>&1); checker=$?
    (cd "$d" && ./build/compiler test-checker-deferred > deferred.log 2>&1); deferred=$?
    echo "$m: test-checker=$checker deferred=$deferred $(grep -c 'FAIL\|failed\b' $d/test.log) $(tail -1 $d/test.log)" >> results.txt
    rm -rf "$d/build/c-testsuite" 2>/dev/null
done
echo done >> results.txt
