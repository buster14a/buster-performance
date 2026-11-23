#!/bin/sh
# benchmark-debug, both paths, at main (68cc356a4): functions x rows, pinned to CPU 2, one locked run.
cd ~/buster-fast-bench/2924-linker/src
for f in 16 4096; do
  for r in 1 2 3 4 5 7 8 16 64; do
    echo "== functions $f rows $r"
    taskset -c 2 ./build/compiler benchmark-debug --functions $f --rows $r
  done
done
