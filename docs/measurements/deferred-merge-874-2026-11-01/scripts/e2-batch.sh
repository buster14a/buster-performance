#!/bin/bash
# E2 for #874: every named unit's fix and control cold reading, in one lock hold. Arguments: UNIT...
. ~/buster-fast-bench/874-verify/scripts/env.sh
for unit in "$@"; do
    for tree in fix control; do
        "$D/scripts/e2-one.sh" "$unit" "$tree"
    done
done
echo "e2 batch done $(date -Is)" >> "$D/logs/chain.txt"
