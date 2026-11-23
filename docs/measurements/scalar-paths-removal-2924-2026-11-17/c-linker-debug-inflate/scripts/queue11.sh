#!/bin/sh
# Piece 1: -c -g objects again, all compiled in one directory, base (src, main) against head (head/), default and
# --scalar; after queue8 is done.
cd ~/buster-fast-bench/2924-linker
while pgrep -f "queue8.s[h]" > /dev/null; do sleep 5; done
for m in default scalar; do
  ./run.sh objects2-base-$m ./objects-g2.sh $PWD/src/build/compiler /dev/shm/2924-linker/base-$m $m
  ./run.sh objects2-head-$m ./objects-g2.sh $PWD/head/build/compiler /dev/shm/2924-linker/head-$m $m
  for l in sqlite lua musl; do
    total=$(ls /dev/shm/2924-linker/base-$m/$l | wc -l)
    differ=$(cd /dev/shm/2924-linker/base-$m/$l && for f in *; do cmp -s "$f" "/dev/shm/2924-linker/head-$m/$l/$f" || echo "$f"; done | wc -l)
    echo "$m $l: $differ of $total objects differ"
  done
done > objects2-compare.txt 2>&1
