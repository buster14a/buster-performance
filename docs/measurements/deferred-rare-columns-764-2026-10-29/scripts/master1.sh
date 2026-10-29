#!/bin/bash
# #764's first chain: the four trees' builds, then campaign D1 (diag9's units, 00200.c and sqlite3.c on 8 lanes with
# every lane, the four trees, five rounds, a round a lock hold, 30 s apart), then the attribution (one lock hold).
. ~/buster-fast-bench/claude-764/scripts/env.sh
"$D/scripts/build.sh" main-bc11fddb pr791-561e5f1c cols-2954544c multicols-865271ef
"$D/scripts/queue.sh" scripts/d1.jobs logs/D1.txt 1 0 5 8 30
~/buster-fast-bench/exclusive.sh "$D/scripts/attrib.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master1 done $(date -Is)" >> "$D/logs/chain.txt"
