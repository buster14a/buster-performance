#!/bin/sh
# The unwind tables' count, main (68cc356a4) against the experiment (exe/), alternating processes, CPU 2.
cd ~/buster-fast-bench/2924-linker
d=$(mktemp -d /tmp/2924-linker-ab.XXXXXX)
for round in 1 2 3 4 5; do
  taskset -c 2 src/build/compiler benchmark-executable --directory $d --functions 1,2,8,64,2000 --only links | grep "unwind tables" | sed "s/^/round $round main /"
  taskset -c 2 exe/build/compiler benchmark-executable --directory $d --functions 1,2,8,64,2000 --only links | grep "unwind tables" | sed "s/^/round $round exp  /"
done
rm -rf $d
