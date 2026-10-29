#!/bin/bash
# Builds each mutant at -O1 and runs the transparent unions' test-checker programs and test-checker-driver's socket test.
R=/home/david/.cache/claude-147/mutants3
export CORES_TITLE="#147 transparent unions (mutants)" CORES_LINK="https://github.com/buster14a/buster/issues/147"
unset CPATH C_INCLUDE_PATH
for m in "$@"; do
    d=$(python3 $R/mutate4.py $m) || { echo "$m: mutate failed" >> $R/results4.txt; continue; }
    if ! (cd $d && BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > $R/$m.build.log 2>&1); then echo "$m: build failed" >> $R/results4.txt; continue; fi
    (cd $d && ONLY_TRANSPARENT=1 ./build/compiler test-checker > $R/$m.log 2>&1); a=$?
    (cd $d && ONLY_TRANSPARENT=1 ./build/compiler test-checker-driver --executable ./build/compiler >> $R/$m.log 2>&1); b=$?
    f=$(grep -E "^test-checker: [0-9]+ checks|^checker-driver: [0-9]+ checks" $R/$m.log | tr '\n' ' ')
    if [ $a -ne 0 ] || [ $b -ne 0 ]; then echo "$m: killed (test-checker $a, driver $b) $f" >> $R/results4.txt; else echo "$m: survived $f" >> $R/results4.txt; fi
    rm -rf $d/build
done
echo done >> $R/results4.txt
