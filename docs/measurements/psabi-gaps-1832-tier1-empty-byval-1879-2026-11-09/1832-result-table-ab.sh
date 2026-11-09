#!/bin/bash
# #1832 item 5: benchmark-calling-convention --only classification, base vs head, alternating, one lock hold.
cd ~/buster-fast-bench/1832-claude-table
: > ab.log
for r in 1 2 3; do
  for v in base head; do
    echo "== $v round $r" >> ab.log
    taskset -c 2 ./$v benchmark-calling-convention --only classification >> ab.log 2>&1
  done
done
echo DONE >> ab.log
