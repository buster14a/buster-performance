#!/bin/bash
# #764's first chain, third start: waits for the builds already queued (their build.sh PIDs, the arguments), then runs
# thprace with --keep (one lock hold), campaign D1 (diag9's units, 00200.c and sqlite3.c on 8 lanes with every lane, the
# five trees, five rounds, a round a lock hold, 30 s apart) and the attribution (one lock hold).
. ~/buster-fast-bench/claude-764/scripts/env.sh
for pid in "$@"; do
    while kill -0 "$pid" 2>/dev/null; do sleep 5; done
done
for tree in main-bc11fddb pr791-561e5f1c cols-2954544c multicols-865271ef pop-98023033; do
    if [ ! -x "$D/trees/$tree/build/compiler" ]; then
        echo "master1c: $tree has no build $(date -Is)" >> "$D/logs/chain.txt"
        exit 1
    fi
done
~/buster-fast-bench/exclusive.sh "$D/tools/thprace-keep.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
"$D/scripts/queue.sh" scripts/d1.jobs logs/D1.txt 1 0 5 8 30
~/buster-fast-bench/exclusive.sh "$D/scripts/attrib.sh" > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master1c done $(date -Is)" >> "$D/logs/chain.txt"
