#!/bin/bash
# #764's sixth chain: waits for master5b (its PID, the argument), then the source-order instruction counts (one hold).
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
~/buster-fast-bench/exclusive.sh "$D/scripts/soi.sh" head-95fc3668 main-bc11fddb > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master6 done $(date -Is)" >> "$D/logs/chain.txt"
