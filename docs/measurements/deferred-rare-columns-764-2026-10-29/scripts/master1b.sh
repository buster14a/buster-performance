#!/bin/bash
# #764's first chain, again with a fifth tree: waits for master1's builds (build.sh's PID, the argument), builds pop,
# runs thprace with --keep (one lock hold), then campaign D1 (diag9's units, 00200.c and sqlite3.c on 8 lanes with
# every lane, the five trees, five rounds, a round a lock hold, 30 s apart), then the attribution (one lock hold).
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 5; done
"$D/scripts/build.sh" pop-98023033
~/buster-fast-bench/exclusive.sh "$D/tools/thprace-keep.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
"$D/scripts/queue.sh" scripts/d1.jobs logs/D1.txt 1 0 5 8 30
~/buster-fast-bench/exclusive.sh "$D/scripts/attrib.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master1b done $(date -Is)" >> "$D/logs/chain.txt"
