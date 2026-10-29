#!/bin/bash
# #847: after B6, build diag847 and run the region diagnostic (one lock hold).
. ~/buster-fast-bench/claude-764/scripts/env.sh
while ! grep -q "^b6 done" "$D/logs/chain.txt"; do sleep 20; done
"$D/scripts/build.sh" diag847
~/buster-fast-bench/exclusive.sh "$D/scripts/diag847.sh" 00204 h16x10 h16x19 l16x19f192 l16x10f384 l8x38f384 d2x1f384s288 l16x19f384 x16x19 d2x1f480s240 > /dev/null 2>> "$D/logs/queue.lock.txt"
echo "master9 done $(date -Is)" >> "$D/logs/chain.txt"
