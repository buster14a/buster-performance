#!/bin/bash
# Builds each mutant at -O1 and runs the local labels' and __auto_type's test-checker sections and driver test.
R=/home/david/.cache/claude-147/mutants5
export CORES_TITLE="#147 local labels, __auto_type (mutants)" CORES_LINK="https://github.com/buster14a/buster/issues/147"
unset CPATH C_INCLUDE_PATH
for m in "$@"; do
    d=$(python3 $R/mutate5.py $m) || { echo "$m: mutate failed" >> $R/results.txt; continue; }
    if ! (cd $d && BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > $R/$m.build.log 2>&1); then echo "$m: build failed" >> $R/results.txt; continue; fi
    (cd $d && ONLY_GNU=1 ./build/compiler test-checker > $R/$m.log 2>&1); a=$?
    (cd $d && ONLY_GNU=1 ./build/compiler test-checker-driver --executable ./build/compiler >> $R/$m.log 2>&1); b=$?
    f=$(grep -E "^test-checker: [0-9]+ checks|^checker-driver: [0-9]+ checks" $R/$m.log | tr '\n' ' ')
    if [ $a -ne 0 ] || [ $b -ne 0 ]; then echo "$m: killed (test-checker $a, driver $b) $f" >> $R/results.txt; else echo "$m: survived $f" >> $R/results.txt; fi
    rm -rf $d/build
done
echo done >> $R/results.txt
