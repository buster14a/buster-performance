#!/bin/bash
# #1450 item 5, round 3: which symbols' instructions differ, a2 (9f416b20) against b2 (db03f52a), each one
# instructions:u profile of --tier1 -c sqlite3.c at a fixed period, one hold of the lock each.
set -u
W=~/buster-fast-bench/1450-claude
cd $W
until [ -f verify.done ]; do sleep 30; done
L="env EXCLUSIVE_OWNER=claude-1450 EXCLUSIVE_TITLE=GitHub_issue_1450 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1450 $HOME/buster-fast-bench/exclusive.sh"
SRC=~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c
for t in a2 b2; do
  $L taskset -c 2 perf record -q -e instructions:u -c 20000 -o symbols-$t.data ./$t/build/compiler --tier1 -c $SRC -o /dev/null > /dev/null 2>&1
  perf report -q -i symbols-$t.data --stdio --sort symbol -F sample,symbol 2>/dev/null > symbols-$t.txt
done
echo done > symbols.done
