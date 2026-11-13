#!/bin/bash
# #2626's confirmation over placements: the largest movers of the triage (ir, assembler) and its largest gain
# (ir-optimize-passes), each bench.sh comparison (base, head and base-again at four placements, 7 runs) its own hold.
d=$HOME/buster-fast-bench/2626-claude
for name in ir assembler ir-optimize-passes; do
    "$d/scripts/lock.sh" "$d/scripts/bench.sh" "$name" 7
done
echo bench-done > "$d/results/bench-done"
