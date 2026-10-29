#!/bin/bash
# Each mutant of PR 2: copy, build at -O1, run the attribute sources and selection sections, then the symbol driver test.
cd /home/david/.cache/claude-147/mutants2
for m in "$@"; do
    d=$(python3 mutate2b.py "$m") || { echo "$m: mutation did not apply" >> results.txt; continue; }
    (cd "$d" && BUSTER_DEBUG_INFO=0 CORES_TITLE="solve 147 mutant $m" cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$m: build failed" >> results.txt; continue; }
    (cd "$d" && ONLY_SYMBOLS=1 env -u CPATH ./build/compiler test-checker > test.log 2>&1); checker=$?
    (cd "$d" && ONLY_SYMBOLS=1 env -u CPATH ./build/compiler test-checker-driver --executable ./build/compiler > driver.log 2>&1); driver=$?
    echo "$m: test-checker=$checker driver=$driver $(tail -1 $d/test.log) / $(tail -1 $d/driver.log)" >> results.txt
done
echo done >> results.txt
