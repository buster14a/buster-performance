#!/bin/bash
# One mutant of the fault round (bin/mutants.py) in the head's tree: applied, built as the 9700X job builds it, the
# driver's quiet-roots section and the unused-result and for-loop sweeps' sections run against it, then taken off. One
# hold. The verdict line goes to results/fault/NAME.txt. Usage: fault-one.sh NAME
set -u
name=$1
cd ~/buster-fast-bench/1340-roots/head || exit 1
out=~/buster-fast-bench/1340-roots/results/fault; mkdir -p "$out"
clang=$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang 2>/dev/null | head -1)
[ "$name" = none ] || python3 ../bin/mutants.py apply "$name" || { echo "$name: the mutation didn't apply" > "$out/$name.txt"; exit 1; }
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$out/$name.build.log" 2>&1; built=$?
status=build-failed
if [ $built = 0 ]; then
    timeout -k 5 300 ./build/compiler test-checker-driver --executable ./build/compiler --quiet-roots-only --in-process ${clang:+--clang "$clang"} > "$out/$name.test.log" 2>&1
    status=$?
fi
git checkout -q -- . && git clean -fdq src
git apply ../bin/head.patch
echo "$name: test status $status; $(grep -c 'FAIL\|failed' "$out/$name.test.log" 2>/dev/null) lines of failure; $(tail -1 "$out/$name.test.log" 2>/dev/null)" > "$out/$name.txt"
