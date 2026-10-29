#!/bin/bash
# 3-diag5.sh's fault reports again, with faultmaps3.py (its header lines end with the address's symbol), in a lock hold.
D=/home/david/buster-fast-bench/697-cloud
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): a diagnostic of item 2's lanes on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
~/buster-fast-bench/exclusive.sh bash -c '
D=/home/david/buster-fast-bench/697-cloud
for tree in item2-nothp main3-nothp; do
    perf script -i "$D/3-diag5-$tree-faults.data" --show-mmap-events -F tid,addr,ip,sym 2>/dev/null | python3 "$D/faultmaps3.py" > "$D/3-diag5-$tree-faultmap.txt"
done' >> "$D/3-diag5.txt" 2>&1
echo "3-diag5b done $(date -Is)" >> "$D/chain.out"
