#!/bin/bash
# The outputs item of #777's "Done when" at a tree: test-check-units (every object and executable the same bytes at
# 1, 2, 3 and 8 lanes, each object its unit's alone, a few large units and many small ones), on CPUs 0 to 7, one hold.
# Usage: tests.sh TREE
. $(dirname $0)/common.sh
TREE=${1:?tree}
OUT=$W/tests-$TREE
rm -rf $OUT && mkdir -p $OUT && cd $W/$TREE
lock bash -c "taskset -c 0-7 ./build/compiler test-check-units > $OUT/test-check-units.log 2>&1; echo \"test-check-units: status \$?\""
grep -m5 -i "fail" $OUT/test-check-units.log
grep "shared parts\|left its memory" $OUT/test-check-units.log | head -5
tail -1 $OUT/test-check-units.log
echo tests-finished
