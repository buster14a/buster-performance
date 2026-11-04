#!/bin/bash
# #1233 E4: four more checker offsets per tree, spread over the page (1040, 2080, 3120, 4032: one in each of the
# offsets' classes mod 64), built as E3's were; then all sixteen executables, E3's and these, measured as E3 measured
# them: Lua's hold, then sqlite3.c's.
set -u
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e4-run.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
OFFSETS="1040 2080 3120 4032" $R/e4-build.sh
[ $(grep -c -E "var-.* skip (1040|2080|3120|4032) build status 0" $L/receipts.txt) -eq 8 ] || { echo "e4 builds incomplete; not measuring" >> $L/receipts.txt; exit 1; }
export EXPERIMENT=e4 OFFSETS="0000 0016 0032 0048 1040 2080 3120 4032"
~/buster-fast-bench/exclusive.sh $R/e4.sh lua 10 > $L/e4-lua-hold.log 2>&1; echo "e4 lua hold status $?" >> $L/receipts.txt
sleep 30
~/buster-fast-bench/exclusive.sh $R/e4.sh sqlite 6 > $L/e4-sqlite-hold.log 2>&1; echo "e4 sqlite hold status $?" >> $L/receipts.txt
echo done > $L/e4-done
