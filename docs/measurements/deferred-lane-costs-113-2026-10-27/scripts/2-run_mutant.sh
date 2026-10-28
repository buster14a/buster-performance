#!/bin/bash
# Builds mutant NAME of the merged tree (branch) at -O1 in its own directory and runs the suites it names, each of which
# must fail, in one lock hold (run under exclusive.sh): writes NAME.result with each suite exit status and failure line.
# The suites run with timeouts of TIMEOUT seconds (the deferred one) and 60 (test-lanes).
D=~/buster-fast-bench/113-lanes-cloud
M=$D/mutants
name="$1"
deferred_timeout="${2:-180}"
dir="$M/$name"
suites=$(python3 "$M/make_mutant.py" "$D/branch" "$name" "$dir") || { echo "$name: replacement failed" > "$M/$name.result"; exit 1; }
cd "$dir" || exit 1
export TMPDIR=$M/tmp
mkdir -p "$TMPDIR"
unset CPATH C_INCLUDE_PATH
start=$(date +%s)
if ! BUSTER_DEBUG_INFO=0 ./build.sh > build.txt 2>&1; then
    echo "$name: build failed" > "$M/$name.result"
    exit 1
fi
built=$(date +%s)
: > "$M/$name.result"
for suite in $suites; do
    if [ "$suite" = lanes ]; then
        timeout 60 taskset -c 0-7 ./build/compiler test-lanes > lanes.txt 2>&1
        status=$?
        line=$(grep -E "wrong|failed|fail" lanes.txt | grep -v " 0 wrong\| 0 failed" | head -2 | tr "\n" " ")
    else
        timeout "$deferred_timeout" taskset -c 0-7 ./build/compiler test-checker-deferred > deferred.txt 2>&1
        status=$?
        line=$(tail -1 deferred.txt)
    fi
    echo "$name $suite exit=$status $line" >> "$M/$name.result"
done
echo "$name build=$((built - start))s total=$(( $(date +%s) - start ))s" >> "$M/$name.result"
