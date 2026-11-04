#!/bin/bash
# #1233 E2's runner: one hold of the lock for e2.sh.
set -u
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e2-run.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
~/buster-fast-bench/exclusive.sh $R/e2.sh 30 > $L/e2-hold.log 2>&1; echo "e2 hold status $?" >> $L/receipts.txt
echo done > $L/e2-done
