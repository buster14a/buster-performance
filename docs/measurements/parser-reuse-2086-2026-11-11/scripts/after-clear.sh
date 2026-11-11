#!/bin/bash
# Waits for the clearing variant's build, keeps its executable as bin/clear, then runs the campaign and test-parser
# --clang on the final executable (each run its own hold of the lock).
D=~/buster-fast-bench/2086-claude
until grep -q 'published as\|FAILED:\|ninja: build stopped' $D/build-clear.log; do sleep 10; done
grep -q 'published as' $D/build-clear.log || exit 1
cp $D/main/build/compiler $D/bin/clear
sha256sum $D/bin/* > $D/results-sha256.txt
$D/measure.sh > $D/measure.log 2>&1
cd $D/final && $D/ex.sh . taskset -c 2 $D/bin/reuse test-parser --clang > $D/final-test-parser-clang.log 2>&1
echo "== after-clear done $(date -u +%FT%TZ)" >> $D/measure.log
