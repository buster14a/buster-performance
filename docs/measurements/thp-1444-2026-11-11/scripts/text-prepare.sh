#!/bin/sh
# #1444 item 3: copies/plain-SHIFT and copies/huge-SHIFT of build NAME's placements, the second's text collapsed into
# huge folios in the page cache (collapse), for ab.sh without --copies.
#   text-prepare.sh NAME
set -e
d=~/buster-fast-bench/1444-claude-thp
mkdir -p $d/copies
for s in 0 1088 2112 3136; do
    cp $d/shifts-$1/compiler-$s $d/copies/plain-$s
    cp $d/shifts-$1/compiler-$s $d/copies/huge-$s
done
sync
for s in 0 1088 2112 3136; do $d/collapse $d/copies/huge-$s; done
