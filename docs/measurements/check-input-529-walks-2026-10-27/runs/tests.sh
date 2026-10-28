#!/bin/bash
# tests.sh TREE LIST OUT: TREE's checker tests (LIST, the parallel runner's format) under one hold of the lock, on
# CPUs 0-7 as the 9700X job runs them; c-testsuite fetched first, outside the lock.
set -e
base=~/buster-fast-bench/check-input-529b
tree=$base/$1
out=$base/$3
mkdir -p "$out"
if [ ! -d "$tree/build/c-testsuite/tests" ]; then
    git init -q --template= "$tree/build/c-testsuite"
    git -C "$tree/build/c-testsuite" fetch -q --depth 1 https://github.com/c-testsuite/c-testsuite 5c7275656d751de0e68b2d340a95b5681858ed07
    git -C "$tree/build/c-testsuite" checkout -q FETCH_HEAD
fi
cd "$tree"
$base/lock.sh bash -c "taskset -c 0-7 ./build/compiler parallel --timeout 300 $base/$2 > $out/tests.log 2>&1; echo status \$? >> $out/tests.log" 2>&1 | grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true
grep -E '^(== |status |parallel)' "$out/tests.log" | tail -40
