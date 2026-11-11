#!/bin/bash
D=~/buster-fast-bench/2086-claude
cd $D/v2 || exit 1
L=$D/v2.log
$D/ex.sh . ./build.sh > $D/v2-build.log 2>&1; echo "build: $?" >> $L
cp build/compiler $D/bin/v2
$D/ex.sh . $D/bin/v2 test-parser > $D/v2-test-parser.log 2>&1; echo "test-parser: $?" >> $L
$D/ex.sh . $D/bin/v2 test-parser --scalar > $D/v2-test-parser-scalar.log 2>&1; echo "test-parser --scalar: $?" >> $L
$D/ex.sh . $D/bin/v2 test-parser --clang > $D/v2-test-parser-clang.log 2>&1; echo "test-parser --clang: $?" >> $L
echo "== v2 done $(date -u +%FT%TZ)" >> $L
