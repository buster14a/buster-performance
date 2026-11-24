#!/bin/bash
# Each SCCP worklist mutant built alone, against test-ir-optimize, test-ir-source --passes, test-ssa-source and test-ir.
cd /home/user/buster
S=/tmp/claude-0/-home-user/76bde8b6-b9cb-5c1f-a0be-83249a201d89/scratchpad
SUB=$(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
for m in $(python3 $S/sccp-mut.py list); do
    git checkout -q -- src/buster/compiler/ir_optimize.c
    python3 $S/sccp-mut.py $m
    BUSTER_TOOLCHAIN=path ./build.sh > $S/mut-$m.build 2>&1 || { echo "$m: build failed"; continue; }
    line="$m:"
    for t in test-ir-optimize "test-ir-source --passes" test-ssa-source test-ir test-tier1-pipeline; do
        args=""; case "$t" in *source*) args="$SUB";; esac
        timeout 600 ./build/compiler $t $args > $S/mut-$m-${t%% *}.log 2>&1
        line="$line ${t%% *}${t#* }=$?"
    done
    echo "$line"
done
git checkout -q -- src/buster/compiler/ir_optimize.c
BUSTER_TOOLCHAIN=path ./build.sh > /dev/null 2>&1
echo done
