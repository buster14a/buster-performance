#!/bin/bash
# #764's second chain: waits for master1c (its PID, the argument), builds multiall, then campaign A5 (A2's 43 units:
# multiall on 2, 3, 4 and 8 lanes with every lane, beside the base-page control, PR #791's head, and main on 8 lanes,
# five rounds).
. ~/buster-fast-bench/claude-764/scripts/env.sh
while kill -0 "$1" 2>/dev/null; do sleep 10; done
"$D/scripts/build.sh" multiall-95b241f5
if [ ! -x "$D/trees/multiall-95b241f5/build/compiler" ]; then
    echo "master2: multiall-95b241f5 has no build $(date -Is)" >> "$D/logs/chain.txt"
    exit 1
fi
"$D/scripts/a5.sh" multiall-95b241f5 pr791-561e5f1c main-bc11fddb
echo "master2 done $(date -Is)" >> "$D/logs/chain.txt"
