#!/bin/bash
# The reader by the parser's tiles: its sink with the traversal, the expressions' walk, and the walk's columns cleared a
# tile ahead, alone and together, on a tree of their own.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
./setup2.sh 0632163005c26b3de47cdb86f1e815d2898e30b4 t6 t6.patch > setup-t6.log 2>&1
grep -q SETUP-DONE setup-t6.log || { echo "setup t6 failed"; exit 1; }
./run9.sh t6 t6-pair 3 'tiles|||' 'trav||BUSTER_EXPERIMENT_TILE_TRAVERSAL=1|' 'clears||BUSTER_EXPERIMENT_TILE_CLEARS=1|' 'travexpr||BUSTER_EXPERIMENT_TILE_TRAVERSAL=1,BUSTER_EXPERIMENT_TILE_EXPRESSIONS=1|' 'all||BUSTER_EXPERIMENT_TILE_TRAVERSAL=1,BUSTER_EXPERIMENT_TILE_EXPRESSIONS=1,BUSTER_EXPERIMENT_TILE_CLEARS=1|'
echo QUEUE-DONE
