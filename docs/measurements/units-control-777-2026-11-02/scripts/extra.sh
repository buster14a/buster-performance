#!/bin/bash
# The tests of head 1 that final2.sh doesn't run, at a tree final2.sh built: test-check-lanes, test-checker-driver
# --executable, test-check-debug --cross-check; each locked for itself.
set -u
W=$HOME/buster-fast-bench/777-claude
TREE=${1:?tree}
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/1186" ~/buster-fast-bench/exclusive.sh "$@"; }
OUT=$W/extra-$TREE
rm -rf $OUT && mkdir -p $OUT
cd $W/$TREE
echo "tree $TREE commit $(cat COMMIT)"; sha256sum build/compiler
n=0
for t in "test-check-lanes" "test-checker-driver --executable ./build/compiler" "test-check-debug --cross-check"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep -m5 -i "fail" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
echo extra-finished
