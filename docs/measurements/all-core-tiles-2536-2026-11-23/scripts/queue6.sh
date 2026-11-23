#!/bin/bash
# The lean queue: the pages' pair on the medium tree, the tiles tree's build, the tiles' pair.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
mkdir -p results
./run5.sh medium pair-pages plain:never medium:madvise:BUSTER_HUGE_PAGES=medium
./setup2.sh b7d0b5ed tiles tiles2.patch > setup-tiles.log 2>&1
grep -q SETUP-DONE setup-tiles.log || { echo "setup failed"; exit 1; }
./run5.sh tiles pair-tiles whole:never t4096:never:BUSTER_PARSE_TILE=4096 t1024:never:BUSTER_PARSE_TILE=1024 t16384:never:BUSTER_PARSE_TILE=16384
./run5.sh tiles pair-both whole:never both:madvise:BUSTER_PARSE_TILE=4096,BUSTER_HUGE_PAGES=medium
cat /sys/kernel/mm/transparent_hugepage/hugepages-64kB/enabled
echo QUEUE-DONE
