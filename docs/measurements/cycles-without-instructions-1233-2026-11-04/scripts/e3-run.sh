#!/bin/bash
# #1233 E3's runner: Lua's hold, then sqlite3.c's.
set -u
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e3-run.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
~/buster-fast-bench/exclusive.sh $R/e3.sh lua 10 > $L/e3-lua-hold.log 2>&1; echo "e3 lua hold status $?" >> $L/receipts.txt
sleep 30
~/buster-fast-bench/exclusive.sh $R/e3.sh sqlite 6 > $L/e3-sqlite-hold.log 2>&1; echo "e3 sqlite hold status $?" >> $L/receipts.txt
echo done > $L/e3-done
