#!/bin/bash
# After the campaign: the driver test's four parts and check-call-graph on the final tree, then a baseline x86-64
# (scalar host) build of it and test-parser by that build. Each command its own hold of the lock.
D=~/buster-fast-bench/2086-claude
until grep -q 'after-clear done' $D/measure.log; do sleep 10; done
cd $D/final || exit 1
for part in 1 2 3 4; do
    $D/ex.sh . $D/bin/reuse test-checker-driver --executable $D/bin/reuse --part $part/4 --in-process > $D/final-checker-driver-$part.log 2>&1
    echo "checker-driver $part/4: status $?" >> $D/more.log
done
$D/ex.sh . ./build.sh check-call-graph > $D/final-check-call-graph.log 2>&1
echo "check-call-graph: status $?" >> $D/more.log
BUSTER_HOST_ARCH=x86-64 $D/ex.sh . ./build.sh > $D/build-x86-64.log 2>&1
echo "x86-64 build: status $?" >> $D/more.log
cp $D/final/build/compiler $D/bin/reuse-x86-64
$D/ex.sh . $D/bin/reuse-x86-64 test-parser > $D/x86-64-test-parser.log 2>&1
echo "x86-64 test-parser: status $?" >> $D/more.log
$D/ex.sh . $D/bin/reuse-x86-64 test-lexer > $D/x86-64-test-lexer.log 2>&1
echo "x86-64 test-lexer: status $?" >> $D/more.log
echo "== more done $(date -u +%FT%TZ)" >> $D/more.log
