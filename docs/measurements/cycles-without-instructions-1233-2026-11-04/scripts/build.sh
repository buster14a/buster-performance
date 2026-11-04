#!/bin/bash
# #1233: build the record's two trees (main 754475d4, #1141's merge 4670b2eb) as it did, each in its own hold of the lock.
set -u
export LC_ALL=C
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs; mkdir -p $L
echo $$ > $R/build.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
for s in 754475d4 4670b2eb; do
    (cd $R/trees/tree-$s && ~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $L/holds.txt; env BUSTER_DEBUG_INFO=0 ./build.sh" > $L/build-$s.log 2>&1; echo "tree-$s build status $?" >> $L/receipts.txt)
    sha256sum $R/trees/tree-$s/build/compiler >> $L/receipts.txt
done
echo done > $L/build-done
