#!/bin/bash
# After queue13: the reader's sink with its own traversal (on the scratch) and the expressions' walk by tiles, each alone
# and together, on a tree of their own.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
until grep -q "QUEUE-DONE\|failed" queue13.log; do sleep 15; done
./setup2.sh 0632163005c26b3de47cdb86f1e815d2898e30b4 t5 t5.patch > setup-t5.log 2>&1
grep -q SETUP-DONE setup-t5.log || { echo "setup t5 failed"; exit 1; }
./run9.sh t5 t5-pair 3 'tiles|||' 'sink||BUSTER_EXPERIMENT_TILE_SINK=1|' 'trav||BUSTER_EXPERIMENT_TILE_TRAVERSAL=1|' 'expr||BUSTER_EXPERIMENT_TILE_EXPRESSIONS=4096|' 'all||BUSTER_EXPERIMENT_TILE_TRAVERSAL=1,BUSTER_EXPERIMENT_TILE_EXPRESSIONS=4096|'
echo QUEUE-DONE
