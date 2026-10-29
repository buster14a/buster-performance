#!/bin/bash
# 3-diag11.sh again, with clearpaths.py's totals by thread and path (3-diag11b.txt): the page clears in diag2's and
# diag5's cycle profiles (6 passes on eight lanes with every lane, h16x19.c) by thread,
# the fault path that cleared the page and the user frame under it (clearpaths.py): main3 and item2 with the state's
# arenas in huge pages, main3-nothp and item2-nothp in base pages, and final4 (diag9's); in one lock hold.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
~/buster-fast-bench/exclusive.sh bash -c '
D=/home/david/buster-fast-bench/697-cloud
for f in 3-diag2-main3 3-diag2-item2 3-diag5-main3-nothp-cycles 3-diag5-item2-nothp-cycles 3-diag9-final4-cycles; do
    echo "== $f" >> "$D/3-diag11b.txt"
    perf script -i "$D/$f.data" -F pid,tid,ip,sym 2>/dev/null | python3 "$D/clearpaths.py" >> "$D/3-diag11b.txt"
done' 2>> "$D/3-queue.lock.txt"
echo "3-diag11b done $(date -Is)" >> "$D/chain.out"
