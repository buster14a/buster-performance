#!/bin/bash
# #764's fourth chain: waits for master3 (its PID, the argument), then campaign SO5.
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/so5.sh" head-3b87d0c9 main-bc11fddb
echo "master4 done $(date -Is)" >> "$D/logs/chain.txt"
