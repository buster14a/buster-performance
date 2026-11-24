#!/bin/sh
# benchmark-executable at main (68cc356a4), pinned to CPU 2, by the vector path and with --exact. $1: --functions list.
cd ~/buster-fast-bench/2924-linker/src
d=$(mktemp -d /tmp/2924-linker-exe.XXXXXX)
for round in 1 2; do
  echo "== round $round vector"; taskset -c 2 ./build/compiler benchmark-executable --directory $d --functions "$1"
  echo "== round $round exact"; taskset -c 2 ./build/compiler benchmark-executable --directory $d --functions "$1" --exact
done
rm -rf $d
