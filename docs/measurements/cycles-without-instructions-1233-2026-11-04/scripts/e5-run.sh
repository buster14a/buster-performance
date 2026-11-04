#!/bin/bash
# #1233 E5: E4's sixteen executables again, fresh copies in each hold: Lua's -c twice more, then Lua's -fsyntax-only.
set -u
R=$HOME/buster-fast-bench/1233-claude; L=$R/logs
echo $$ > $R/e5-run.pid
export EXCLUSIVE_OWNER=claude-1233 EXCLUSIVE_TITLE="#1233 cycles without instructions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1233
export EXPERIMENT=e4 OFFSETS="0000 0016 0032 0048 1040 2080 3120 4032"
for w in lua2 lua-syntax lua3; do
    ~/buster-fast-bench/exclusive.sh $R/e4.sh $w 10 > $L/e5-$w-hold.log 2>&1; echo "e5 $w hold status $?" >> $L/receipts.txt
    sleep 30
done
echo done > $L/e5-done
