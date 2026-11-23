#!/bin/sh
# A/B at 1 to 8 rows: main's exact path (--only scalar), main's vector path and head's one writer, alternating
# processes, 5 rounds, CPU 2.
cd ~/buster-fast-bench/2924-linker
for round in 1 2 3 4 5; do
  for r in 1 2 3 4 8 64; do
    for f in 16 4096; do
      m=$(taskset -c 2 src/build/compiler benchmark-debug --functions $f --rows $r --only scalar | grep cycles/row | sed 's/.*; \([0-9.]*\) cycles\/row/\1/')
      v=$(taskset -c 2 src/build/compiler benchmark-debug --functions $f --rows $r --only vector | grep cycles/row | sed 's/.*; \([0-9.]*\) cycles\/row/\1/')
      h=$(taskset -c 2 head/build/compiler benchmark-debug --functions $f --rows $r | grep cycles/row | sed 's/.*; \([0-9.]*\) cycles\/row/\1/')
      echo "round $round functions $f rows $r: main-exact $m main-vector $v head $h cycles/row"
    done
  done
done
