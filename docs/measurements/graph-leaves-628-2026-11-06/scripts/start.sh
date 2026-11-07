#!/bin/bash
# start.sh: each tree's start and peak RSS on an empty file's -c, three runs each, interleaved; one hold.
cd ~/buster-fast-bench/628-claude-tesla
: > empty.c
export EXCLUSIVE_OWNER=claude-628-tesla EXCLUSIVE_TITLE="Solve 628: the graph's leaves" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
~/buster-fast-bench/exclusive.sh bash -c '
  for r in 1 2 3; do
    for t in main branch; do
      taskset -c 2 $t/build/compiler -c empty.c -o empty-$t.o --time-stages 2> start-$t-$r.txt
      printf "%s %s " $t $r; grep -h "peak-rss-start-kb\|peak-rss-kb" start-$t-$r.txt | cut -f2,3 | tr "\n" " "; echo
    done
  done' 2>&1 | grep -v "^exclusive.sh\|  title:\|  link:\|pull request"
