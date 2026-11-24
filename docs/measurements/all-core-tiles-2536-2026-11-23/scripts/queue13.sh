#!/bin/bash
# After queue12: the reader's passes before its walk in the parser's tile (the sink), alone and with the tree's columns.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
until grep -q "QUEUE-DONE\|failed" queue12.log; do sleep 15; done
./setup2.sh 0632163005c26b3de47cdb86f1e815d2898e30b4 t3 t2b.patch > setup-t3.log 2>&1
grep -q SETUP-DONE setup-t3.log || { echo "setup t3 failed"; exit 1; }
./run9.sh t3 t3-pair 3 'tiles|||' 'sink||BUSTER_EXPERIMENT_TILE_SINK=1|' 'cols||BUSTER_EXPERIMENT_TILE_COLUMNS=1|' 'both||BUSTER_EXPERIMENT_TILE_SINK=1,BUSTER_EXPERIMENT_TILE_COLUMNS=1|'
echo QUEUE-DONE
