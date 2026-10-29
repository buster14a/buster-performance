#!/bin/bash
# P01-raw-reach: builds the logging copy at -O1 and runs the probes, test-checker's and test-checker-driver's GNU
# sections with BUSTER_RAW_REACH set; prints the log's lines (none means S03's refusal never acted).
R=/home/david/.cache/claude-147/mutants7
D=$R/P01-raw-reach
Q=/home/david/.cache/claude-147/buster-performance/docs/measurements/local-labels-auto-type-147-2026-10-29/mutants7/probes
export CORES_TITLE="#147 __auto_type: raw binding reach" CORES_LINK=https://github.com/buster14a/buster/pull/840
unset CPATH C_INCLUDE_PATH
(cd $D && BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > $R/P01-raw-reach.build.log 2>&1) || { echo "build failed"; exit 1; }
export BUSTER_RAW_REACH=$R/P01-raw-reach.reach.txt
: > $BUSTER_RAW_REACH
for f in $Q/*.c; do $D/build/compiler -std=gnu23 -march=native -fsyntax-only $f > /dev/null 2>&1; done
echo "probes: $(wc -l < $BUSTER_RAW_REACH) lines"
(cd $D && ONLY_GNU=1 ./build/compiler test-checker > $R/P01-raw-reach.log 2>&1); a=$?
(cd $D && ONLY_GNU=1 ./build/compiler test-checker-driver --executable ./build/compiler >> $R/P01-raw-reach.log 2>&1); b=$?
echo "test-checker $a, driver $b: $(grep -E '^test-checker: [0-9]+ checks|^checker-driver: [0-9]+ checks' $R/P01-raw-reach.log | tr '\n' ' ')"
echo "all: $(wc -l < $BUSTER_RAW_REACH) lines"
sort $BUSTER_RAW_REACH | uniq -c | head -20
